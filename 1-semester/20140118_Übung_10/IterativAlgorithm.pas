PROGRAM IterativeAlgorithm;

CONST
  Zero = 48;
  Nine = 57;

FUNCTION GetValue(numStr: STRING): LONGINT;
VAR
  i: INTEGER;
  asciiCode: BYTE;
  result: LONGINT;
BEGIN
  result := 0;
  i := 1;
  WHILE i <= Length(numStr) DO BEGIN
    asciiCode := Ord(numStr[i]);
    IF (asciiCode >= Zero) AND (asciiCode <= Nine) THEN
      result := result * 10 + asciiCode - Zero;
    i := i + 1;
  END;
  GetValue := result;
END;

BEGIN
  GetValue('ABC123');
END.