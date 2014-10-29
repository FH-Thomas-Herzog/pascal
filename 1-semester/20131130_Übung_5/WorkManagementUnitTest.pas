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
  WorkManagementUnit.Reset(100);    
  WriteLn('No entries are present: ');
  WorkManagementUnit.GetTotalWorkTimeForPerson('Thomas', span);
  WriteLn('Total work time for person: ', TimeSpanUnit.TimeSpanToString(span));   
  WriteLn('');
  
  WorkManagementUnit.Reset(100);
  AddEntry('Thomas' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 1, 0));   
  AddEntry('Thomas' , 'Spec', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Thomas' , 'Test', TimeSpanUnit.CreateTimeSpan(1, 0, 0)); 
  AddEntry('Hannes' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Hannes' , 'Spec', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Hannes' , 'Test', TimeSpanUnit.CreateTimeSpan(2, 2, 0)); 
  WorkManagementUnit.GetTotalWorkTimeForPerson('Thomas', span);
  WriteLn('');
  WriteLn('Total work time for Thomas: ', TimeSpanUnit.TimeSpanToString(span));
  WorkManagementUnit.GetTotalWorkTimeForPerson('Hannes', span);
  WriteLn('Total work time for Hannes: ', TimeSpanUnit.TimeSpanToString(span));  
  WriteLn('---------------------- TestGetTotalWorkTimeForPerson ----------------------');  
  WriteLn('');
END;

{ 
  Tests the AddWorkEntry 
}
PROCEDURE TestAddWorkEntry;
VAR
  i: INTEGER;
  entry: WorkEntry;
  error: ErrorCode;
BEGIN
  WriteLn('---------------------- TestAddWorkEntry ----------------------');
  WorkManagementUnit.Reset(100);
  AddEntry('Thomas', 'Impl', TimeSpanUnit.CreateTimeSpan(8, 0, 1));  
  AddEntry('Thomas', 'Impl',  TimeSpanUnit.CreateTimeSpan(0, 0, 59));
  
  FOR i := 1 TO 101 DO BEGIN
    Write(i:3, '. ');
    AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 0, 59));
  END;
  WriteLn('---------------------- TestAddWorkEntry ----------------------');
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
  WorkManagementUnit.Reset(100);    
  WriteLn('No entries are present: ');
  WorkManagementUnit.GetAverageWorkTimeForTask('Doku', span);
  WriteLn('AverageTime for Doku: ', TimeSpanUnit.TimeSpanToString(span));
  WriteLn(''); 
  
  WorkManagementUnit.Reset(100);  
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
  WriteLn('---------------------- TestGetAverageWorkTimeForTask ----------------------');
  WriteLn('');
END;

PROCEDURE TestPrintPersonForTask;
BEGIN    
  WorkManagementUnit.Reset(100);    
  WriteLn('No entries are present: ');
  WorkManagementUnit.Reset(100);
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
  WriteLn('---------------------- TestPrintPersonForTask ----------------------'); 
  WriteLn(''); 
END;

{
  Test the procedure PrintWorkSummaryForPerson.
}
PROCEDURE TestPrintWorkSummaryForPerson;
BEGIN
  WorkManagementUnit.Reset(100); 
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
  WriteLn('---------------------- TestPrintWorkSummaryForPerson ----------------------'); 
  WriteLn('');
END;

BEGIN
  { Test AddWorkEntry }
  TestAddWorkEntry;
  { TestGetTotalWorkTimeForPerson }
  TestGetTotalWorkTimeForPerson;
  { Tests GetAverageWorkTimeForTask }
  TestGetAverageWorkTimeForTask;
  { Test for PrintWorkSummaryForPerson }
  TestPrintWorkSummaryForPerson;
  { Test PrintPersonForTimeTask }
  TestPrintPersonForTask;
END.