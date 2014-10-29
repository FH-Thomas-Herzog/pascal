Program WorkManagementHashChainedUnitTest;

Uses sysutils, Crt, WorkManagementHashChainedUnit, PrintUtils, TimeSpanUnit;

Var
  state: StateCode;
  
{
  Test the procedure which allows setting of the context.
}
Procedure TestSetWorkEntryContext;
Begin
  // Invalid MinimumSpan
  PrintUtils.PrintHeader('Invalid MinimumSpan');
  WorkManagementHashChainedUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 0, 60), TimeSpanUnit.CreateTimeSpan(0, 2, 0), 10, state);
  writeln;
  
  // Invalid MaximumSpan
  PrintUtils.PrintHeader('Invalid MaximumSpan');
  WorkManagementHashChainedUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 0, 1), TimeSpanUnit.CreateTimeSpan(0, 0, 60), 10, state);
  writeln;
  
  // Invalid Range
  PrintUtils.PrintHeader('Invalid Range');
  WorkManagementHashChainedUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 0, 30), TimeSpanUnit.CreateTimeSpan(0, 0, 10), 10, state);
  writeln;
  
  // Invalid StorageSize
  PrintUtils.PrintHeader('Invalid Storage size');
  WorkManagementHashChainedUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 0, 30), TimeSpanUnit.CreateTimeSpan(0, 0, 50), 0, state);
  writeln;
  
  // Valid context
  PrintUtils.PrintHeader('Valid context definition');
  WorkManagementHashChainedUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 0, 30), TimeSpanUnit.CreateTimeSpan(0, 0, 50), 10, state); 
End;

{
  Tests the function CreateWorkEntry
}
Procedure TestCreateWorkEntry;
Var
  entry: WorkEntryRec;
  span: TimeSpan;
  state: StateCode;
Begin
  WorkManagementHashChainedUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 1, 0), TimeSpanUnit.CreateTimeSpan(8, 0, 0), 100, state); 
  // Invalid TimeSpan
  span := TimeSpanUnit.CreateTimeSpan(0, 0, 60);
  entry := WorkManagementHashChainedUnit.CreateWorkEntry(span, state);
  PrintUtils.PrintHeader('Invalid TimeSpan');
  writeln('Set spendTime      : ', TimeSpanUnit.TimeSpanToString(span));
  writeln('WorkEntry.spendTime: ', TimeSpanUnit.TimeSpanToString(entry.spendTime));
  writeln('State              : ', state);
  writeln;
  
  // TimeSpan overflows minimum
  span := TimeSpanUnit.CreateTimeSpan(0, 0, 59);
  entry := WorkManagementHashChainedUnit.CreateWorkEntry(span, state);
  PrintUtils.PrintHeader('TimeSpan overflow minimum');
  writeln('Set spendTime      : ', TimeSpanUnit.TimeSpanToString(span));
  writeln('WorkEntry.spendTime: ', TimeSpanUnit.TimeSpanToString(entry.spendTime));
  writeln('State              : ', state);
  
  // TimeSpan overflows maximum
  span := TimeSpanUnit.CreateTimeSpan(8, 0, 1);
  entry := WorkManagementHashChainedUnit.CreateWorkEntry(span, state);
  PrintUtils.PrintHeader('TimeSpan overflow maximum');
  writeln('Set spendTime      : ', TimeSpanUnit.TimeSpanToString(span));
  writeln('WorkEntry.spendTime: ', TimeSpanUnit.TimeSpanToString(entry.spendTime));
  writeln('State              : ', state);
  
  // Valid TimeSpan
  span := TimeSpanUnit.CreateTimeSpan(8, 0, 0);
  entry := WorkManagementHashChainedUnit.CreateWorkEntry(span, state);
  PrintUtils.PrintHeader('Valid TimeSpan');
  writeln('Set spendTime      : ', TimeSpanUnit.TimeSpanToString(span));
  writeln('WorkEntry.spendTime: ', TimeSpanUnit.TimeSpanToString(entry.spendTime));
  writeln('State              : ', state);
End;

{
  Tests the function AddWorkEntry
}
Procedure TestAddWorkEntry;
Var
  entry: WorkEntryRec;
  span: TimeSpan;
  state: StateCode;
  i, j: Integer;
Begin
  // Invalid Time span
  span := TimeSpanUnit.CreateTimeSpan(0, 0, 60);
  entry.spendTime := span;
  PrintUtils.PrintHeader('Invalid TimeSpan ');
  writeln('Set spendTime : ', TimeSpanUnit.TimeSpanToString(span));
  writeln('State         : ', WorkManagementHashChainedUnit.AddWorkEntry('thomas', entry));
  writeln;
  
  // Overlfows minimum span
  span := TimeSpanUnit.CreateTimeSpan(0, 0, 1);
  entry.spendTime := span;
  PrintUtils.PrintHeader('Overflows minimumSpan ');
  writeln('Set spendTime : ', TimeSpanUnit.TimeSpanToString(span));
  writeln('State         : ', WorkManagementHashChainedUnit.AddWorkEntry('thomas', entry));
  writeln;
  
  // Overlfows maximum span
  span := TimeSpanUnit.CreateTimeSpan(8, 0, 1);
  entry.spendTime := span;
  PrintUtils.PrintHeader('Overflows maximumSpan ');
  writeln('Set spendTime : ', TimeSpanUnit.TimeSpanToString(span));
  writeln('State         : ', WorkManagementHashChainedUnit.AddWorkEntry('thomas', entry));
  writeln;
  
  // Overlfows maximum storage  
  WorkManagementHashChainedUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 1, 0), TimeSpanUnit.CreateTimeSpan(8, 0, 0), 5, state);
  span := TimeSpanUnit.CreateTimeSpan(8, 0, 0);
  entry := WorkManagementHashChainedUnit.CreateWorkEntry(span, state);
  PrintUtils.PrintHeader('Overflows storage size ');
  for i := 1 to 3 do begin
    writeln('Try to add    : ', 'thomas_', i);
    writeln('Set spendTime : ', TimeSpanUnit.TimeSpanToString(span));
    state := WorkManagementHashChainedUnit.AddWorkEntry('thomas_' + IntToStr(i), entry);
    writeln('State         : ', state); 
    
    writeln('Try to add    : ', 'wolfganf_', i);
    writeln('Set spendTime : ', TimeSpanUnit.TimeSpanToString(span));
    state := WorkManagementHashChainedUnit.AddWorkEntry('wolfganf_' + IntToStr(i), entry);
    writeln('State         : ', state); 
    writeln;
  end;
  writeln;
  PrintPersons;
  
  // Normal behavior
  WorkManagementHashChainedUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 1, 0), TimeSpanUnit.CreateTimeSpan(8, 0, 0), 3, state);
  PrintUtils.PrintHeader('Normal behavior ');
  for i := 1 to 3 do begin
    writeln('Try to add    : ', 'thomas_', i);
    For j := 1 to 5 do begin
      span := TimeSpanUnit.CreateTimeSpan(0, 1, j);
      entry := WorkManagementHashChainedUnit.CreateWorkEntry(span, state);
      state := WorkManagementHashChainedUnit.AddWorkEntry('thomas_' + IntToStr(i), entry);
    end;
    writeln('State         : ', state); 
    writeln;
  end;
  writeln;
  PrintPersons;
End;

{
  Tests the procedure GetTotalWorkTimeForPerson
}
Procedure TestGetTotalWorkTimeForPerson;
Var
  entry: WorkEntryRec;
  span: TimeSpan;
  state: StateCode;
  i, j: Integer;
Begin 
  WorkManagementHashChainedUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 1, 0), TimeSpanUnit.CreateTimeSpan(8, 0, 0), 10, state);
  for i := 1 to 11 do begin
    For j := 1 to 5 do begin
      span := TimeSpanUnit.CreateTimeSpan(0, 1, j);
      entry := WorkManagementHashChainedUnit.CreateWorkEntry(span, state);
      state := WorkManagementHashChainedUnit.AddWorkEntry('thomas_' + IntToStr(i), entry);
    end;
  end; 
  
  // Person not found
  PrintUtils.PrintHeader('Person not found');
  WorkManagementHashChainedUnit.GetTotalWorkTimeForPerson('thomas_11', span, state);
  writeln('Person: ', 'Not found'); 
  writeln('Span  : ', TimeSpanUnit.TimeSpanToString(span));   
  writeln('State : ', state); 
  writeln;
  
  // Normal bhavor 
  PrintUtils.PrintHeader('Person found');
  WorkManagementHashChainedUnit.GetTotalWorkTimeForPerson('thomas_10', span, state);
  writeln('Person: ', 'thomas_10'); 
  writeln('Span  : ', TimeSpanUnit.TimeSpanToString(span));   
  writeln('State : ', state); 
End;

{
  Test the function RemovePerson
}
procedure TestRemovePerson;
Var
  entry: WorkEntryRec;
  span: TimeSpan;
  state: StateCode;
  i, j: Integer;
Begin 
  WorkManagementHashChainedUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 1, 0), TimeSpanUnit.CreateTimeSpan(8, 0, 0), 10, state);
  for i := 1 to 3 do begin
    For j := 1 to 5 do begin
      span := TimeSpanUnit.CreateTimeSpan(0, 1, j);
      entry := WorkManagementHashChainedUnit.CreateWorkEntry(span, state);
      state := WorkManagementHashChainedUnit.AddWorkEntry('thomas_' + IntToStr(i), entry);
      state := WorkManagementHashChainedUnit.AddWorkEntry('wolfganf_' + IntToStr(i), entry);
    end;
  end; 
  
  // Person not found
  PrintUtils.PrintHeader('Person not found in storage');
  state := WorkManagementHashChainedUnit.RemovePerson('thomas_6');
  writeln('Person: ', 'thomas_6');  
  writeln('State : ', state); 
  WorkManagementHashChainedUnit.PrintPersons;
  writeln;
  
  // First Person removed
  PrintUtils.PrintHeader('First Person removed chain');
  state := WorkManagementHashChainedUnit.RemovePerson('thomas_3');
  writeln('Person: ', 'thomas_3');  
  writeln('State : ', state); 
  WorkManagementHashChainedUnit.PrintPersons;
  writeln;
  
  // Remove from chain
  PrintUtils.PrintHeader('Person removed');
  state := WorkManagementHashChainedUnit.RemovePerson('thomas_1');
  writeln('Person: ', 'thomas_1');  
  writeln('State : ', state); 
  WorkManagementHashChainedUnit.PrintPersons;
  writeln;
End;

Begin
  // Test SetWorkEntryContext
  PrintUtils.Print('Tests for procedure SetWorkEntryContext', Green, White);
  TestSetWorkEntryContext;
  WorkManagementHashChainedUnit.CleanStorage;
  writeln;
  
  // Test CreateWorkEntry
  PrintUtils.Print('Tests for procedure CreateWorkEntry', Green, White);
  TestCreateWorkEntry;
  WorkManagementHashChainedUnit.CleanStorage;
  writeln;
  
  // Test AddWorkEntry
  PrintUtils.Print('Tests for procedure AddWorkEntry', Green, White);
  TestAddWorkEntry;
  WorkManagementHashChainedUnit.CleanStorage;
  writeln;
  
  // Test GetTotalWorkTimeForPerson
  PrintUtils.Print('Tests for procedure GetTotalWorkTimeForPerson', Green, White);
  TestGetTotalWorkTimeForPerson;
  WorkManagementHashChainedUnit.CleanStorage;
  writeln;
  
  // Test RemovePerson
  PrintUtils.Print('Tests for procedure RemovePerson', Green, White);
  TestRemovePerson;
  WorkManagementHashChainedUnit.CleanStorage;
  writeln;
End.