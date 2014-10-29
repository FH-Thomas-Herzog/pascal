{
  This implementation implements the interface WorkManagementInterface and uses 
  a Single-Connected-Linked-list as the storage.
  
  The default storage size is set to: 10.
  The default minimum TimeSpan is set to: 0:1:0
  The default maximum TimeSpan is set to: 8:0:0 
}
Unit WorkManagementHashOpenUnit;

{$I WorkManagementInterface.pas} 

// For testing, must be removed when used productive
// ################ For testing ################
procedure PrintPersons;
// ################ For testing ################

Implementation

Uses 
  HashUtils;
  
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
  // The person entry record which holds a work entry
  PersonEntryRec = Record
    name: String;
    entries: WorkEntryList;
    deleted: Boolean;
  end;

{
  Unit visible variables
}
Var
  // Single connected list used as storage
  storage: Array of PersonEntry;
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
  CreatePersonEntry^.deleted := false;
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
  CreateWorkEntryNode^.next := nil;
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
  lowerName: String;
  hash, i: LongInt;
  state: HashState;
Begin
  node := nil;
  lowerName := LowerCase(name);
  hash := HashUtils.computeHashOrdinalOnly(lowerName, Low(storage), High(storage), state);
  if (state = HashState.OK) then begin
    node := storage[hash];
    // Wrong person found on coputed index
    if (node <> nil) and (node^.name <> lowerName) then begin
      // check for already last index
      if (hash = High(storage)) then begin
        i := Low(storage);
      end
      else begin
        i := hash + 1;
      end;
      // search on other indexes
      while (storage[i] <> nil) and (i <> hash) and (storage[i]^.name <> lowerName) do begin
        Inc(i);
        if (i > High(storage)) then begin
          i := Low(storage);
        end;
      end;
      // If not same index, not nil and not deleted then we found it
      if (i <> hash) and (storage[i] <> nil) and (not storage[i]^.deleted) then begin
        node := storage[i];
      end
      // Else we did not found it
      else begin
        node := nil;
      end;
    end;
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
    PrintHandler.PrintError('Context invalid');
  end
  // set context if valid definition
  else begin
    context.minimumSpan := minimumSpan;
    context.maximumSpan := maximumSpan;
    context.storageSize := storageSize + 1;
    CleanStorage;
    SetLength(storage, context.storageSize);
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
  person: PersonEntry;
  i: LongInt;
Begin
  for i := Low(storage) to High(storage) do begin
    person := storage[i];
    RemovePersonEntry(person);
    storage[i] := nil;
  end;
  size := 0;
End;

{ Creates a WorkEntry instance }
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
  hash, i: LongInt;
  state: HashState;
  workState: StateCode;
Begin
  workState := StateCode.OK;
  
  // Check for invalid TimeSpan set on WorkEntry
  if ((TimeSpanToSeconds(entry.spendTime).error <> '') or (TimeSpanUnit.TimeSpanToSeconds(entry.spendTime).timeInSeconds <  TimeSpanUnit.TimeSpanToSeconds(context.minimumSpan).timeInSeconds) or (TimeSpanUnit.TimeSpanToSeconds(entry.spendTime).timeInSeconds > TimeSpanUnit.TimeSpanToSeconds(context.maximumSpan).timeInSeconds))then begin
    workState := StateCode.INVALID_SPAN;
  end
  else begin  
    hash := HashUtils.ComputeHashOrdinalOnly(name, Low(storage), High(storage), state);
    i := hash;
    // No error on hash calculation
    if (state = HashState.OK) then begin
      // Add entry to person
      entries := CreateWorkEntryNode(entry);
      node := GetPersonEntry(name);
      // New person to be added
      if (node = nil) then begin
        node := CreatePersonEntry(name, entries);
        // Check for storage overflow
        if ((size + 1) < context.storageSize) then begin
          // Check if computed hash index is already in use
          if (storage[hash] <> nil) then begin
            // check for already last index
            if (hash = High(storage)) then begin
              i := Low(storage);
            end
            else begin
              i := hash + 1;
            end;
            // search for free indexes
            while (storage[i] <> nil) and (i <> hash) and (not storage[i]^.deleted) do begin
              Inc(i);
              if (i > High(storage)) then begin
                i := Low(storage);
              end;
            end;
            // Else no place left
            // Should never occur regarding kept storage element count
            if (i = hash) then begin
              workState := StateCode.STORAGE_FULL;
            end
          end;
        end
        // Overflows storage size
        else begin 
          workState := StateCode.STORAGE_FULL;
        end;
        // Free to add person
        if (workState = StateCode.OK) then begin
          // If a deleted person reside then remove it
          if (storage[i] <> nil) then begin
            RemovePersonEntry(storage[i]);
          end;
          storage[i] := node;
          writeln('hash[', hash, ']-idx[', i, ']: ', node^.name);
          size := size + 1;
        end
      end
      // Add WorkEntry
      else begin
        workEntries := node^.entries;
        node^.entries := entries;
        node^.entries^.next := workEntries;
      end;
    end;
  end;
  AddWorkEntry := workState;
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
  person: PersonEntry;
  state: HashState;
Begin
  RemovePerson := StateCode.OK;
  person := GetPersonEntry(name);
  // Mark as deleted
  if (person <> nil) and (not person^.deleted) then begin
    person^.deleted := true;
    size := size - 1;
  end
  else begin
    RemovePerson := StateCode.PERSON_NOT_FOUND;
  end;
End;

// For testing, must be removed when used productive
// ################ For testing ################
procedure PrintPersons;
Var
  person: PersonEntry;
  entry: WorkEntryList;
  i: LongInt;
Begin
  PrintHandler.PrintHeader('Storage content');
  for i := Low(storage) to High(Storage) do begin 
    person := storage[i];
    if (person <> nil) then begin
      write('hash[', i, ']-deleted[', person^.deleted, ']: ', person^.name, ': ');
      entry := person^.entries;
      while (entry <> nil) do begin
        write(TimeSpanUnit.TimeSpanToString(entry^.workEntry.spendTime), ', ');
        entry := entry^.next;
      end;
      writeln;
    end;
  end;
End;
// ################ For testing ################

{ Initialize module }
Begin 
  PrintHandler.PrintHeader('Initializing WorkManagementListUnit');
  SetLength(storage, 1);
  size := 0;
  writeln('storage is empty');
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