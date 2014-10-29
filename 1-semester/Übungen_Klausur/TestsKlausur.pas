PROGRAM RemoveMultipleOfXExample;

{ 
  Checks if value is multiple of x 
}
FUNCTION isMultipleOf(value, x: INTEGER): BOOLEAN;
VAR
  fact, result: INTEGER;
BEGIN
  fact := 0;
  result := 0;
  REPEAT BEGIN
    Inc(fact);
    result := x * fact;
  END
  UNTIL (result >= value);
  isMultipleOf := result = value;
END;

{ 
  removes element on given index and decreases length 
  ATTENTION: here the lowest index is 0 and the highest indes is length - 1,
  so be sure that the index and length are properlyx set from the outside
}
PROCEDURE removeElement(VAR a: ARRAY OF INTEGER; VAR length: INTEGER; idx: INTEGER);
VAR
  i: INTEGER;
BEGIN
  FOR i := idx TO length - 1 DO BEGIN
    a[i] := a[i + 1];
  END;
  IF idx <= length THEN BEGIN
    Dec(length); 
  END;
END;

{ 
  Removes all elements with value multiple of x
}
PROCEDURE RemoveMultipleOfX(VAR a: ARRAY OF INTEGER; VAR n: INTEGER; x: INTEGER);
VAR 
  i: INTEGER;
BEGIN
  i := Low(a);
  WHILE (i <= n) DO BEGIN
    IF (isMultipleOf(a[i], x)) THEN BEGIN
      removeElement(a, n, i);
    END
    ELSE BEGIN
      Inc(i);
    END;
  END;
  
END;

{ 
  just for printing shrikned array 
}
PROCEDURE printArray(a: ARRAY OF INTEGER; n: INTEGER);
VAR
  i: INTEGER;
BEGIN
  FOR i := Low(a) TO n DO BEGIN
    writeln(i, ': ', a[i]);
  END;
END;

VAR
  a: ARRAY[1..4] OF INTEGER;
  n: INTEGER;
BEGIN
  { is multiple of }
  writeln('is multiple of');
  Writeln('value=0, x=2: ', isMultipleOf(0, 2));
  Writeln('value=1, x=2: ', isMultipleOf(1, 2));
  Writeln('value=2, x=2: ', isMultipleOf(2, 2));
  Writeln('value=3, x=2: ', isMultipleOf(3, 2));
  Writeln('value=4, x=2: ', isMultipleOf(4, 2));
  
  { Remove idx }
  writeln();
  writeln('remove idx');
  a[1] := 1;
  a[2] := 3;
  a[3] := 4;
  a[4] := 6;
  n := High(a) - 1;
  removeElement(a, n, n);
  printArray(a, n);
  
  { Remove multiple of }
  writeln();
  writeln('remove multiple of');
  a[1] := 1;
  a[2] := 3;
  a[3] := 4;
  a[4] := 6;
  n := High(a) - 1;
  RemoveMultipleOfX(a, n, 10);
  printArray(a, n);
END.