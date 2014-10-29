{ === PROGRAM DynArray === }
{ Sample program that demonstrates usage of dynamic arrays in pascal. }
{ GHO, 23.3.2009 }
PROGRAM DynArray;

USES WinCrt;

TYPE
  ElementType = INTEGER;
  IntArray = ARRAY[1..1] OF ElementType;
  IntArrayPtr = ^IntArray;

PROCEDURE RUN;
VAR
  arr: IntArrayPtr;
  i: INTEGER;
BEGIN
  {allocate memory for dynamic array with ten elements}

  GetMem(arr, 10 * SizeOf(ElementType));
  {use dynamic array}
  FOR i := 1 TO 10 DO
    arr^[i] := i;
  FOR i := 1 TO 10 DO
    Write(arr^[i], ' ');
  WriteLn;
  {free same amount of memory that has been allocated before after usage}
  FreeMem(arr, 10 * SizeOf(ElementType));

END;

BEGIN
  (*$R-*)
  Run;
    (*$R+*)
END.