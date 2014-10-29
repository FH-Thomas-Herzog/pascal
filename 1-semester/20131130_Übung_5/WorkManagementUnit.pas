{
  Unit for handling work entries which are hold by a entry holder.
  Call Reset to reset or reinitialize the memeory which are representing the 
  work entry holder.
}
UNIT WorkManagementUnit;

{ ######################### Interface part ######################### }
INTERFACE
  
{ Uses the time span unit }
USES TImeSpanUnit;

TYPE
  { Spezifies the supported range }
  SupportedRange = 100..1000;
  
  { The error codes which vcan be handled by the caller }
  ErrorCode = (NONE, OVERFLOW, TO_SHORT, TO_LONG, INVALID_SPAN);
  
  { Compound representing a work entry }
  WorkEntry = RECORD
    name: STRING;
    task: STRING;
    spendTime: TimeSpan;
  END;
  
{ 
  Initializes the holder for the workflow entries with the given size.
  
  @param
      size: the size of the work entry holder (100 - 1000)
}
PROCEDURE Reset(size: SupportedRange);

{
  Creates a work entry for thegiven data.
  
  @param
      name: the name of the employee
  @param
      task: the name of the task the employee worked on
  @param
      spendTime: the TimeSpan instance which represents the time the employee hs worked 
      on the defined task
  @return
      the create workEntry instance
}
FUNCTION CreateWorkEntry(name, task: STRING; spendTime: TimeSpan): WorkEntry;

{
  Adds a WorkEntry to the backed entry holder.
  
  @param 
      entry: the entry to be added
  @param
      error: the error parameter which will be set <> NONE if an error occurs
  @returns
      the occured error or the given error from the calles which should be NONE
}
PROCEDURE AddWorkEntry(entry: WorkEntry; VAR error: ErrorCode);

{
  Gets the total work time for the given employee.
  @param
      name: the name of the employee
  @param
      spendtime: the TimeSpan instance given by the caller which will get set with the total work time,
      should be initialized by the caller with 0:0:0
  @return
      the TimeSpan representing the total work time, or all values set to 0 when the employee would not be found,
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
      if the taks ccould not be found, because there can no task be present in the entry holder which has
      a time spend less than 1 minute.
}
PROCEDURE GetAverageWorkTimeForTask(task: STRING; VAR average: TimeSpan);

{
  Prints the persons which has been working ont the task, along with their time spend.
  
  @param
      task: the task to be printed.
}
PROCEDURE PrintPersonForTask(task: STRING);

{
  Prints the work summary for the given person.
  
  @param
      name: the namee of the persosn to seachr for the work summaray
}
PROCEDURE PrintWorkSummaryForPerson(name: STRING);

{ ######################## Implementation part ######################## }
IMPLEMENTATION  

TYPE
  { The specified range of the backed array which holds the entries }
  ArrayRange = 1..1000;
VAR
  { the memory of this unit which holds the entries }
  workEntryArray: ARRAY[ArrayRange] OF WorkEntry;
  { the last index where the last added entry resides }
  lastIdx: ArrayRange;
  { the from the user maximum set memory size}
  maxIdx: ArrayRange;
  { Flag which indicates that the memeory has no entries set }
  empty: BOOLEAN;

{ Reset memory }
PROCEDURE Reset(size: SupportedRange);
VAR
  i: ArrayRange;
BEGIN
  maxIdx := size;
  lastIdx := Low(ArrayRange);
  empty := true;
  
  { Sets the array elements with default isntances }
  FOR i:= Low(workEntryArray) TO High(workEntryArray) DO BEGIN
    workEntryArray[i] := CreateWorkEntry('', '', TimeSpanUnit.CreateTimeSpan(0, 0, 0));
  END;
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
BEGIN
  { Converts the time span to seonds, and will contain any error }
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
  { Handle no space left }
  ELSE IF (lastIdx = maxIdx) THEN BEGIN
      error := OVERFLOW;
  END
  { valid to add entry }
  ELSE BEGIN
    IF empty THEN BEGIN
      empty := false
    END
    { Only increase after first elements has been added }
    ELSE BEGIN  
      Inc(lastIdx)
    END;
    workEntryArray[lastIdx] := entry;
  END;
END;

{ Gets total work time }
PROCEDURE GetTotalWorkTimeForPerson(name: STRING; VAR spendTime: TimeSpan);
VAR
  i: ArrayRange;
  sec: LONGINT;
  entry: WorkEntry;
BEGIN
  sec := 0;
  { Only get total time when entries are present }
  IF NOT empty THEN BEGIN
    FOR i := Low(workEntryArray) TO lastIdx DO BEGIN
      entry := workEntryArray[i];
      { Build sum for the given name }
      IF (entry.name = name) THEN BEGIN
        sec := sec + TimeSpanUnit.TimeSpanToSeconds(entry.spendTime).timeInSeconds;
      END;
    END;
  END;
  
  spendTime := TimeSpanUnit.SecondsToTimeSpan(sec);
END;

{ Gets average of spend time }
PROCEDURE GetAverageWorkTimeForTask(task: STRING; VAR average: TimeSpan);
VAR
  i: ArrayRange;
  name: STRING;
  sec: LONGINT;
  count: INTEGER;
  entry: WorkEntry;
BEGIN
  sec := 0;
  count := 0;
  average.timeInSeconds := 0;
  name := '';
  
  { Only get average time when entries are present }
  IF NOT empty THEN BEGIN
    FOR i := Low(workEntryArray) TO lastIdx DO BEGIN
      entry := workEntryArray[i];
      { Search for this task }
      IF (entry.task = task) THEN BEGIN
        sec := sec + TimeSpanUnit.TimeSpanToSeconds(entry.spendTime).timeInSeconds;
        Inc(count);
      END; 
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
  i: ArrayRange;
  found: BOOLEAN;
  count: INTEGER;
  entry: WorkEntry;
  name: STRING;
BEGIN
  found := false;
  count := 0;
  name := '';
  
  { Only print result if there are entries available }
  WriteLn('################### Persons working on task ###################');
  WriteLn('Task    : ', task);
  WriteLn('Persons : ');
  IF NOT empty THEN BEGIN
    FOR i := Low(workEntryArray) TO lastIdx DO BEGIN
      entry := workEntryArray[i];
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
    END;
  END;
  { Either no entries or task not found }
  IF NOT FOUND THEN BEGIN
    WriteLn('          No work entries found for the task !!!');
  END;
  WriteLn('################### Persons working on task ###################');
END;

{ Print work summary for a person }
PROCEDURE PrintWorkSummaryForPerson(name: STRING);
VAR
  i: ArrayRange;
  found: BOOLEAN;
  entry: WorkEntry;
BEGIN
  found := false;
  
  { Only print result if entries are avialable }
  WriteLn('################### Work summary for person ###################');
  WriteLn('Person : ', name);
  IF NOT empty THEN BEGIN
    FOR i := Low(workEntryArray) TO lastIdx DO BEGIN
      entry := workEntryArray[i];
      { Search for this person }
      IF (entry.name = name) THEN BEGIN
        WriteLn('         Task: ', entry.task:15, ' | Spend time: ', TimeSpanUnit.TimeSpanToString(entry.spendTime)); 
        found := true;
      END; 
    END;
  END;
  { Either no entries or person not found }
  IF NOT found THEN BEGIN
    WriteLn('         No work entries found for the person !!!':10);
  END;
  WriteLn('################### Work summary for person ###################');
END;

BEGIN
  Reset(100);
END.