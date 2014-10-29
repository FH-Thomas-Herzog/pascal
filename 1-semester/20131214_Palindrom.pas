{
  Program which shows the function isPalindrom with an iterativ and recursive implementation.
}
PROGRAM Palindrom;

{
  Checks a string if it is a plaindrom, via an iterativ solution,
  
  @param
      s: the string to check if it is a palindrom
  @return
      true if it the string is a plaindrom, false otherwise
}
FUNCTION IsPalindromIT(s: STRING): BOOLEAN;
VAR
  i: INTEGER;
  result: BOOLEAN;
BEGIN
  result := true;
  i := 1;
  
  WHILE ((result) AND (i <= Length(s) DIV 2)) DO BEGIN
      result := s[i] = s[Length(s) - i + 1];
      Inc(i);
  END;
  
  IsPalindromIT := result;
END;

{
  Checks a string if it is a plaindrom, via an rekursive solution,
  
  @param
      s: the string to check if it is a palindrom
  @return
      true if it the string is a plaindrom, false otherwise
}
FUNCTION IsPalindrom(s: STRING): BOOLEAN;
BEGIN
  IF (Length(s) = 0) THEN BEGIN
    IsPalindrom := true;
  END
  ELSE IF (Length(s) = 1) THEN BEGIN
    IsPalindrom := true;
  END
  ELSE BEGIN
    IsPalindrom := (s[1] = s[Length(s)]) AND (IsPalindrom(Copy(s, 2, Length(s) -2))); 
  END;
END;

BEGIN
  WriteLn('Via iterativ solution ');
  WriteLn(IsPalindromIT(''));
  WriteLn(IsPalindromIT('a'));
  WriteLn(IsPalindromIT('anna'));
  WriteLn(IsPalindromIT('abba'));
  WriteLn(IsPalindromIT('axcxa'));
  WriteLn;
  
  WriteLn('Via recursive solution ');
  WriteLn(IsPalindrom(''));
  WriteLn(IsPalindrom('a'));
  WriteLn(IsPalindrom('anna'));
  WriteLn(IsPalindrom('abba'));
  WriteLn(IsPalindrom('axcxa'));
END.