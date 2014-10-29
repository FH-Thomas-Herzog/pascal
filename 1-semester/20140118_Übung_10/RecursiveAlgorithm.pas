PROGRAM RecursiveAlgorithm;

CONST
  Zero = 48;
  Nine = 57;

FUNCTION GetValue2(numStr: STRING): LONGINT;
  FUNCTION GetValueInternal(pos: INTEGER): LONGINT;
  VAR
    asciiCode: BYTE;
  BEGIN
    IF pos < 1 THEN BEGIN
      writeln('recursion end');
      GetValueInternal := 0
    END
    ELSE BEGIN
      writeln('proceed');
      asciiCode := Ord(numStr[pos]);
      IF (asciiCode >= Zero) AND (asciiCode <= Nine) THEN BEGIN        
        writeln('number found');
        GetValueInternal := asciiCode - Zero + 10 * GetValueInternal(pos - 1)
      END
      ELSE BEGIN
        writeln('special character found');
        GetValueInternal := GetValueInternal(pos - 1);
      END;
    END;
  END;

BEGIN
  writeln('invoke');
  GetValue2 := GetValueInternal(Length(numStr));
END;

BEGIN
  GetValue2('123ABC');
END.