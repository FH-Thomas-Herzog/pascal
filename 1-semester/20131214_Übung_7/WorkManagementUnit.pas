{
  Unit for handling work entries which are hold by a double linked cyclic list with anchor.
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
  
  { Compound representing a work entry, which is only used by the caller for adding a entry }
  WorkEntry = RECORD
    name: STRING;
    task: STRING;
    spendTime: TimeSpan;
  END;
  
{ 
  Resets the memory of this module by disposing all elements of the list and also disposing all elements
  of any contained list of the elements.
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
      spendTime: the TimeSpan instance given by the caller which will get set with the total work time,
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
      name: the name of the persons to search for the work summary
}
PROCEDURE PrintWorkSummaryForPerson(name: STRING);

{
  Gets the name of the person with the most time spent on the saved tasks.
  
  @return 
      the name of the busiest person
}
FUNCTION BusiestPerson: STRING;

{
  Removes all saved entries of a person.
  
  @param
      name: the name of the person
  @return 
      true if the person has been removed, false otherwise
}
FUNCTION DeletePerson(name: STRING): BOOLEAN;

{
  Gets the count of all backed work entries.
  
  @return 
      the count of all work entries
}
FUNCTION GetTotalWorkEntryCount: LONGINT;

{ ######################## Implementation part ######################## }
IMPLEMENTATION  

TYPE
  { Pointer to a WorkItemNode }
  WorkItemNode = ^WorkItem;
  { Compound representing a work item for the person }
  WorkItem = RECORD
    task: STRING;
    spendTime: TimeSpan;
    next: WorkItemNode;
  END;
  { Pointer to a list of WorkItemNode }
  WorkItemList = WorkItemNode;
  
  { Pointer to a PersonItem }
  PersonItemNode = ^PersonItem;
  { Compound representing the person in the backed list }
  PersonItem = RECORD
    name: STRING;
    { WrokItemList with all work items related to this person }
    workItems: WorkItemList;
    prev, next: PersonItemNode;
  END;
  { Pointer to the list of PersonItem }
  PersonItemList = PersonItemNode;

{
  The memory which contains the persons saved in the system.
  Implemented as a double linked cyclic list with anchor
}
VAR
  list: PersonItemList;

{ ######################### Private Function/Procedure part ######################### }
{
  Creates a WorkItem instance.
  
  @param
      entry the WorkEntry instance to create the WorkItem instance for
  @return
      the created WorkItem instance
}
FUNCTION CreateWorkItemNode(entry: WorkEntry): WorkItemNode;
VAR
  node: WorkItemNode;
BEGIN
  New(node);
  node^.task := LowerCase(entry.task);
  node^.spendTime := entry.spendTime;
  node^.next := NIL;
  CreateWorkItemNode := node;
END;

{
  Creates a PersonItem instance.
  
  @param
      entry: the entry to create PersonItem instance for
  @return
      the created PersonItem instance
}
FUNCTION CreatePersonItemNode(entry: WorkEntry): PersonItemNode;
VAR
  node: PersonItemNode;
BEGIN
  New(node);
  node^.name := LowerCase(entry.name);
  node^.workItems := CreateWorkItemNode(entry);
  node^.prev := node;
  node^.next := node;
  CreatePersonItemNode := node;
END;

{
  Adds a PersonItem instance to the backed list.
  
  @param
      entry the WorkEntry instance to create a PersonItem instance for which gets added to the backed list
}
PROCEDURE AppendPersonNode(entry: WorkEntry);
VAR
  node: PersonItemNode;
BEGIN
  node := CreatePersonItemNode(entry);
  node^.next := list;
  node^.prev := list^.prev;
  list^.prev^.next := node;
  list^.prev := node;
END;

{ 
  Adds a WorkItemNode instance to the beginning of the WrokItemList of the PersonItem.
  It is assumed that the given PeronItem contains at least one WorkItem which is guaranteed by the implementation.
  
  @param
      person: the person to add the WorkItemNode instance to its backed workItem list
  @param
      entry: the entry which contains the information for the WorkItemNode instance
}
PROCEDURE PrependWorkItemNode(person: PersonItemNode; entry: WorkEntry);
VAR
  node: WorkItemNode;
BEGIN
  node := CreateWorkItemNode(entry);
  node^.next := person^.workItems;
  person^.workItems := node;
END;

{
  Disposes all WorkItemNode of the given WorkItemList instance.
  
  @param
      workItemList: the list of WorkItemNode instances
  @return 
      the disposed WorkitemList which is being to be NIL
}
PROCEDURE DisposeWorkItemList(VAR workItemList: WorkItemList);
VAR
  next: WorkItemNode;
BEGIN
  (* { Test output begin }
  IF (workItemList = NIL) THEN BEGIN
    WriteLn('No WorkItems to dispose');
  END;
  { Test output end } *)
  
  WHILE (workItemList <> NIL) DO BEGIN
    next := workItemList^.next;
    (* WriteLn('Dispose WorkItem: ', workItemList^.task:15, ' | spendTime: ', TimeSpanUnit.TimeSpanToString(workItemList^.spendTime)); *)
    Dispose(workItemList);
    workItemList := next;
  END;
END;

{
  Finds a person by its name.
  
  @param
      name: the name of the person which will be handled with lower case
  @return
      the PersonItemNode if the person could  be found NIL otherwise
}
FUNCTION FindPersonItemNodeForName(name: STRING): PersonItemNode;
VAR
  node: PersonItemNode;
  lowerName: STRING;
BEGIN
  lowerName := LowerCase(name);
  FindPersonItemNodeForName := NIL;
  
  node := list^.next;
  WHILE ((node <> list) AND (node^.name <> lowerName)) DO BEGIN
    node := node^.next;
  END;
  { Check if name has been found and exclude anchor }
  IF (node <> list) THEN BEGIN
    FindPersonItemNodeForName := node;
  END;
END;

{
  Finds the WorkItems of the given PersonItemNode instance for the given task.
  ATTENTION: The returned list needs to be disposed
  
  @param
      person: the PersonItemNode instance to search for the given task on its WorkItemList
  @param
      task: the task to be searched
  @return
      the created WorkItemList instance if at least one entry for the task could be found, NIL otherwise
}
FUNCTION FindWorkItemNodesForTask(person: PersonItemNode; task: STRING): WorkItemList;
VAR
  node, newNode: WorkItemNode;
  itemList: WorkItemList;
  lowerTask: STRING;
BEGIN
  itemList := NIL;
  lowerTask := LowerCase(task);
  
  node := person^.workItems;
  WHILE (node <> NIL) DO BEGIN
    IF (node^.task = lowerTask) THEN BEGIN
      { Clone WorkItem node and put into temp list}
      New(newNode);
      newNode^.task := node^.task;
      newNode^.spendTime := node^.spendTime;
      newNode^.next := NIL;
      IF (itemList = NIL) THEN BEGIN
        itemList := newNode;
      END
      ELSE BEGIN
        newNode^.next := itemList;
        itemList := newNode;
      END;
    END;
    node := node^.next;
  END;
  
  FindWorkItemNodesForTask := itemList;
END;

{
  Answers the question if the given PersonItemNode instance contains at leat one WrokItemNode instance within its workItems
  for the given task.
  
  @param
      person: the PersonItemNode instance to search for the given task on its workItems
  @param
      task: the task to search for
  @retrun
      true if the PersonItemNode instance contains at least one WorkItemNode instance with the given task defined, false otherwise
}
FUNCTION PersonHasTask(person: PersonItemNode; task: STRING): BOOLEAN;
VAR
  node: WorkItemNode;
  lowerTask: STRING;
BEGIN
  lowerTask := LowerCase(task);
  
  node := person^.workItems;
  WHILE ((node <> NIL) AND (node^.task <> lowerTask)) DO BEGIN
    node := node^.next;
  END;
  PersonHasTask := (node <> NIL);
END;

{
  Gets the sum of all TimeSpan instances hold by the WorkItemNodes and also the count of WorkItem in the list
  
  @param
      itemList: the list of WorkItemNode to sum their backed TimeSpan instances
  @param
      the seconds to build the summary
  @param
      the count to increase by one for each WorkItemNode
  @return
      the sum of all TimeSpan instances and the count of entries of the given WorkItemList.
}
PROCEDURE SumSpendTimeOfWorkItemList(itemList: WorkItemList; VAR seconds: LONGINT; VAR count: LONGINT);
BEGIN
  WHILE (itemList <> NIL) DO BEGIN
    seconds := seconds + TimeSpanUnit.TimeSpanToSeconds(itemList^.spendTime).timeInSeconds;
    Inc(count);
    itemList := itemList^.next;
  END;
END;

{ ######################### Public Function/Procedure part ######################### }
{ Reset memory }
PROCEDURE Reset;
VAR
  node, next: PersonItemNode;
BEGIN
  node := list^.next;
  
  (* { Test output begin }
  WriteLn;
  WriteLn('---------------------');
  WriteLn('Disposing all Persons');
  WriteLn('---------------------');
  IF (node = list) THEN BEGIN
    WriteLn('No Persons to dispose');
    WriteLn;
  END;
  { Test output end } *)
  
  WHILE (node <> list) DO BEGIN
    next := node^.next;
    (* WriteLn('Dispose WorkItems for: ', node^.name:10); *)
    DisposeWorkItemList(node^.workItems);
    (* WriteLn('Dispose Person: ', node^.name:10); 
    WriteLn;*)
    Dispose(node);
    node := next;
  END;
  list^.prev := list;
  list^.next := list;
END;

{ Creates a WorkEntry instance }
FUNCTION CreateWorkEntry(name, task: STRING; spendTime: TimeSpan): WorkEntry;
BEGIN
  CreateWorkEntry.name := LowerCase(name);
  CreateWorkEntry.task := LowerCase(task);
  CreateWorkEntry.spendTime := spendTime;
END;

{ Adds the work entry to the memory}
PROCEDURE AddWorkEntry(entry: WorkEntry; VAR error: ErrorCode);
VAR
  person: PersonItemNode;
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
    person := FindPersonItemNodeForName(entry.name);
    { If a entry already exists for the given name }
    IF (person <> NIL) THEN BEGIN
      PrependWorkItemNode(person, entry);
    END
    { If new person has to be added }
    ELSE BEGIN
      AppendPersonNode(entry);
    END;
  END;
END;

{ Gets total work time }
PROCEDURE GetTotalWorkTimeForPerson(name: STRING; VAR spendTime: TimeSpan);
VAR
  node: PersonItemNode;
  sec, count: LONGINT;
BEGIN
  sec := 0;
  count := 0;
  
  node := FindPersonItemNodeForName(name);
  IF (node <> NIL) THEN BEGIN
    SumSpendTimeOfWorkItemList(node^.workItems, sec, count);
  END;
  
  spendTime := TimeSpanUnit.SecondsToTimeSpan(sec);
END;

{ Gets average of spend time }
PROCEDURE GetAverageWorkTimeForTask(task: STRING; VAR average: TimeSpan);
VAR
  node: PersonItemNode;
  items: WorkItemList;
  sec, count: LONGINT;
BEGIN
  sec := 0;
  count := 0;
  average.timeInSeconds := 0;
  
  { Only get average time when entries are present }
  node := list^.next;
  WHILE (node <> list) DO BEGIN
    { Search for this task }
    items := FindWorkItemNodesForTask(node, task);
    { Build sum over the Work Items }
    SumSpendTimeOfWorkItemList(items, sec, count);
    { Dispose WorkItem List because it has been copied as interface spec says }
    DisposeWorkItemList(items);
    node := node^.next;
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
  node: PersonItemNode;
  count: INTEGER;
BEGIN
  count := 0;
  
  WriteLn('################### Persons working on task ###################');
  WriteLn('Task    : ', task);
  WriteLn('Persons : ');
  
  { Only print result if there are entries available }
  node := list^.next;
  WHILE (node <> list) DO BEGIN
    { Search for this task }
    IF (PersonHasTask(node, task)) THEN BEGIN
      Inc(count);
      WriteLn('          ', count, ': ', node^.name);
    END;
    node := node^.next;
  END;
  { Either no entries or task not found }
  IF (count = 0) THEN BEGIN
    WriteLn('          No work entries found for the task !!!');
  END;
  WriteLn('################### Persons working on task ###################');
END;

{ Print work summary for a person }
PROCEDURE PrintWorkSummaryForPerson(name: STRING);
VAR
  person: PersonItemNode;
  node: WorkItemNode;
BEGIN
  
  WriteLn('################### Work summary for person ###################');
  WriteLn('Person : ', name);
  
  { Only print result if a entry for the person exists }
  person := FindPersonItemNodeForName(name);
  IF (person <> NIL) THEN BEGIN
    node := person^.workItems;
    WHILE (node <> NIL) DO BEGIN
      WriteLn('         Task: ', node^.task:15, ' | Spend time: ', TimeSpanUnit.TimeSpanToString(node^.spendTime)); 
      node := node^.next;
    END;
  END
  { Either no entries or person not found }
  ELSE BEGIN
    WriteLn('         No work entries found for the person !!!':10);
  END;
  WriteLn('################### Work summary for person ###################');
END;

{ Get busiest person }
FUNCTION BusiestPerson: STRING;
VAR
  node: PersonItemNode;
  oldSeconds, seconds, count: LONGINT;
BEGIN
  oldSeconds := 0;
  count := 0;
  BusiestPerson := '';
  
  node := list^.next;
  { iterate over all work entries }
  WHILE (node <> list) DO BEGIN
    seconds := 0;
    SumSpendTimeOfWorkItemList(node^.workItems, seconds, count);
    if (seconds > oldSeconds) THEN BEGIN
      oldSeconds := seconds;
      BusiestPerson := node^.name;
    END;
    node := node^.next;
  END;
END;

{ Removes a person }
FUNCTION DeletePerson(name: STRING): BOOLEAN;
VAR
  person: PersonItemNode;
BEGIN
  DeletePerson := false;
  person := FindPersonItemNodeForName(name);
  IF (person <> NIL) THEN BEGIN
    person^.prev^.next := person^.next;
    person^.next^.prev := person^.prev;
    DisposeWorkItemList(person^.workItems);
    (* WriteLn('Dispose Person: ', person^.name); *)
    Dispose(person);
    DeletePerson := true;
  END;
END;

{ Get work entry count }
FUNCTION GetTotalWorkEntryCount: LONGINT;
VAR
  personNode: PersonItemNode;
  workNode: WorkItemNode;
  count: LONGINT;
BEGIN
  count := 0;
  personNode := list^.next;
  WHILE (personNode <> list) DO BEGIN
    workNode := personNode^.workItems;
    WHILE (workNode <> NIL) DO BEGIN
      Inc(count);
      workNode := workNode^.next;
    END;
    personNode := personNode^.next;
  END;
  GetTotalWorkEntryCount := count;
END;

BEGIN
  { Initializes the list by creating the anchor for the list which is supposed to be never deleted }
  list := CreatePersonItemNode(CreateWorkEntry('Not meant to be used', 'Not meant to be used', TimeSpanUnit.CreateTimeSpan(-1, -1, -1)));
END.