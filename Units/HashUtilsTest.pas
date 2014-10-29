{
   This program tests the HashUtils unit.
}
Program HashUtilsTest;

Uses
  HashUtils, PrintUtils, Crt, Sysutils;

Type
  IndexRange = 1..100;
 
{
   Tests the function ComputeHashOrdinalOnly.
}
Procedure TestComputeHashOrdinalOnly;
Var
  hash: IndexRange;
  state: HashState;
  i: Integer;
Begin
  // Produces same hash value
  PrintUtils.PrintHeader('Produces equal hash value');
  for i := 1 to 2 do begin
    writeln(i, '. Thomas: ', HashUtils.ComputeHashOrdinalOnly('Thomas', Low(IndexRange), High(IndexRange), state));
    writeln(i, '. State : ', state);
    writeln(i, '. Hugo  : ', HashUtils.ComputeHashOrdinalOnly('Hugo', Low(IndexRange), High(IndexRange), state));
    writeln(i, '. State : ', state);
    writeln;
  end;
  writeln;
  
  // Produces collisions
  PrintUtils.PrintHeader('Produces collsions');
  writeln('Thomas: ', HashUtils.ComputeHashOrdinalOnly('Thomas', Low(IndexRange), High(IndexRange), state));
  writeln('State : ', state);
  writeln;
  writeln('Wolfganf: ', HashUtils.ComputeHashOrdinalOnly('Wolfganf', Low(IndexRange), High(IndexRange), state));
  writeln('State   : ', state);
End;

Begin
  // Test ComputeHashOrdinalOnly
  PrintUtils.Print('Test ComputeHashOrdinalOnly', Green, White);
  TestComputeHashOrdinalOnly
End.