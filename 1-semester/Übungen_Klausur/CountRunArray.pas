PROGRAM CountRunExample;

{
  Counts the run of ascendent ordered values of the given array.
}
FUNCTION countRun(a: ARRAY OF INTEGER): INTEGER;
VAR 
  i, j, count, newCount, value: INTEGER;
BEGIN
  count := 1;
  FOR i := Low(a) TO (High(a) - 1) DO BEGIN
    newCount := 1;
    value := a[i];
    FOR j := (i + 1) TO High(a) DO BEGIN
      IF (a[j] >= value) THEN BEGIN
        Inc(newCount);
      END;
      value := a[j];
    END;
    IF (newCount > count) THEN BEGIN
      count := newCount;
    END;
  END;
  countRun := count;
END;

VAR
  a: ARRAY[1..5] OF INTEGER;
BEGIN
  a[1] := 9;
  a[2] := 8;
  a[3] := 7;
  a[4] := 8;
  a[5] := 5;
  writeln('Count: ', countRun(a));
END.