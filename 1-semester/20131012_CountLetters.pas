PROGRAM CountLetters;

{
  Defintion of new datatype
}
TYPE
  CountsArray = ARRAY [CHAR] OF BYTE;

PROCEDURE countLettersInString(s: STRING; VAR counts: CountsArray);
VAR
  c: CHAR;
  i: BYTE;
BEGIN
  { 
    Set initial state of returned array in case string is empty
  }
  FOR c := Low(CHAR) TO High(CHAR) DO
    counts[c] := 0;

  IF Length(s) > 0 THEN
    FOR i := 1 TO Length(s) DO
      (* counts[s[i]] := counts[s[i]] + 1; *)
      Inc(counts[s[i]]);
END;

VAR 
  res: CountsArray;
  s: STRING;
  b: BYTE;
BEGIN
  s := 'Hallo olla';
  countLettersInString(s, res);
  
  FOR b := 1 TO Length(s) DO
    WriteLn(res[s[b]]);
END.
