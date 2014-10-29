{
  Unit for handling work entries which are hold by a single connected  list.
  Call Reset to reset the memory.
  This unit can handle as much entries as the caller wishes, depends on the 
  available memory.
}
UNIT WorkManagementUnit;

{ ######################### Interface part ######################### }
INTERFACE
  
{ Uses the time span unit }
USES TImeSpanUnit;

{ 
  The types which are visible and usable for the caller.
}
TYPE  
  { The error codes which can be handled by the caller }
  ErrorCode = (NONE, TO_SHORT, TO_LONG, INVALID_SPAN);
  
  { Compound representing a work entry }
  WorkEntry = RECORD
    name: STRING;
    task: STRING;
    spendTime: TimeSpan;
  END;
  
{ 
  Resets the memory of this module
}
PROCEDURE Reset;

{
  Creates a work entry for the given data.
  
  @param
      name: the name of the person
  @param
      task: the name of the task the person worked on
  @param
      spendTime: the TimeSpan instance which represents the time the person has worked 
      on the defined task
  @return
      the create workEntry instance
}
FUNCTION CreateWorkEntry(name, task: STRING; spendTime: TimeSpan): WorkEntry;

{
  Adds a WorkEntry to the backed list.
  
  @param 
      entry: the entry to be added
  @param
      error: the error parameter which will be set <> NONE if an error occurs
  @returns
      the occurred error or the given error from the caller which should be NONE
}
PROCEDURE AddWorkEntry(entry: WorkEntry; VAR error: ErrorCode);

{
  Gets the total work time for the given person.
  
  @param
      name: the name of the person
  @param
      spendtime: the TimeSpan instance given by the caller which will get set with the total work time,
      should be initialized by the caller with 0:0:0
  @return
      the TimeSpan representing the total work time, or all values set to 0 when the person would not be found,
      or no entry exists
}
PROCEDURE GetTotalWorkTimeForPerson(name: STRING; VAR spendTime: TimeSpan);

{
  Gets the average time worked on a task.
  
  @param
      task: the task to get the average work time for
  @param
      average: the TimeSpan instance where the result will be saved, shall be initialized by the
      caller with 0:0:0
  @return 
      the TimeSpan instance which contains the average time worked on the task, or all field set to 0, 
      if the task could not be found, because there can no task be present in the entry holder which has
      a time spend less than 1 minute.
}
PROCEDURE GetAverageWorkTimeForTask(task: STRING; VAR average: TimeSpan);

{
  Prints the persons which has worked on the task, along with their time spend.
  
  @param
      task: the task to be printed.
}
PROCEDURE PrintPersonForTask(task: STRING);

{
  Prints the work summary for the given person.
  
  @param
      name: the name of the persos to search for the work summary
}
PROCEDURE PrintWorkSummaryForPerson(name: STRING);

{
  Gets the name of the person with the most time spent on the saved tasks.
  
  @return 
      the name of the busiest person
}
FUNCTION BusiestPerson: STRING;

{ ######################## Implementation part ######################## }
IMPLEMENTATION  

TYPE
  { The pointer type used for the work entry list nodes }
  TimeRegistrationEntry = ^TimeRegistrationEntryRec;
  { The node type }
  TimeRegistrationEntryRec = RECORD
    entry: WorkEntry;
    next: TimeRegistrationEntry;
  END;
  { Separate pointer type for the work entry list }
  TimeRegistrationEntryList = TimeRegistrationEntry;
  
  { The pointer type for the time registration count list nodes }
  TimeRegistrationCount = ^TimeRegistrationCountRec;
  { The type for the time registration count node }
  TimeRegistrationCountRec = RECORD
    name: STRING;
    count: INTEGER;
    next: TimeRegistrationCount;
  END;
  { Separate pointer type for the time registration count list }
  TimeRegistrationCountList = TimeRegistrationCount;

{
  The memory which contains the work entries, represented by a list
}
VAR
  list: TimeRegistrationEntryList;

{ ######################### Private Function/Procedure part ######################### }
{
  Creates a TimeRegistrationEntry node instance.
  ATTENTION: Be aware that the created instance has to be disposed manually.
  
  @param
      entry: The WorkEntry instance hold the by the node
  @return
      the created TimeRegistrationEntry instance
}
FUNCTION CreateTimeRegistrationEntryNode(entry: WorkEntry): TimeRegistrationEntry;
BEGIN
    CreateTimeRegistrationEntryNode := new(TimeRegistrationEntry);
    CreateTimeRegistrationEntryNode^.entry := entry;
    CreateTimeRegistrationEntryNode^.next := NIL;
END;

{
  Creates a TimeRegistrationCount instance.
  ATTENTION: Be aware that the created instance has to be disposed manually.
  
  @param
      name: the name for the TimeRegistrationCount instance
  @param
      count: the count for the TimeRegistrationCount instance
  @return
      the created TimeRegistrationCount instance.     
}
FUNCTION CreateTimeRegistrationCountNode(name: STRING; count: LONGINT): TimeRegistrationCount;
BEGIN
    CreateTimeRegistrationCountNode := new(TimeRegistrationCount);
    CreateTimeRegistrationCountNode^.name := name;
    CreateTimeRegistrationCountNode^.count := count;
    CreateTimeRegistrationCountNode^.next := NIL;
END;

{
  Finds the TimeRegistrationCount instance contained in the given list, for the given name.
  The name is handled with ignoreCase.
  Used because the backed TimeRegistrationEntryList could not contain sorted entries (sorted by name).
  
  @param
      name: the name set on the TimeRegistrationCount of the given list
  @param
      tempList: the given list to search for the set name.
  @return
      the found TimeRegistrationCount instance or NIL if the instance could not be found, or the given
      tempList is NIL.
}
FUNCTION FindTimeRegistryCountByName(name: STRING; tempList: TimeRegistrationCountList): TimeRegistrationCount;
VAR
  node: TimeRegistrationCount;
  found: BOOLEAN;
BEGIN
  found := false;
  FindTimeRegistryCountByName := NIL; 
  node := NIL;
  
  IF (tempList <> NIL) THEN BEGIN
    node := tempList;
    WHILE ((found = false) AND (node <> NIL)) DO BEGIN
      IF (name = node^.name) THEN BEGIN
        FindTimeRegistryCountByName := node;
        found := true;
      END
      ELSE BEGIN
        node := node^.next;
      END;
    END;
  END;
END;

{
  Gets the TimeRegistrationCount instance with the highest count value.
  If multiple instances do have the same count, then the first one is returned
  and the others are ignored.
  
  @param
      tempList: the TimeRegistrationCountList instance where to search for the highest contained count.
  @return
      the TimeRegistrationCount with the highest count value, or NIL otherwise
}
FUNCTION GetHighestTimeRegistryCount(tempList: TimeRegistrationCountList): TimeRegistrationCount;
VAR
  node: TimeRegistrationCount;
  count: LONGINT;
BEGIN
  GetHighestTimeRegistryCount := NIL;
  count := 0;
  
  IF (tempList <> NIL) THEN BEGIN
    node := tempList;
    WHILE (node^.next <> NIL) DO BEGIN
      (* writeln(node^.name, ' - ', node^.count); *)
      IF (count < node^.count) THEN BEGIN
        count := node^.count;        
        GetHighestTimeRegistryCount := node;
      END;
      node := node^.next;
    END;
  END;
  
END;

{
  Disposes all contained entries of the given TimeRegistrationCountList list.
  
  @param
      list: the list which elements shall be disposed
  @return
      list: the disposed list, which will be set to NIL.
}
PROCEDURE DisposeTempList(VAR countList: TimeRegistrationCountList);
VAR 
  pred, succ: TimeRegistrationCount;
BEGIN
  pred := countList;
  { WriteLn(''); }
  WHILE (pred <> NIL) DO BEGIN
    succ := pred^.next;
    Dispose(pred);
    { WriteLn('Count Entry disposed'); }
    pred := succ;
  END;
  { WriteLn(''); } 
  countList := NIL;
END;

{ ######################### Public Function/Procedure part ######################### }
{ Reset memory }
PROCEDURE Reset;
VAR
  pred, succ: TimeRegistrationEntry;
BEGIN
  pred := list;
  WHILE (pred <> NIL) DO BEGIN
    succ := pred^.next;
    Dispose(pred);
    { WriteLn('Work Entry disposed'); }
    pred := succ;
  END;
  list := NIL;
END;

{ Creates a WorkEntry instance }
FUNCTION CreateWorkEntry(name, task: STRING; spendTime: TimeSpan): WorkEntry;
BEGIN
  CreateWorkEntry.name := name;
  CreateWorkEntry.task := task;
  CreateWorkEntry.spendTime := spendTime;
END;

{ Adds the work entry to the memory}
PROCEDURE AddWorkEntry(entry: WorkEntry; VAR error: ErrorCode);
VAR
  newNode, node: TimeRegistrationEntry;
BEGIN
  { Converts the time span to seconds, and will contain any error }
  entry.spendTime := TimeSpanToSeconds(entry.spendTime);
  { Invalid time span detected }
  IF (entry.spendTime.error <> '') THEN BEGIN
    error := INVALID_SPAN
  END
  { To less time span }
  ELSE IF (entry.spendTime.timeInSeconds < 60) THEN BEGIN
    error := TO_SHORT
  END
  { To much time }
  ELSE IF (entry.spendTime.timeInSeconds > (8 * 60 * 60)) THEN BEGIN
    error := TO_LONG
  END
  { valid to add entry }
  ELSE BEGIN
    newNode := CreateTimeRegistrationEntryNode(entry);
    { First element }
    IF (list = NIL) THEN BEGIN
      list := newNode;
    END
    ELSE BEGIN
      node := list;
      WHILE (node^.next <> NIL) DO BEGIN
        node := node^.next;
      END;
      node^.next := newNode;
    END;
  END;
END;

{ Gets total work time }
PROCEDURE GetTotalWorkTimeForPerson(name: STRING; VAR spendTime: TimeSpan);
VAR
  node: TimeRegistrationEntry;
  sec: LONGINT;
  entry: WorkEntry;
BEGIN
  sec := 0;
  { Only get total time when entries are present }
  IF (list <> NIL) THEN BEGIN
    node := list;
    WHILE (node <> NIL) DO BEGIN
      entry := node^.entry;
      { Build sum for the given name }
      IF (LowerCase(entry.name) = LowerCase(name)) THEN BEGIN
        sec := sec + TimeSpanUnit.TimeSpanToSeconds(entry.spendTime).timeInSeconds;
      END;
      node := node^.next;
    END;
  END;
  
  spendTime := TimeSpanUnit.SecondsToTimeSpan(sec);
END;

{ Gets average of spend time }
PROCEDURE GetAverageWorkTimeForTask(task: STRING; VAR average: TimeSpan);
VAR
  node: TimeRegistrationEntry;
  sec: LONGINT;
  count: INTEGER;
  entry: WorkEntry;
BEGIN
  sec := 0;
  count := 0;
  average.timeInSeconds := 0;
  
  { Only get average time when entries are present }
  IF (list <> NIL) THEN BEGIN
    node := list;
    WHILE (node <> NIL) DO BEGIN
      entry := node^.entry;
      { Search for this task }
      IF (entry.task = task) THEN BEGIN
        sec := sec + TimeSpanUnit.TimeSpanToSeconds(entry.spendTime).timeInSeconds;
        Inc(count);
      END; 
      node := node^.next;
    END;
  END;
  
  { Calculate the average if the task on working persons have been found }
  IF (sec <> 0) THEN BEGIN
    sec := (sec DIV count); 
  END;
  
  { Create time span out of seconds }
  average := TimeSpanUnit.SecondsToTimeSpan(sec);
END;

{ Print persons for task to table }
PROCEDURE PrintPersonForTask(task: STRING);
VAR
  node: TimeRegistrationEntry;
  found: BOOLEAN;
  count: INTEGER;
  entry: WorkEntry;
  name: STRING;
BEGIN
  found := false;
  count := 0;
  name := '';
  
  WriteLn('################### Persons working on task ###################');
  WriteLn('Task    : ', task);
  WriteLn('Persons : ');
  
  { Only print result if there are entries available }
  IF (list <> NIL) THEN BEGIN
    node := list;
    WHILE (node <> NIL) DO BEGIN
      entry := node^.entry;
      { Search for this task }
      IF (entry.task = task) THEN BEGIN
        IF NOT found THEN BEGIN
          found := true;
        END;
        IF (entry.name <> name) THEN BEGIN
          name := entry.name;
          Inc(count);
          WriteLn('          ', count, ': ', name);
        END;
      END;
      node := node^.next;
    END;
  END;
  { Either no entries or task not found }
  IF (NOT found) THEN BEGIN
    WriteLn('          No work entries found for the task !!!');
  END;
  WriteLn('################### Persons working on task ###################');
END;

{ Print work summary for a person }
PROCEDURE PrintWorkSummaryForPerson(name: STRING);
VAR
  node: TimeRegistrationEntry;
  found: BOOLEAN;
  entry: WorkEntry;
BEGIN
  found := false;
  
  WriteLn('################### Work summary for person ###################');
  WriteLn('Person : ', name);
  
  { Only print result if entries are available }
  IF (list <> NIL) THEN BEGIN
    node := list;
    WHILE (node <> NIL) DO BEGIN
      entry := node^.entry;
      { Search for this person }
      IF (entry.name = name) THEN BEGIN
        WriteLn('         Task: ', entry.task:15, ' | Spend time: ', TimeSpanUnit.TimeSpanToString(entry.spendTime)); 
        found := true;
      END; 
      node := node^.next;
    END;
  END;
  { Either no entries or person not found }
  IF (NOT found) THEN BEGIN
    WriteLn('         No work entries found for the person !!!':10);
  END;
  WriteLn('################### Work summary for person ###################');
END;

{ Get busiest person }
FUNCTION BusiestPerson: STRING;
VAR
  tempList: TimeRegistrationCountList;
  tempNode, itNode, result: TimeRegistrationCount;
  node: TimeRegistrationEntry;
  entry: WorkEntry;
  i: INTEGER;
BEGIN
  BusiestPerson := '';
  tempList := NIL;
  itNode := NIL;
  i := 0;
  
  IF (list <> NIL) THEN BEGIN
    node := list;
    { iterate over all work entries }
    WHILE (node <> NIL) DO BEGIN
      Inc(i);
      entry := node^.entry;
      { writeln(i, '-node: ', entry.name); }
      { Search if entry already exists }
      tempNode := FindTimeRegistryCountByName(entry.name, tempList);
      { No entries has been found for the current name }
      IF (tempNode = NIL) THEN BEGIN
        tempNode := CreateTimeRegistrationCountNode(entry.name, 1);
        { writeln(i, '-new: ', tempNode^.name, ' - ', tempNode^.count); }
        { Add entry to empty list }
        IF (tempList = NIL) THEN BEGIN
          tempList := tempNode;
          { writeln(i, '-first: ', tempList^.name); }
        END
        { Add entry to not empty list }
        ELSE BEGIN
          itNode := tempList;
          WHILE (itNode^.next <> NIL) DO BEGIN
            { writeln(i, '-iterate: ', itNode^.next^.name); }
            itNode := itNode^.next;
          END;
          itNode^.next := tempNode;
          { writeln(i, '-added: ', itNode^.next^.name); }
        END;
      END
      ELSE BEGIN
        { Increase count by one }
        tempNode^.count := tempNode^.count + 1; 
        { writeln(i, '-found: ', tempNode^.name, ' - ', tempNode^.count); }
      END;
      node := node^.next;
    END;
    
    { Get the entry with the highest count value }
    result := GetHighestTimeRegistryCount(tempList);
    { Get person name if entry has been found }
    IF (result <> NIL) THEN BEGIN
      BusiestPerson := result^.name;
    END;
      
    { Dispose list elements and the list }
    DisposeTempList(tempList);
  END;
END;

BEGIN
  { Set list to null as default }
  list := NIL;
END.