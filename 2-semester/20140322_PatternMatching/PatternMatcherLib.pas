Unit PatternMatcherLib;

// ################### Interface part ################### 
Interface

{
  Searches the pattern in the string with the brute force algorithm from left to right regarding the pattern.
  The implementation uses the variant with two while loops.
  
  @param
    s: the string to search the pattern  on
  @parma
    p: the pattern ot search in the string
  @return
    pos the position where the first character of the pattern has been found, 0 otherwise
}
Procedure BruteForceLR(s, p:String; Var pos: Integer);


{
  Searches the pattern in the string with the brute force algorithm from right to left regarding the pattern.
  The implementation uses the variant with two while loops.
  
  @param
    s: the string to search the pattern  on
  @parma
    p: the pattern ot search in the string
  @return
    pos the position where the first character of the pattern has been found, 0 otherwise
}
Procedure BruteForceRL(s, p:String; Var pos: Integer);

{
  This procedure searches for a pattern in the string with the knuth-morris-prattl alogrithm.
  
  @param
    s: the string to search the pattern  on
  @parma
    p: the pattern ot search in the string
  @return
    pos the position where the first character of the pattern has been found, 0 otherwise
}
Procedure KnuthMorrisPrattl(s, p:String; Var pos: Integer);

{
  This procedure searches for a pattern in the string with the knuth-morris-prattl alogrithm.
  
  @param
    s: the string to search the pattern  on
  @parma
    p: the pattern ot search in the string
  @return
    pos the position where the first character of the pattern has been found, 0 otherwise
}
Procedure KnuthMorrisPrattl2(s, p:String; Var pos: Integer);

{
  This procedure earches a pattern in a strin with the boyer-moore algorithm.  
  @param
    s: the string to search the pattern  on
  @parma
    p: the pattern ot search in the string
  @return
    pos the position where the first character of the pattern has been found, 0 otherwise
}
Procedure BoyerMoore(s, p:String; Var pos: Integer);

Procedure RabinKarp(s, p: String; Var pos:Integer);
// ################### Implementation part ################### 
Implementation

Const
  unitName = 'PatternMatcherLib';
  maxStrLength = 255;

// ################### Private part ################### 
Function Equals(c1, c2: Char): Boolean;
Begin
  Equals := (c1 = c2);
End;

// ################### Public part ################### 
Procedure BruteForceLR(s, p:String; Var pos: Integer);
Var
  sLength, pLength,i ,j:Integer;
Begin
  sLength := Length(s);
  pLength := Length(p);
  pos :=0;
  i := 1;
  // Iterate over string to last possible position 
  while (pos = 0) and ((i + pLength -1) <= sLength) do begin
    j:= 1;
    // Iterate over pattern an check for match
    while (j <= pLength) and (Equals(s[i+j-1], p[j])) do begin 
      Inc(j);
    end;
    // j overflows pattern length if match has been found
    if (j > pLength) then begin
      pos := i;
    end
    // No need to increase i when match fhas been found
    else begin
      Inc(i);
    end;
  end;
End;

Procedure BruteForceRL(s, p:String; Var pos: Integer);
Var
  sLength, pLength,i ,j:Integer;
Begin
  sLength := Length(s);
  pLength := Length(p);
  pos := 0;
  i := pLength;
  j := pLength;
  // Iterate over string
  repeat begin
    // If equal characcter go one left
    if Equals(s[i], p[j]) then begin 
      Dec(j);
      Dec(i);
    end
    // Otherwise calculate new indexes
    else begin
      i := i + pLength - j + 1;
      j := pLength;
    end;
  end
  until (i > sLength) or (j < 1);

  // When j overflows min length of string then we found it
  if (j < 1) then begin
    pos := i + 1;
  end
  // Otherwise no found
  else begin
    pos := 0;
  end;
End;

Procedure KnuthMorrisPrattl(s, p:String; Var pos: Integer);

Var
  next: Array[1..maxStrLength] of Integer;
  sLength, pLength, i, j:Integer;
  
  {
    Initializes the next array which holds the next available indexes.
  }
  Procedure InitNext;
  Var
    i, j:Integer;
    Begin
      i := 1;
      j := 0;
      next[1] := 0;
      
      while (i < pLength) do begin
        if (j = 0) OR (Equals(p[i], p[j])) then begin
          Inc(i);
          Inc(j);
          next[i] := j;
          writeln('i: ', i, '-',j);
        end
        else begin
          j := next[j];
        end;
      end;
    End;
    
Begin  
  sLength := Length(s);
  pLength :=Length(p);
  InitNext;
  i := 1;
  j := 1;
  repeat begin
    if (j = 0) or (Equals(s[i], p[j])) then begin
      Inc(i);
      Inc(j);
    end
    else begin
      j := next[j];
    end;
  end
  until (i > sLength) or (j > pLength);
 
  if (j > pLength) then begin
    pos := i - pLength;
  end
  else begin
    pos := 0;
  end;
End;

Procedure KnuthMorrisPrattl2(s, p:String; Var pos: Integer);

Var
  next: Array[1..maxStrLength] of Integer;
  sLength, pLength, i, j:Integer;
  
  {
    Initializes the next array which holds the next available indexes.
  }
  Procedure InitNextImproved;
  Var
    i, j:Integer;
    Begin
      i := 1;
      j := 0;
      next[1] := 0;
      
      while (i < pLength) do begin
        if (j = 0) OR (Equals(p[i], p[j])) then begin
          Inc(i);
          Inc(j);
          // next[i] := j;
          if (NOT Equals(p[i], p[j])) then begin
            next[i] := j;
          end
          else begin
            next[i] := next[j];
          end;
        end
        else begin
          j := next[j];
        end;
      end;
    End;
    
Begin  
  sLength := Length(s);
  pLength :=Length(p);
  InitNextImproved;
  i := 1;
  j := 1;
  repeat begin
    if (j = 0) or (Equals(s[i], p[j])) then begin
      Inc(i);
      Inc(j);
    end
    else begin
      j := next[j];
    end;
  end
  until (i > sLength) or (j > pLength);
 
  if (j > pLength) then begin
    pos := i - pLength;
  end
  else begin
    pos := 0;
  end;
End;


Procedure BoyerMoore(s, p:String; Var pos: Integer);
Var
  skip: Array[Char] of Integer;
  sLength, pLength, i, j: Integer;
  
  {
    Initializes the skip table.
  }
  Procedure InitSkip;
  Var
    ch: Char;
    j:Integer;
  Begin
    // Fill array to avoid undefined values
    for ch := Low(CHAR) to High(CHAR) do begin
      skip[ch] := pLength;
    end;
    // set character position
    for j:= 1 to plength do begin
      skip[p[j]] := pLength - j;
    end;
  End;    
Begin
  sLength := Length(s);
  pLength := Length(p);
  InitSkip;
  i := pLength;
  j := pLength;
  
  repeat begin
    if (Equals(s[i], p[j]))then begin
      Dec(i);
      Dec(j);
    end 
    else begin
      i := i + skip[s[i]];
      j := pLength;
    end;
  end
  until (i > sLength) or (j < 1);
  
  if (j < 1) then begin
    pos := i + 1;
  end
  else begin
    pos := 0;
  end;
End;

Procedure RabinKarp(s, p: String; Var pos:Integer);
Const
    q = 8355967;
    d = 256;    
Var
  hp: Longint;
  hs: LongInt;  
  dm: Longint;
  sLength, // string length
  pLength, // pattern length
  i, j, // indicies for s and p
  iMax, // highest index in s to be compared
  k: Integer;
Begin
  sLength := Length(s);
  pLength := Length(p);
  dm := 1;
  
  for i := 1 to pLength -1 do begin
    dm := (d * dm) mod q;
  end;
  
  hs := 0;
  hp := 0;
  
  for i := 1 to pLength do begin
    hp := (hp * d + Ord(p[i])) mod q;
    hs := (hs * d + Ord(s[i])) mod q;
  end;
  
  i := 1;
  iMax := sLength - pLength + 1;
  while true do begin
    if i > iMax then begin
      pos := 0;
      exit;
    end;
    
    if hp = hs then begin
      j := 1;
      k := i;
      
      while (j <= pLength) and (Equals(p[j], s[k])) do begin
        Inc(j);
        Inc(k);
      end;
      
      if j > pLength then begin
        pos := i;
        writeln('found match');
        Exit;
      end;
    end;
    
    hs := (hs + d * q - Ord(s[i]) * dm ) mod q;
    hs := (hs * d + Ord(s[i + pLength])) mod q;
    Inc(i);
  end;
End;

Begin
End.