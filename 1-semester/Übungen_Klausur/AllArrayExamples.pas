PROGRAM AllArrayExamples;

CONST
  n = 10;
TYPE
  IntArray = ARRAY[1..n] OF INTEGER;

// ################## Remove MultipleOfX ############################
FUNCTION IsMultipleOfX(value, x: INTEGER): BOOLEAN;
VAR
  fact, result: INTEGER;
BEGIN
  fact := 0;
  REPEAT BEGIN
    fact := fact + 1;
    result := x * fact;
  END
  UNTIL (result >= value);
  
  IsMultipleOfX := result = value;
END;

PROCEDURE RemoveMultipleOfX(VAR ar: ARRAY OF INTEGER; VAR size: Integer; value: INTEGER);
VAR
  i, j: INTEGER;
BEGIN
  // Size -1 because index range of open field is 0 - (size - 1)
  // Do no handle last element, no need for because no following ones
  i := 0;
  WHILE (i < (size - 1)) DO BEGIN
    IF (IsMultipleOfX(ar[i], value)) THEN BEGIN
      size := size - 1;
      FOR j := i TO size - 1 DO BEGIN
        ar[i] := ar[i + 1];
      END;
    END
  END
END;

BEGIN
END.