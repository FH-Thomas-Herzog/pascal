{
  Progam which displays some examples of recursive function calls.
}
PROGRAM Recursive;

{
  Calculate the factorial  of a number via recurive calls of this function.
  
  @param
      x: the number to calculate the facrotial 
  @param
      the calculated factorial, or 1 if x <= 1
}
FUNCTION Factorial(x: INTEGER): LONGINT;
BEGIN
  IF (x <= 1) THEN BEGIN
    Factorial := 1
  END
  ELSE BEGIN
    Factorial := x * Factorial(x - 1);
  END;
END;

{
  Calculate the greates common factor of the two given numbers
  
  @param
      p: the first number
  @param
      q: the second number
  @return
      the calculated greates common factor
}
FUNCTION Ggt(p: INTEGER; q: LONGINT): INTEGER;
BEGIN
  IF ((p MOD q) = 0) THEN BEGIN
    GGT := q
  END
  ELSE BEGIN
    Ggt := Ggt(q, (p MOD q));
  END;
END;

{
  Calculates the fibonacci sequence.
  
  @param
      x: the count to calculate the fibonacci sequence for
  @return
      the calculated fibonacci sequence
}
FUNCTION Fibonacci(x: LONGINT): LONGINT;
BEGIN
  IF (x <= 0) THEN BEGIN
    Fibonacci := 0;
  END
  ELSE IF (x = 1) THEN BEGIN
    Fibonacci := 1;
  END
  ELSE BEGIN
    Fibonacci := Fibonacci(x - 1) + Fibonacci(x - 2);
  END;
END;

{ Main program }
VAR
  i: INTEGER;
BEGIN
  { Test the Factorial function }
  FOR i := 1 TO 10 DO BEGIN
    WriteLn(Factorial(i));
  END;
  WriteLn;
  
  { Test the Factorial function with prim numbers }
  WriteLn(Ggt(2 *  2 * 3 * 5 * 5 * 7, 2 * 5 * 7 * 11));
  WriteLn;
  
  { Test the Fibonacci function }
  FOR i := 1 TO 10 DO BEGIN
    WriteLn(Fibonacci(i));
  END;
  WriteLn;
  
END.