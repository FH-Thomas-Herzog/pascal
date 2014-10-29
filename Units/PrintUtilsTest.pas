  
{
  This program tests the PrintUtils unit.
}
Program PrintUtilsTest;

Uses
  PrintUtils, Sysutils, Crt;

{
  Tests the function PrintHeader
}
Procedure TestPrintHeader;
Begin
  // Print header in default colour
  PrintUtils.PrintHeader('This header should be blue');
End;

{
  Tests the function PrintError
} 
Procedure TestPrintError;
Begin
  // Print header in default colour
  PrintUtils.PrintError('This error should be red');
End;

{
  Tests the function Print
}
Procedure TestPrint;
Begin
  // Print header in default colour
  PrintUtils.Print('This test should be white with green background', Green, White);
  writeln;
  // Print header in default colour
  PrintUtils.Print('This test should be yellow with blue background', Blue, Yellow);
  writeln;
End;
Begin
  // Test PrintHeader
  TestPrintHeader;
  writeln;
  
  // Test PrintError
  TestPrintError;
  writeln;
  
  // Test Print
  TestPrint;
  writeln;
  
End.