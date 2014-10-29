PROGRAM Datatypes;
(* VAR 
  x, i: INTEGER;
  y: CHAR;
  ar: ARRAY[5..8] OF BOOLEAN;
BEGIN
  WriteLn('Userfull predefined functions:');
  WriteLn();
  WriteLn('Low(INTEGER): ', Low(INTEGER));
  WriteLn('High(INTEGER): ', High(INTEGER));
  x := 4;
  WriteLn('Succ(x):', Succ(x));
  y := 'c';
  WriteLn('Pred(y): ', Pred(y));
  WriteLn('Pred("z"): ', Pred('z'));
  
  WriteLn();
  WriteLn('-------------------------');
  WriteLn();
  
  {* Array *}
  FOR i := Low(ar) TO High(ar) DO
    WriteLn('arr at i ', i , 'is ', ar[i]) 
END. *)


VAR 
  s: STRING;
BEGIN
  { Scalar usage }
  s := 'Hallo!';
  WriteLn(s);
  Write(s);
  Write(s);
  WriteLn();
  WriteLn();
  
  { Structured usage }  
  WriteLn(s);
  s[2] := 'x';
  WriteLn(s);
  WriteLn(s[7]);
  
  { 
    Add char after last index by manipulating 
    the length of the string at the first byte of the string. 
  }
  s[0] := Chr(Ord(s[0]) + 1);
  s[7] := 'e';
  WriteLn(s);

  {
    Set string with new value and set length manually to length 10.
    You see old value is still there. Just new value did overwrite 
    the first characters.
  }
  s := 'du';  
  s[0] := Chr(10);
  WriteLn(s);
  
  
  
END.