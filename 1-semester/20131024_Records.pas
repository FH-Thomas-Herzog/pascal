Program Records;

Type
  MyRecord = Record
    a,b: String;
    c: Integer;
    d: Record
      a: String;
    End;
    e: Array[1..3] Of Integer;
  End;
  
Var
  x: Record
    a: String;
    b: Integer;
    c: Real;
  m: MyRecord;
  End;
  m: MyRecord;
  
Begin
  x.a := 'Hello';
  x.b := 1234;
  x.c := 12.21;
  
  m.a := 'Hallo';
  m.d.a := 'nested';
  m.e[1] := 1;
End.