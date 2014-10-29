PROGRAM WorkManagementUnitTest;

USES WorkManagementUnit, TimeSpanUnit;

{ 
  Adds a entry and prints the added entry to the console 
}
PROCEDURE AddEntry(name, task: STRING; span: TimeSpan);
VAR
  entry: WorkEntry;
  error: ErrorCode;
BEGIN
  error := NONE;
  entry := WorkManagementUnit.CreateWorkEntry(name, task, span);
  WorkManagementUnit.AddWorkEntry(entry, error);
  WriteLn('Error: ', error:10, 'Name: ', entry.name, ' | Task: ', entry.task, ' | Time: ', TimeSpanUnit.TimeSpanToString(entry.spendtime));
END;

{
  Tests GetTotalWorkTimeForPerson
}
PROCEDURE TestGetTotalWorkTimeForPerson;
VAR
  span: TimeSpan;
BEGIN
  WriteLn('---------------------- TestGetTotalWorkTimeForPerson ----------------------');
  WorkManagementUnit.Reset();    
  span := TimeSpanUnit.CreateTimeSpan(0, 0, 0);
  WriteLn('No entries are present: ');
  WorkManagementUnit.GetTotalWorkTimeForPerson('Thomas', span);
  WriteLn('Total work time for person: ', TimeSpanUnit.TimeSpanToString(span));   
  WriteLn('');
  
  WorkManagementUnit.Reset();
  AddEntry('Thomas' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 1, 0));   
  AddEntry('Thomas' , 'Spec', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Thomas' , 'Test', TimeSpanUnit.CreateTimeSpan(1, 0, 0)); 
  AddEntry('Hannes' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Hannes' , 'Spec', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Hannes' , 'Test', TimeSpanUnit.CreateTimeSpan(2, 2, 0)); 
  span := TimeSpanUnit.CreateTimeSpan(0, 0, 0);
  WorkManagementUnit.GetTotalWorkTimeForPerson('Thomas', span);
  WriteLn('');
  WriteLn('Total work time for Thomas: ', TimeSpanUnit.TimeSpanToString(span));
  span := TimeSpanUnit.CreateTimeSpan(0, 0, 0);
  WorkManagementUnit.GetTotalWorkTimeForPerson('Hannes', span);
  WriteLn('Total work time for Hannes: ', TimeSpanUnit.TimeSpanToString(span)); 
  WorkManagementUnit.Reset(); 
  WriteLn('---------------------- TestGetTotalWorkTimeForPerson ----------------------');  
  WriteLn('');
END;

{ 
  Tests the AddWorkEntry 
}
PROCEDURE TestAddWorkEntry;
BEGIN
  WriteLn('---------------------- TestAddWorkEntry ----------------------');
  WorkManagementUnit.Reset();
  AddEntry('Thomas', 'Impl', TimeSpanUnit.CreateTimeSpan(8, 0, 1));  
  AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 0, 1));
  AddEntry('Thomas', 'Impl', TimeSpanUnit.CreateTimeSpan(8, 0, 0));  
  AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 0));
  WorkManagementUnit.Reset();  
  WriteLn('---------------------- TestAddWorkEntry ----------------------');
  WriteLn('');
END;

{ 
  Tests the procedure Rest 
}
PROCEDURE TestReset;
BEGIN
  WriteLn('---------------------- TestReset ----------------------');
  WorkManagementUnit.Reset();
  AddEntry('Thomas', 'Impl', TimeSpanUnit.CreateTimeSpan(8, 0, 0));  
  AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(8, 0, 0));
  WorkManagementUnit.Reset();
  WriteLn('---------------------- TestReset ----------------------');
  WriteLn('');
END;

{
  Tests the GetAverageWorkTimeForTask
}
PROCEDURE TestGetAverageWorkTimeForTask;
VAR
  span: TImeSpan;
BEGIN
  WriteLn('---------------------- TestGetAverageWorkTimeForTask ----------------------');
  WorkManagementUnit.Reset();    
  WriteLn('No entries are present: ');
  WorkManagementUnit.GetAverageWorkTimeForTask('Doku', span);
  WriteLn('AverageTime for Doku: ', TimeSpanUnit.TimeSpanToString(span));
  WriteLn(''); 
  
  WorkManagementUnit.Reset();  
  AddEntry('Thomas' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Thomas' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  AddEntry('Hannes' , 'Spec', TimeSpanUnit.CreateTimeSpan(1, 0, 0)); 
  AddEntry('Hannes' , 'Spec', TimeSpanUnit.CreateTimeSpan(0, 2, 0));
  WriteLn('');
  span := TimeSpanUnit.CreateTimeSpan(0, 0, 0);
  WorkManagementUnit.GetAverageWorkTimeForTask('Impl', span);
  WriteLn('Average time for Impl: ', TimeSpanUnit.TimeSpanToString(span));
  span := TimeSpanUnit.createTimeSpan(0, 0, 0);
  WorkManagementUnit.GetAverageWorkTimeForTask('Spec', span);
  WriteLn('Average time for Spec: ', TimeSpanUnit.TimeSpanToString(span));
  WorkManagementUnit.Reset();
  WriteLn('---------------------- TestGetAverageWorkTimeForTask ----------------------');
  WriteLn('');
END;

{
  Tests the procedure PrintPersonForTask
}
PROCEDURE TestPrintPersonForTask;
BEGIN    
  WorkManagementUnit.Reset();    
  WriteLn('No entries are present: ');
  WorkManagementUnit.Reset();
  WorkManagementUnit.PrintPersonForTask('Implementation');
  WriteLn(''); 
  WriteLn('---------------------- TestPrintPersonForTask ----------------------'); 
  AddEntry('Maria' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  AddEntry('Maria' , 'Specification', TimeSpanUnit.CreateTimeSpan(1, 0, 0)); 
  AddEntry('Thomas' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 2, 0));
  AddEntry('Hannes' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Hannes' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(1, 1, 1)); 
  AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 1)); 
  WriteLn('');
  WorkManagementUnit.PrintPersonForTask('Implementation');
  WorkManagementUnit.Reset();
  WriteLn('---------------------- TestPrintPersonForTask ----------------------'); 
  WriteLn(''); 
END;

{
  Test the procedure PrintWorkSummaryForPerson.
}
PROCEDURE TestPrintWorkSummaryForPerson;
BEGIN
  WorkManagementUnit.Reset(); 
  WriteLn('---------------------- TestPrintWorkSummaryForPerson ----------------------'); 
  WriteLn('No entries are present');  
  WorkManagementUnit.PrintWorkSummaryForPerson('Thomas');
  WriteLn('');   
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 2, 2));   
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  AddEntry('Thomas' , 'Specification', TimeSpanUnit.CreateTimeSpan(1, 1, 1)); 
  AddEntry('Thomas' , 'Test', TimeSpanUnit.CreateTimeSpan(2, 2, 2));
  AddEntry('Hannes' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Hannes' , 'Test', TimeSpanUnit.CreateTimeSpan(0, 1, 2)); 
  AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(1, 1, 1)); 
  AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 1));  
  
  WorkManagementUnit.PrintWorkSummaryForPerson('Thomas');
  WriteLn('');
  WorkManagementUnit.PrintWorkSummaryForPerson('Hannes');
  WorkManagementUnit.Reset();
  WriteLn('---------------------- TestPrintWorkSummaryForPerson ----------------------'); 
  WriteLn('');
END;

{
  Tests the function BusiestPerson
}
PROCEDURE TestBusiestPerson;
VAR
  name: STRING;
BEGIN
  WriteLn('---------------------- TestBusiestPerson ----------------------'); 
  WorkManagementUnit.Reset();
  WriteLn('No entries:');
  WriteLn('Buisiest person: ', WorkManagementUnit.BusiestPerson);
  WriteLn('');
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  AddEntry('Maria' , 'Specification', TimeSpanUnit.CreateTimeSpan(1, 1, 1)); 
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 2, 2));  
  AddEntry('Hannes' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 2, 0)); 
  AddEntry('Maria' , 'Test', TimeSpanUnit.CreateTimeSpan(2, 2, 2));
  name := WorkManagementUnit.BusiestPerson;
  WriteLn('Buisiest person: ', name);  
  WorkManagementUnit.Reset();
  WriteLn('---------------------- TestBusiestPerson ----------------------'); 
  WriteLn('');
END;

BEGIN
  { Test AddWorkEntry }
  TestAddWorkEntry;
  { Test TestReset }
  TestReset;
  { TestGetTotalWorkTimeForPerson }
  TestGetTotalWorkTimeForPerson;
  { Tests GetAverageWorkTimeForTask }
  TestGetAverageWorkTimeForTask;
  { Test for PrintWorkSummaryForPerson }
  TestPrintWorkSummaryForPerson;
  { Test PrintPersonForTimeTask }
  TestPrintPersonForTask;
  { Test TestBusiestPerson }
  TestBusiestPerson;
END.