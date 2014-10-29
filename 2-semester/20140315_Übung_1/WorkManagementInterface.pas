{
  This interface specifies the functions and procedures which a 
  WorkManagement unit implementation must provide.
  This interface does not specify any used storage, so the implementation
  itself must provide the storage and is free to choose the type of storage.
}
Interface
  
// Uses the time span unit for the spend time of a WorkEntry
Uses sysutils, Crt, TImeSpanUnit, PrintHandler;

// The types which are visible and usable for the caller
Type
  // The state codes which provide information of the current state
  StateCode = (OK, INVALID_SPAN, STORAGE_FULL, PERSON_NOT_FOUND, INVALID_CONTEXT);
  // Compound representing a work entry
  WorkEntryRec = Record
    spendTime: TimeSpan;
  End;
  // The context which specifies the behaviour of this module
  WorkEntryContext = Record
    minimumSpan: TimeSpan;
    maximumSpan: TimeSpan;
    storageSize: Longint;
  End;
  
{ 
  Cleans the storage.
}
Procedure CleanStorage;

{
  Sets the context for the module.
  
  @param 
    minimumSpan: the minimumSpan which a WorkEntry instance is allowed have.
  @param
    maximumSpan the maximum TimeSpan a WorkEntry instance is allowed to have.
  @param
    storageSize:: the allowed size of the backed storage
}
Procedure setWorkEntryContext(minimumSpan, maximumSpan: TimeSpan; storageSize: Longint; Var state: StateCode);

{
  Creates a new WorkEntry for the given data.
  
  @param
    spendTime: the TimeSpan instance which represents the time the person has worked
  @param
    state: The state of the procedure work.
  @return
    the created WorkEntry instance
}
Function CreateWorkEntry(spendTime: TimeSpan; VAR state: StateCode): WorkEntryRec;

{
  Adds a WorkEntry to the backed storage.
  
  @param
    name: the name of the person where this WorkEntry belongs to.
  @param 
      entry: the WorkEntry to be added
  @error
    the state code which defines the state of the done work:
    OK:           If no error occurs
    INVALID_SPAN: If the spendTime field is an invalid time span
    STORAGE_FULL: If the storage is already full
}
Function AddWorkEntry(name: String; entry: WorkEntryRec): StateCode;

{
  Gets the total work time for the given person.
  
  @param
      name: the name of the person
  @param
      span: the TimeSpan instance given by the caller which will get set with the total work time,
      should be initialized by the caller with 0:0:0
  @return
      the TimeSpan representing the total work time, or all values set to 0 when the person would not be found,
      or no entry exists
  @return
    the state code which defines the state of the done work
    OK:               If the entries could be deleted
    PERSON_NOT_FOUND: If the person could not be found
}
Procedure GetTotalWorkTimeForPerson(name: String; Var span: TimeSpan; Var state: StateCode);

{
  Removes the given person.
  
  @param
    name: the name of the person to deleted WorkEntry entries from
  @return 
    the state code which defines the state of the done work
    OK:               If the WorkEntry entries could be deleted
    PERSON_NOT_FOUND: If the person could not be found
}
Function RemovePerson(name: String): StateCode;

