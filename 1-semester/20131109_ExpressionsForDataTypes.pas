{
  Default is Kurzschlussauswertung
  Compile directive deactivate this by 
  the following compiler directive.
}
PROGRAM ExpressionsForDataTypes;

FUNCTION A:BOOLEAN;
BEGIN
  WriteLn('A called');
  A:=false;
END;

FUNCTION B:BOOLEAN;
BEGIN
  WriteLn('B called');
  B:= true;
END;

CONST
  N = 42;
VAR
  i, x: INTEGER;
  ar: ARRAY[1..N] OF INTEGER;
  s:STRING;
  s1:STRING[10];
  c:CHAR;
  r:REAL;
  bool:BOOLEAN;
BEGIN
  
  {
    Test evaluation of bool expressions with full or partial evaluaton of the bool expressions
  }
  IF A AND B THEN BEGIN
    WriteLn('then');
  END;
  
  WriteLn('Kurzschluusauswertung');

  IF A AND B THEN BEGIN
    WriteLn('then');
  END;
  
  {
    Test overflow with full or partial evaluaton of the bool expressions
  }
  FOR i := 1 TO N DO
    ar[i]  := 0;
  
  x:= 42;
  i:= 1;
  WHILE (i<=N) AND (ar[i] <> x) DO
    i := i+1;
    
  WriteLn('Iteration variable ', i);
  
  {
    Relational bool operands.
    i < i + i <=> i < (i + i)
  }
  IF i < i + i THEN
    WriteLn('expr true');
    
  {
    String operations
  }
  s := 'FH';
  c := '-';
  s1 := s + c + 'Hagenberg';
  WriteLn(s1);
  
  {
    Type cast
  }
  i := Integer(c);
  WriteLn('"_" as integer: ', i);
  
  bool := true;
  i := Integer(bool);
  WriteLn('true as int: ', i);
  
  c := Char(65);
  WriteLn('65 as char: ', c);
  Str(123, s);
  WriteLn(s);
END.