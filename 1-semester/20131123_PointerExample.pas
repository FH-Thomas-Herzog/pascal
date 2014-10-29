PROGRAM PointerExample;

TYPE
  IntPtr = ^INTEGER;
  
{ Swaps to integer variables }
PROCEDURE Swap(VAR a,b:INTEGER);
VAR
  help: INTEGER;
BEGIN
  help := a;
  a := b;
  b := help;
END;

{ Swaps the values of to Integer pointers, not the addresses }
PROCEDURE Swap2(pA,pB:IntPtr);
VAR
  help: INTEGER;
BEGIN
  help := pA^;
  pA^ := pB^;
  pB^ := help;
END;

{ Main program }
VAR
  x,y:INTEGER;
BEGIN
  x := 3;
  y := 4;
  { With VAR keyword }
  writeln('before: ', x, ' ' , y);
  Swap(x,y);
  writeln('after: ', x, ' ' , y);  
  { With pointer }
  writeln('before: ', x, ' ' , y);
  Swap2(@x,@y);
  writeln('after: ', x, ' ' , y);
END.

(*
VAR
  x,y: INTEGER;
  pX,pY,pArr: ^INTEGER;
  
BEGIN
  { Gets the addresses of the variables in the memory }
  pX := @x;
  pY := @y;
  x := 15;
  pX^ := 13;
  writeln(x);
  writeln(pX^);
  writeln(LONGINT(pY));
  
  
END.
*)