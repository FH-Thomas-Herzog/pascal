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
  WriteLn('Error: ', error:13, 'Name: ', entry.name:10, ' | Task: ', entry.task:15, ' | Time: ', TimeSpanUnit.TimeSpanToString(entry.spendtime));
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
  WriteLn('Total work time for Thomas: ', TimeSpanUnit.TimeSpanToString(span));   
  WriteLn;
  
  WorkManagementUnit.Reset();
  AddEntry('Thomas' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 1, 0));   
  AddEntry('Thomas' , 'Spec', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Thomas' , 'Test', TimeSpanUnit.CreateTimeSpan(1, 0, 0)); 
  WorkManagementUnit.GetTotalWorkTimeForPerson('Maria', span);
  WriteLn('Total work time for Maria: ', TimeSpanUnit.TimeSpanToString(span));     
  WriteLn;
  
  WorkManagementUnit.Reset();
  AddEntry('Thomas' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 1, 0));   
  AddEntry('Thomas' , 'Spec', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Thomas' , 'Test', TimeSpanUnit.CreateTimeSpan(1, 0, 0)); 
  AddEntry('Hannes' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Hannes' , 'Spec', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Hannes' , 'Test', TimeSpanUnit.CreateTimeSpan(2, 2, 0)); 
  span := TimeSpanUnit.CreateTimeSpan(0, 0, 0);
  WorkManagementUnit.GetTotalWorkTimeForPerson('Thomas', span);
  WriteLn;
  
  WriteLn('Total work time for Thomas: ', TimeSpanUnit.TimeSpanToString(span));
  span := TimeSpanUnit.CreateTimeSpan(0, 0, 0);
  WorkManagementUnit.GetTotalWorkTimeForPerson('Hannes', span);
  WriteLn('Total work time for Hannes: ', TimeSpanUnit.TimeSpanToString(span)); 
  WorkManagementUnit.Reset(); 
  WriteLn('---------------------- TestGetTotalWorkTimeForPerson ----------------------');  
  WriteLn;
END;

{ 
  Tests the AddWorkEntry 
}
PROCEDURE TestAddWorkEntry;
BEGIN
  WriteLn('---------------------- TestAddWorkEntry BEGIN ----------------------');
  WorkManagementUnit.Reset();
  AddEntry('Thomas', 'Specification', TimeSpanUnit.CreateTimeSpan(0, 0, 1));  
  AddEntry('THomas', 'Specification', TimeSpanUnit.CreateTimeSpan(8, 0, 1));    
  AddEntry('THomas', 'Specification', TimeSpanUnit.CreateTimeSpan(1, 60, 60));
  AddEntry('HaNNes' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 0));
  AddEntry('HaNnes' , 'SpecificaTIon', TimeSpanUnit.CreateTimeSpan(0, 1, 0));
  AddEntry('Thomas' , 'SpecificaTIon', TimeSpanUnit.CreateTimeSpan(0, 1, 0));
  AddEntry('THOmas' , 'SpecificaTIon', TimeSpanUnit.CreateTimeSpan(0, 1, 0));
  AddEntry('Maria' , 'Specification', TimeSpanUnit.CreateTimeSpan(8, 0, 0));
  AddEntry('MAria' , 'SpecifICation', TimeSpanUnit.CreateTimeSpan(8, 0, 0));
  AddEntry('Julia' , 'SpecifICation', TimeSpanUnit.CreateTimeSpan(8, 0, 0));
  WriteLn;
  WorkManagementUnit.Reset();
  WriteLn('---------------------- TestAddWorkEntry END ----------------------');
  WriteLn;
END;

{ 
  Tests the procedure Rest 
}
PROCEDURE TestReset;
BEGIN
  WriteLn('---------------------- TestReset ----------------------');
  WorkManagementUnit.Reset();
  AddEntry('Thomas', 'Impl', TimeSpanUnit.CreateTimeSpan(8, 0, 0));  
  AddEntry('Thomas', 'Impl', TimeSpanUnit.CreateTimeSpan(8, 0, 0)); 
  AddEntry('Thomas', 'Spec', TimeSpanUnit.CreateTimeSpan(8, 0, 0));  
  AddEntry('Thomas', 'Spec', TimeSpanUnit.CreateTimeSpan(8, 0, 0)); 
  AddEntry('Thomas', 'Test', TimeSpanUnit.CreateTimeSpan(8, 0, 0)); 
  AddEntry('Thomas', 'Test', TimeSpanUnit.CreateTimeSpan(8, 0, 0));   
  AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(8, 0, 0));
  AddEntry('Hannes' , 'Testing', TimeSpanUnit.CreateTimeSpan(8, 0, 0));
  AddEntry('Hannes' , 'Implementation', TimeSpanUnit.CreateTimeSpan(8, 0, 0));
  WorkManagementUnit.Reset();
  WriteLn('---------------------- TestReset ----------------------');
  WriteLn;
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
  WriteLn; 
  AddEntry('Thomas' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Thomas' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  WorkManagementUnit.GetAverageWorkTimeForTask('Doku', span);
  WriteLn('AverageTime for Doku: ', TimeSpanUnit.TimeSpanToString(span));
  WriteLn; 
  
  WorkManagementUnit.Reset();  
  AddEntry('Thomas' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Thomas' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  AddEntry('Thomas' , 'Spec', TimeSpanUnit.CreateTimeSpan(0, 2, 0)); 
  AddEntry('Thomas' , 'Spec', TimeSpanUnit.CreateTimeSpan(0, 2, 0)); 
  AddEntry('Hannes' , 'Spec', TimeSpanUnit.CreateTimeSpan(1, 0, 0)); 
  AddEntry('Hannes' , 'Spec', TimeSpanUnit.CreateTimeSpan(0, 2, 0)); 
  AddEntry('Hannes' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 1, 0));  
  AddEntry('Hannes' , 'Impl', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  
  WriteLn;
  span := TimeSpanUnit.CreateTimeSpan(0, 0, 0);
  WorkManagementUnit.GetAverageWorkTimeForTask('Impl', span);  
  WriteLn;
  WriteLn('Average time for Impl: ', TimeSpanUnit.TimeSpanToString(span));
  
  span := TimeSpanUnit.createTimeSpan(0, 0, 0);
  WorkManagementUnit.GetAverageWorkTimeForTask('Spec', span);
  WriteLn;
  WriteLn('Average time for Spec: ', TimeSpanUnit.TimeSpanToString(span)); 
  
  WorkManagementUnit.Reset();
  WriteLn('---------------------- TestGetAverageWorkTimeForTask ----------------------');
  WriteLn;
END;

{
  Tests the procedure PrintPersonForTask
}
PROCEDURE TestPrintPersonForTask;
BEGIN    
  WorkManagementUnit.Reset();    
  WriteLn('No entries are present: ');
  WorkManagementUnit.PrintPersonForTask('Implementation');
  
  WorkManagementUnit.Reset();
  AddEntry('Maria' , 'Test', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Thomas' , 'Test', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  WorkManagementUnit.PrintPersonForTask('Implementation');
  WriteLn; 
  
  WriteLn('---------------------- TestPrintPersonForTask ----------------------'); 
  AddEntry('Maria' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  AddEntry('Maria' , 'Specification', TimeSpanUnit.CreateTimeSpan(1, 0, 0)); 
  AddEntry('Markus' , 'Test', TimeSpanUnit.CreateTimeSpan(0, 2, 0));
  AddEntry('Hannes' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Hannes' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(1, 1, 1)); 
  AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 1)); 
  AddEntry('Julia' , 'Doku', TimeSpanUnit.CreateTimeSpan(0, 2, 0));
  WriteLn;
  WorkManagementUnit.PrintPersonForTask('Implementation');
  WorkManagementUnit.Reset();
  WriteLn('---------------------- TestPrintPersonForTask ----------------------'); 
  WriteLn; 
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
  WriteLn; 
  AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(1, 1, 1)); 
  AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 1));   
  WorkManagementUnit.PrintWorkSummaryForPerson('Thomas');
  WriteLn; 
  
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 2, 2));   
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  AddEntry('Thomas' , 'Specification', TimeSpanUnit.CreateTimeSpan(1, 1, 1)); 
  AddEntry('Thomas' , 'Test', TimeSpanUnit.CreateTimeSpan(2, 2, 2));
  AddEntry('Hannes' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 2, 0));   
  AddEntry('Hannes' , 'Test', TimeSpanUnit.CreateTimeSpan(0, 1, 2)); 
  AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(1, 1, 1)); 
  AddEntry('Hannes' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 1));  
  
  WorkManagementUnit.PrintWorkSummaryForPerson('Thomas');
  WriteLn;
  WorkManagementUnit.PrintWorkSummaryForPerson('Hannes');
  WorkManagementUnit.Reset();
  WriteLn('---------------------- TestPrintWorkSummaryForPerson ----------------------'); 
  WriteLn;
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
  
  WriteLn;
  WriteLn('single result:');
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 1)); 
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 2));  
  AddEntry('Maria' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 1));   
  AddEntry('Maria' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 1)); 
  AddEntry('Hannes' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  AddEntry('Hannes' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  name := WorkManagementUnit.BusiestPerson;
  WriteLn('Buisiest person: ', name);    
  
  WriteLn;
  WriteLn('multiple result:');
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 1)); 
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 2));  
  AddEntry('Maria' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 2));   
  AddEntry('Maria' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 1)); 
  AddEntry('Hannes' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  AddEntry('Hannes' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 0)); 
  name := WorkManagementUnit.BusiestPerson;
  WriteLn('Buisiest person: ', name); 
  
  WorkManagementUnit.Reset();
  WriteLn('---------------------- TestBusiestPerson ----------------------'); 
  WriteLn;
END;

{
  Tests the function GetToalWorkEntryCount
}
PROCEDURE TestGetToalWorkEntryCount;
VAR
  i, count: LONGINT;
  it: STRING;
BEGIN
  count := 10;
  WriteLn('---------------------- TestGetToalWorkEntryCount ----------------------');  
  WorkManagementUnit.Reset();
  WriteLn('No entries:');
  WriteLn('Total work entry count: ', WorkManagementUnit.GetTotalWorkEntryCount);
  WriteLn;
  
  WriteLn('Adding ', count, ' different persons with each two work entry');
  FOR i := 1 TO count DO BEGIN
    Str(i, it);
    AddEntry((it + '-Thomas') , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 1)); 
    AddEntry((it + '-Thomas') , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 1)); 
  END;
  WriteLn('Total work entry count: ', WorkManagementUnit.GetTotalWorkEntryCount);
  WriteLn('---------------------- TestGetToalWorkEntryCount ----------------------');
END;

(*
{
  Tests the function DeletePerson
}
PROCEDURE TestDeletePerson;
VAR
  result: BOOLEAN;
BEGIN
  WriteLn('---------------------- TestGetToalWorkEntryCount ----------------------');  
  WorkManagementUnit.Reset();
  WriteLn('No entries:');
  WriteLn('Deleted: ', WorkManagementUnit.DeletePerson('thomas'));
  
  WriteLn;
  WorkManagementUnit.Reset();
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 1)); 
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 2));  
  AddEntry('Maria' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 2));   
  AddEntry('Maria' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 1)); 
  WriteLn;
  WriteLn('Deleted: ', WorkManagementUnit.DeletePerson('hannes'));
  
  WriteLn;
  WorkManagementUnit.Reset();
  AddEntry('Hannes' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 1)); 
  AddEntry('Hannes' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 2)); 
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 1)); 
  AddEntry('Thomas' , 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 2));  
  AddEntry('Maria' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 2));   
  AddEntry('Maria' , 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 1)); 
  WriteLn;
  result := WorkManagementUnit.DeletePerson('thomas');  
  WriteLn;
  WriteLn('Deleted: ', result); 
  WriteLn;
  WriteLn('Total work entry count: ', WorkManagementUnit.GetTotalWorkEntryCount); 
  WriteLn;
  WorkManagementUnit.PrintWorkSummaryForPerson('maria'); 
  WriteLn;
  WorkManagementUnit.PrintWorkSummaryForPerson('hannes');
  
  WriteLn('---------------------- TestGetToalWorkEntryCount ----------------------');
END;
*)

{
  Tests the performance when work items are saved for one person
}
PROCEDURE TestPerformanceWorkEntry;
VAR
  i: LONGINT;
  it: STRING;
  error: ErrorCode;
BEGIN
  FOR i := 1 TO 10000 DO BEGIN
    Str(i, it);
    WorkManagementUnit.AddWorkEntry(WorkManagementUnit.CreateWorkEntry('Thomas', 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 1)), error);
  END;
  WriteLn('Adding new task on last index');
  WorkManagementUnit.AddWorkEntry(WorkManagementUnit.CreateWorkEntry('Thomas', 'Specification', TimeSpanUnit.CreateTimeSpan(0, 1, 1)), error);
  { WorkManagementUnit.PrintWorkSummaryForPerson('Thomas'); }
  WriteLn('Total work entry count: ', WorkManagementUnit.GetTotalWorkEntryCount);
END;

{
  Tests the performance when multiple persons are saved with each one work item
}
PROCEDURE TestPerformancePersons;
VAR
  i: LONGINT;
  it: STRING;
BEGIN
  FOR i := 1 TO 20000 DO BEGIN
    Str(i, it);
    AddEntry((it + '-Thomas'), 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 1));  
  END;
  WriteLn('Finished Insert');
  WriteLn('Total work entry count: ', WorkManagementUnit.GetTotalWorkEntryCount);
END;

{
  Tests the performance when multiple persons are saved with each 10 additonal work items
}
PROCEDURE TestPerformancePersonWorkEntry;
VAR
  i, j: LONGINT;
  it, it2: STRING;
BEGIN
  WorkManagementUnit.PrintPersonForTask('Implementation');
  FOR i := 1 TO 50000 DO BEGIN
    Str(i, it);
    AddEntry((it + '-Thomas'), 'Implementation', TimeSpanUnit.CreateTimeSpan(0, 1, 1));
  END;
  { WorkManagementUnit.PrintPersonForTask('Implementation'); }
  WriteLn('Finished Insert');
  WriteLn('Total work entry count: ', WorkManagementUnit.GetTotalWorkEntryCount);
END;

BEGIN  
  (*
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
  { Test GetToalWorkEntryCount }
  TestGetToalWorkEntryCount;
  { Test Performance with work entries }
  TestPerformanceWorkEntry;
  { 
    Test Performance with persons and work entries
    Set constant factor to 1 to se performance decrease.
  }
  TestPerformancePersonWorkEntry;
  *)
  
  (* 
  No implemented for this version !!!!!!
  { Test DeletePerson }
  TestDeletePerson;
  *)
END.