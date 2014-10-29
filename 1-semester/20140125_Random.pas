{
  GEnerates a random Integer with  a linear kongurent algorithm.
}
PROGRAM RandomGenerator;
VAR
  x: LONGINT;
  
CONST 
  m = 32768;
  
{
  Generates a random Integer value out of the Integer value range
  via the linear kongurenz method
}
FUNCTION IntRandom:INTEGER;
CONST
  k = 3421;
  d =  1;
BEGIN
  x := (k * x + d) MOD m;
  IntRandom := x;
END;
 
{ Insufficent when n|m, causes break of the random }
{
  Generates a ranom integer out of a specifc range.
  Is insufficent because it is not guarenteed that n is Integter divisor of m
}
FUNCTION GenerateRangesRandom(n: INTEGER): INTEGER;
BEGIN
  GenerateRangesRandom := IntRandom MOD n;
END;

{
  Generates a ranom integer out of a specifc range.
  Here it is guarenteed that the n is integer divisior of m
}
FUNCTION GenerateRangesRandom2(n: INTEGER): INTEGER;
VAR
  k, ir: INTEGER;
BEGIN
  { guarentees equvally distributed random }
  k := (m DIV n) * n;
  { guarentees that random int is smaller then calculated k }
  REPEAT
    ir := IntRandom;
  UNTIL ir < k;
  GenerateRangesRandom2 := ir MOD n;
END;

{ Generates a radnom real value }
FUNCTION RealRandom: REAL;
BEGIN
  RealRandom := IntRandom / m;
END;

{ Calculates PI via Mote Carlo way }
FUNCTION approximatePI(n: LONGINT): REAL;
VAR
  i, p: LONGINT;
  x, y: REAL;
BEGIN
  p := 0;
  FOR i := 0 TO n DO BEGIN
    x := RealRandom;
    y := RealRandom;
    IF ((x * x) + (y * y)) <= 1 THEN
      Inc(p);
  END;
  approximatePI := (4 * p) / n;
END;

VAR 
  i: INTEGER;
BEGIN
  x := 1235;
  (* FOR i := 0 TO 100 DO
    Write(GenerateRangesRandom(30), ', ');
    
  WriteLn;
  WriteLn;
  FOR i := 0 TO 10 DO
    Write(GenerateRangesRandom2(30), ', ');
    
  WriteLn;
  WriteLn;
  FOR i := 0 TO 100 DO
    Write(RealRandom:5, ', '); *)
    
  WriteLn;
  WriteLn;
  FOR i := 1 TO 10 DO
    WriteLn(i,': ', approximatePI(i * 100000):0:10);
END.