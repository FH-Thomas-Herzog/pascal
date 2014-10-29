PROGRAM DynamicMemoryExample;

VAR Pa, Pb: ^STRING;

BEGIN
  new(pa);
  pA^ := 'Hello world';
  WriteLn(pA^);
  pB := pA;  
  WriteLn(pB^);
  
  Dispose(pA);
END.

(*
VAR
  pX: ^STRING;
BEGIN
  new(pX);
  pX^ := 'Hello World';
  WriteLn(pX^);
  Dispose(pX);
END.
*)