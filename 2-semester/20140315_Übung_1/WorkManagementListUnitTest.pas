Program WorkManagementListUnitTest;

Uses sysutils, Crt, WorkManagementListUnit, PrintUtils, TimeSpanUnit;

Var
  state: StateCode;
  
{
  Test the procedure which allows setting of the context.
}
Procedure TestSetWorkEntryContext;
Begin
  // Invalid MinimumSpan
  PrintUtils.PrintHeader('Invalid MinimumSpan');
  WorkManagementListUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 0, 60), TimeSpanUnit.CreateTimeSpan(0, 2, 0), 110, state);
  writeln;
  
  // Invalid MaximumSpan
  PrintUtils.PrintHeader('Invalid MaximumSpan');
  WorkManagementListUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 0, 1), TimeSpanUnit.CreateTimeSpan(0, 0, 60), 110, state);
  writeln;
  
  // Invalid Range
  PrintUtils.PrintHeader('Invalid Range');
  WorkManagementListUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 0, 30), TimeSpanUnit.CreateTimeSpan(0, 0, 10), 110, state);
  writeln;
  
  // Invalid StorageSize
  PrintUtils.PrintHeader('Invalid Storage size');
  WorkManagementListUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 0, 30), TimeSpanUnit.CreateTimeSpan(0, 0, 50), 99, state);
  writeln;
  
  // Valid context
  PrintUtils.PrintHeader('Valid context definition');
  WorkManagementListUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 0, 30), TimeSpanUnit.CreateTimeSpan(0, 0, 50), 100, state); 
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
  WorkManagementListUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 1, 0), TimeSpanUnit.CreateTimeSpan(8, 0, 0), 100, state); 
  // Invalid TimeSpan
  span := TimeSpanUnit.CreateTimeSpan(0, 0, 60);
  entry := WorkManagementListUnit.CreateWorkEntry(span, state);
  PrintUtils.PrintHeader('Invalid TimeSpan');
  writeln('Set spendTime      : ', TimeSpanUnit.TimeSpanToString(span));
  writeln('WorkEntry.spendTime: ', TimeSpanUnit.TimeSpanToString(entry.spendTime));
  writeln('State              : ', state);
  writeln;
  
  // TimeSpan overflows minimum
  span := TimeSpanUnit.CreateTimeSpan(0, 0, 59);
  entry := WorkManagementListUnit.CreateWorkEntry(span, state);
  PrintUtils.PrintHeader('TimeSpan overflow minimum');
  writeln('Set spendTime      : ', TimeSpanUnit.TimeSpanToString(span));
  writeln('WorkEntry.spendTime: ', TimeSpanUnit.TimeSpanToString(entry.spendTime));
  writeln('State              : ', state);
  
  // TimeSpan overflows maximum
  span := TimeSpanUnit.CreateTimeSpan(8, 0, 1);
  entry := WorkManagementListUnit.CreateWorkEntry(span, state);
  PrintUtils.PrintHeader('TimeSpan overflow maximum');
  writeln('Set spendTime      : ', TimeSpanUnit.TimeSpanToString(span));
  writeln('WorkEntry.spendTime: ', TimeSpanUnit.TimeSpanToString(entry.spendTime));
  writeln('State              : ', state);
  
  // Valid TimeSpan
  span := TimeSpanUnit.CreateTimeSpan(8, 0, 0);
  entry := WorkManagementListUnit.CreateWorkEntry(span, state);
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
  writeln('State         : ', WorkManagementListUnit.AddWorkEntry('thomas', entry));
  writeln;
  
  // Overlfows minimum span
  span := TimeSpanUnit.CreateTimeSpan(0, 0, 1);
  entry.spendTime := span;
  PrintUtils.PrintHeader('Overflows minimumSpan ');
  writeln('Set spendTime : ', TimeSpanUnit.TimeSpanToString(span));
  writeln('State         : ', WorkManagementListUnit.AddWorkEntry('thomas', entry));
  writeln;
  
  // Overlfows maximum span
  span := TimeSpanUnit.CreateTimeSpan(8, 0, 1);
  entry.spendTime := span;
  PrintUtils.PrintHeader('Overflows maximumSpan ');
  writeln('Set spendTime : ', TimeSpanUnit.TimeSpanToString(span));
  writeln('State         : ', WorkManagementListUnit.AddWorkEntry('thomas', entry));
  writeln;
  
  // Overlfows maximum storage  
  WorkManagementListUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 1, 0), TimeSpanUnit.CreateTimeSpan(8, 0, 0), 3, state);
  span := TimeSpanUnit.CreateTimeSpan(8, 0, 0);
  entry := WorkManagementListUnit.CreateWorkEntry(span, state);
  PrintUtils.PrintHeader('Overflows storage size ');
  for i := 1 to 4 do begin
    writeln('Try to add    : ', 'thomas_', i);
    writeln('Set spendTime : ', TimeSpanUnit.TimeSpanToString(span));
    state := WorkManagementListUnit.AddWorkEntry('thomas_' + IntToStr(i), entry);
    writeln('State         : ', state); 
    writeln;
  end;
  writeln;
  PrintPersons;
  
  // Normal behavior
  WorkManagementListUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 1, 0), TimeSpanUnit.CreateTimeSpan(8, 0, 0), 3, state);
  PrintUtils.PrintHeader('Overflows storage size ');
  for i := 1 to 3 do begin
    writeln('Try to add    : ', 'thomas_', i);
    For j := 1 to 5 do begin
      span := TimeSpanUnit.CreateTimeSpan(0, 1, j);
      entry := WorkManagementListUnit.CreateWorkEntry(span, state);
      state := WorkManagementListUnit.AddWorkEntry('thomas_' + IntToStr(i), entry);
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
  WorkManagementListUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 1, 0), TimeSpanUnit.CreateTimeSpan(8, 0, 0), 10, state);
  for i := 1 to 11 do begin
    For j := 1 to 5 do begin
      span := TimeSpanUnit.CreateTimeSpan(0, 1, j);
      entry := WorkManagementListUnit.CreateWorkEntry(span, state);
      state := WorkManagementListUnit.AddWorkEntry('thomas_' + IntToStr(i), entry);
    end;
  end; 
  
  // Person not found
  PrintUtils.PrintHeader('Person not found');
  WorkManagementListUnit.GetTotalWorkTimeForPerson('thomas_11', span, state);
  writeln('Person: ', 'Not found'); 
  writeln('Span  : ', TimeSpanUnit.TimeSpanToString(span));   
  writeln('State : ', state); 
  writeln;
  
  // Normal bhavor 
  PrintUtils.PrintHeader('Person found');
  WorkManagementListUnit.GetTotalWorkTimeForPerson('thomas_10', span, state);
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
  WorkManagementListUnit.SetWorkEntryContext(TimeSpanUnit.CreateTimeSpan(0, 1, 0), TimeSpanUnit.CreateTimeSpan(8, 0, 0), 10, state);
  for i := 1 to 5 do begin
    For j := 1 to 5 do begin
      span := TimeSpanUnit.CreateTimeSpan(0, 1, j);
      entry := WorkManagementListUnit.CreateWorkEntry(span, state);
      state := WorkManagementListUnit.AddWorkEntry('thomas_' + IntToStr(i), entry);
    end;
  end; 
  
  // Person not found
  PrintUtils.PrintHeader('Person not found in storage');
  state := WorkManagementListUnit.RemovePerson('thomas_6');
  writeln('Person: ', 'thomas_6');  
  writeln('State : ', state); 
  WorkManagementListUnit.PrintPersons;
  writeln;
  
  // First Person removed
  PrintUtils.PrintHeader('First Person removed');
  state := WorkManagementListUnit.RemovePerson('thomas_5');
  writeln('Person: ', 'thomas_5');  
  writeln('State : ', state); 
  WorkManagementListUnit.PrintPersons;
  writeln;
  
  // Last Person removed
  PrintUtils.PrintHeader('Last Person removed');
  state := WorkManagementListUnit.RemovePerson('thomas_1');
  writeln('Person: ', 'thomas_1');  
  writeln('State : ', state); 
  WorkManagementListUnit.PrintPersons;
  writeln;
    
  // Middle Person removed
  PrintUtils.PrintHeader('Person in middle of list');
  state := WorkManagementListUnit.RemovePerson('thomas_3');
  writeln('Person: ', 'thomas_3');  
  writeln('State : ', state); 
  WorkManagementListUnit.PrintPersons;
  writeln;
End;

Begin
  // Test SetWorkEntryContext
  PrintUtils.Print('Tests for procedure SetWorkEntryContext', Green, White);
  TestSetWorkEntryContext;
  WorkManagementListUnit.CleanStorage;
  writeln;
  
  // Test CreateWorkEntry
  PrintUtils.Print('Tests for procedure CreateWorkEntry', Green, White);
  TestCreateWorkEntry;
  WorkManagementListUnit.CleanStorage;
  writeln;
  
  // Test AddWorkEntry
  PrintUtils.Print('Tests for procedure AddWorkEntry', Green, White);
  TestAddWorkEntry;
  WorkManagementListUnit.CleanStorage;
  writeln;
  
  // Test GetTotalWorkTimeForPerson
  PrintUtils.Print('Tests for procedure GetTotalWorkTimeForPerson', Green, White);
  TestGetTotalWorkTimeForPerson;
  WorkManagementListUnit.CleanStorage;
  writeln;
  
  // Test RemovePerson
  PrintUtils.Print('Tests for procedure RemovePerson', Green, White);
  TestRemovePerson;
  WorkManagementListUnit.CleanStorage;
  writeln;
End.