{
  This implementation implements the interface WorkManagementInterface and uses 
  a Single-Connected-Linked-list as the storage.
  
  The default storage size is set to: 10.
  The default minimum TimeSpan is set to: 0:1:0
  The default maximum TimeSpan is set to: 8:0:0 
}
Unit WorkManagementListUnit;

{$I WorkManagementInterface.pas} 

// For testing, must be removed when used productive
// ################ For testing ################
procedure PrintPersons;
// ################ For testing ################

Implementation

Type
  // Pointer to the WorkEntryNodeRec
  WorkEntryNode = ^WorkEntry;
  // Pointer to the WorkEntryNode used as separate tpye for list
  WorkEntryList = WorkEntryNode;
  // WorkEntry which hold WorkEntryRec which gets used for list node
  WorkEntry = Record 
    workEntry: WorkEntryRec;
    next: WorkEntryNode;
  End;
  // Pointer to the PersonEntryRec type
  PersonEntry = ^PersonEntryRec; 
  // The pointer to the PersonEntryRec used for the list
  PersonEntryList = PersonEntry;
  // The person entry record which holds a work entry
  PersonEntryRec = Record
    name: String;
    entries: WorkEntryList;
    next: PersonEntry;
  end;

{
  Unit visible variables
}
Var
  // Single connected list used as storage
  storage: PersonEntryList;
  // The context of this module
  context: WorkEntryContext;
  // Internal State holder
  state: StateCode;
  // current size of the list
  size: Longint;

Const
  DEFAULT_STORAGE_SIZE = 1;

// ################# Private function and procedure ################# 
{
  Creates a person entry instance. Be aware that this method returns a pointer and you will need to 
  dispose this instance manually.
  
  @param
    name: the name of the person
  @param
    entries: the WorkEntryList instance which will be set on the person entry
  @return
    the created PersonEntry instance
}
Function CreatePersonEntry(name: String; entries: WorkEntryList): PersonEntry;
Begin
  // Create PersonEntry
  CreatePersonEntry := New(PersonEntry); 
  CreatePersonEntry^.name := LowerCase(name);
  CreatePersonEntry^.entries := entries;
  CreatePersonEntry^.next := nil;
End;

{
  Creates a WorkEntryNode for the given workEntryRec
  
  @param
    entry: the WorkEntryRec to create WorkEntryNode
  @return
    the created WorkEntryNode
}
Function CreateWorkEntryNode(entry: WorkEntryRec): WorkEntryNode;
Begin
  CreateWorkEntryNode := New(WorkEntryNode);
  CreateWorkEntryNode^.workEntry := entry;
End;

{
  Gets the PersonEntry by its name from the storage.
  
  @param
    name: the name of the person to be searched
  @return
    the found PersonEntry, níll otherwise
}
Function GetPersonEntry(name: String): PersonEntry;
Var
  node: PersonEntry;
  upperName: String;
Begin
  node := storage;
  upperName := LowerCase(name);
  while ((node <> nil) and (node^.name <> upperName))do begin
    node := node^.next;
  end;
  GetPersonEntry := node;
End;

{
  Removes a person by deleting all of its contained WorkEntryNodes
  and the person itself. The caller must ensure that the next component 
  is properly connected to the previous of this person, otherwise
  the list will be broken.
}
Procedure RemovePersonEntry(person: PersonEntry);
Var
  pred, succ: WorkEntryList;
Begin
  if (person <> nil) then begin
    pred := person^.entries;
    succ := nil;
    while (pred <> nil) do begin
      succ := pred^.next;
      Dispose(pred);
      { WriteLn('WorkEntry disposed'); }
      pred := succ;
    end;
    Dispose(person);
    { WriteLn('PersonEntry disposed'); }
    size := size - 1;
  end;
End;

{
  Validates if the given TimeSpan is within context borders.
  
  @param
    span: the TimeSpan instance to validate
  @return
    true if the given TimeSpan instance is within borders, false otherwise
}
Function IsValidTimeSpan(spendTime: TimeSpan): Boolean;
Begin
  IsValidTImeSpan := ((TimeSpanToSeconds(spendTime).error = '') and (TimeSpanUnit.TimeSpanToSeconds(spendTime).timeInSeconds >=  TimeSpanUnit.TimeSpanToSeconds(context.minimumSpan).timeInSeconds) and (TimeSpanUnit.TimeSpanToSeconds(spendTime).timeInSeconds <= TimeSpanUnit.TimeSpanToSeconds(context.maximumSpan).timeInSeconds))
End;

// ################# Interface function and procedure ################# 
Procedure SetWorkEntryContext(minimumSpan, maximumSpan: TimeSpan; storageSize: Longint; Var state: StateCode);
Begin   
  state := StateCode.OK;
  // set error if context definition is invalid
  if ((TimeSpanUnit.TimeSpanToSeconds(minimumSpan).error <> '') or (TimeSpanUnit.TimeSpanToSeconds(maximumSpan).error <> '') or (TimeSpanUnit.IsShorterThan(minimumSpan, maximumSpan) = false) or (storageSize < DEFAULT_STORAGE_SIZE)) then begin
    state := StateCode.INVALID_CONTEXT;
  end
  // set context if valid definition
  else begin
    CleanStorage;
    context.minimumSpan := minimumSpan;
    context.maximumSpan := maximumSpan;
    context.storageSize := storageSize;
    PrintHandler.PrintHeader('Context successfully set');
  end;
    writeln('minimumSpan: ', TimeSpanUnit.TimeSpanToString(minimumSpan));
    writeln('maximumSpan:', TimeSpanUnit.TimeSpanToString(maximumSpan));
    writeln('storageSize: ', storageSize);
    writeln;
End;

{ Cleans the storage }
Procedure CleanStorage;
Var
  succ: PersonEntry;
Begin
  succ := nil;
  while (storage <> nil) do begin
    succ := storage^.next;
    RemovePersonEntry(storage);
    storage := succ;
  end;
  size := 0;
End;

{ Creates a WorkEntry instance }
Function CreateWorkEntry(spendTime: TimeSpan; VAR state: StateCode): WorkEntryRec;
Begin
  state := StateCode.OK;
  if not IsValidTimeSpan(spendTime) then begin
    state := StateCode.INVALID_SPAN;
    writeln('invalid');
    CreateWorkEntry.spendTime := context.minimumSpan;
  end
  else begin
    CreateWorkEntry.spendTime := spendTime;
  end;
End;

{ Adds a WorkEntry to the backed person or adds a new person if person not found }
Function AddWorkEntry(name: String; entry: WorkEntryRec): StateCode;
Var
  node: PersonEntry;
  workEntries: WorkEntryList;
  entries: WorkEntryList;
Begin
  AddWorkEntry := StateCode.OK;
  
  // Check for invalid TimeSpan set on WorkEntry
  if not IsValidTimeSpan(entry.spendTime) then begin
    AddWorkEntry := StateCode.INVALID_SPAN;
  end
  else begin  
    // Add entry to person
    entries := CreateWorkEntryNode(entry);
    node := GetPersonEntry(name);
    if (node = nil) then begin
      node := CreatePersonEntry(name, entries);
      // Add person to storage
      if (storage <> nil) then begin
        // Check for storage overflow
        if ((size + 1) < context.storageSize) then begin
          node^.next := storage;
          storage := node;
          size := size + 1;
          writeln('Added: ', node^.name);
        end
        // Overflows storage size
        else begin
          AddWorkEntry := StateCode.STORAGE_FULL;
        end;
      end
      else begin
        storage := node;
        writeln('Added: ', node^.name);
      end;
    end
    // Only add new WorkEntry
    else begin
      workEntries := node^.entries;
      node^.entries := entries;
      node^.entries^.next := workEntries;
    end;
  end;
end;

{ Gets the total work time for the given person }
Procedure GetTotalWorkTimeForPerson(name: String; Var span: TimeSpan; Var state: StateCode);
Var
  person: PersonEntry;
  entry: WorkEntryList;
  sec: LONGINT;
Begin
  state := StateCode.OK;
  sec := 0;
  person := GetPersonEntry(name);
  // Only get total time when person were found 
  if (person <> nil) then begin
    entry := person^.entries;
    while (entry <> nil) do begin
      sec := sec + TimeSpanUnit.TimeSpanToSeconds(entry^.workEntry.spendTime).timeInSeconds;
      entry := entry^.next;
    end;
  end
  else begin
    state := StateCode.PERSON_NOT_FOUND;
  end;
  
  span := TimeSpanUnit.SecondsToTimeSpan(sec);
End;

{ Removes person from the storage }
Function RemovePerson(name: String): StateCode;
Var
  pred, succ: PersonEntry;
  lowerName: String;
Begin
  RemovePerson := StateCode.OK;
  lowerName := LowerCase(name);
  succ := storage;
  pred := nil;
  while (succ <> nil) and (succ^.name <> lowerName) do begin
    pred := succ;
    succ := pred^.next;
  end;
  if (succ <> nil) then begin
    if (pred <> nil) then begin
      pred^.next := succ^.next;
    end
    else begin
      storage := succ^.next;
    end;
    RemovePersonEntry(succ);
  end;
End;

// For testing, must be removed when used productive
// ################ For testing ################
procedure PrintPersons;
Var
  pred, succ: PersonEntry;
  entry: WorkEntryList;
Begin
  pred := storage;
  succ := nil;
  PrintHandler.PrintHeader('Storage content');
  while (pred <> nil) do begin
    succ := pred^.next;
    entry := pred^.entries;
    write(pred^.name, ': ');
    while (entry <> nil) do begin
      write(TimeSpanUnit.TimeSpanToString(entry^.workEntry.spendTime), ', ');
      entry := entry^.next;
    end;
    writeln;
    pred := succ;
  end;
  size := 0;
End;
// ################ For testing ################

{ Initialize module }
Begin 
  PrintHandler.PrintHeader('Initializing WorkManagementListUnit');
  storage := NIL;
  size := 0;
  writeln('storage = nil');
  writeln('size = 0');
  writeln('Creating default context...');
  writeln;
  SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 1, 0), TimeSpanUnit.CreateTimeSpan(8, 0, 0), DEFAULT_STORAGE_SIZE, state);
  // Stop when default context cannot be initialized
  if (state <> StateCode.OK) then begin
    PrintHandler.PrintError('Invalid context detected, program will exit');
    Halt;
  end;
End.