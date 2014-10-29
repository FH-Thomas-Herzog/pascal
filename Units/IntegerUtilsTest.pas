{
  This program tests the IntegerUtils unit.
}
Program IntegerUtilsTest;

Uses
  Sysutils, Crt, IntegerUtils, PrintUtils;

{
  Tests the function IsValidRange with no strict option
}  
procedure TestIsValidRangeNotStrict;
Var
  min, max: Integer;
Begin
  // Equal
  PrintUtils.PrintHeader('Equal min, max');
  min := 55;
  max := 55;
  writeln('min: ', min, ' / max: ', max, ' / result: ', IntegerUtils.IsValidRange(min, max));
  writeln;
  
  // Max overflow
  PrintUtils.PrintHeader('max overflow');
  min := 55;
  max := 10;
  writeln('min: ', min, ' / max: ', max, ' / result: ', IntegerUtils.IsValidRange(min, max));
  writeln;
  
  // Valid
  PrintUtils.PrintHeader('Valid');
  min := 10;
  max := 55;
  writeln('min: ', min, ' / max: ', max, ' / result: ', IntegerUtils.IsValidRange(min, max));
  writeln;
End;

{
  Tests the function IsValidRange with strict option
}  
procedure TestIsValidRangeStrict;
Var
  min, max: Integer;
Begin
  // Equal not strict
  PrintUtils.PrintHeader('Equal min, max not strict');
  min := 55;
  max := 55;
  writeln('min: ', min, ' / max: ', max, ' / result: ', IntegerUtils.IsValidRange(min, max, false));
  writeln;
  
  // Equal strict
  PrintUtils.PrintHeader('Equal min, max strict');
  min := 55;
  max := 55;
  writeln('min: ', min, ' / max: ', max, ' / result: ', IntegerUtils.IsValidRange(min, max, true));
  writeln;
  
  // Max overflow
  PrintUtils.PrintHeader('max overflow');
  min := 55;
  max := 10;
  writeln('min: ', min, ' / max: ', max, ' / result: ', IntegerUtils.IsValidRange(min, max, true));
  writeln;
  
  // Valid
  PrintUtils.PrintHeader('Valid');
  min := 10;
  max := 55;
  writeln('min: ', min, ' / max: ', max, ' / result: ', IntegerUtils.IsValidRange(min, max, true));
  writeln;
End;
Begin
  // Test IsValidRange not strict
  PrintUtils.Print('Tests IsValidRange not strict', Green, White);
  TestIsValidRangeNotStrict;
  writeln;
  
  // Test IsValidRange strict
  PrintUtils.Print('Tests IsValidRange strict', Green, White);
  TestIsValidRangeStrict;
  writeln;
End.