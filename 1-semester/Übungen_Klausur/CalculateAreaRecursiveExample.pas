PROGRAM CaculcateAreaRecursiveExample;

FUNCTION Area(i:INTEGER; x:REAL): REAL;
BEGIN
  IF (i = 1) THEN BEGIN
    writeln(x);
    Area := (x * x) / 2;
  END
  ELSE
    Area := Area(i - 1, 2 * x);
END;

BEGIN
  WriteLn(Area(5, 1):5:5);
END.