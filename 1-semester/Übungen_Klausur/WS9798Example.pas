PROGRAM WS9798Example;
Const
  m = 3;
TYPE
  IntArray =  ARRAY[1..m] OF INTEGER;

VAR
  a:IntArray;

PROCEDURE P(ar: IntArray; n: INTEGER);
BEGIN
  IF (n < m) THEN 
    P(ar, n + 1);
  WriteLn(ar[n]);
END;

VAR
  s: STRING;
BEGIN
  a[1] := 11;
  a[2] := 12;
  a[3] := 13;
  P(a, 1);
END.