Unit StringUtils;

Interface

Uses
	IntegerUtils;
Type
	SkipArrayType = Array[Char] of Integer;
{
	Searches the given string if it is contains the given pattern.
	The case is considered.
	
	@param
		text: the text to be searched
	@param	
		pattern: the pattern to search in the text
	@return
		true if the text contains the given pattern.
}
Function Contains(text, pattern: String): Boolean; overload;

{
	Searches the given string if it is contains the given 
	pattern with the BoyerMoore algorithm.
	
	@param
		text: the text to be searched
	@param	
		pattern: the pattern to search in the text
	@param	
		ignoreCase: true if the case shall be ignored
	@return
		true if the text contains the given pattern.
}
Function Contains(text, pattern: String; ignoreCase:Boolean): Boolean; overload;

{
	Searches the given string if it is contains the given pattern.
	The case is considered.
	
	@param
		text: the text to be searched
	@param	
		pattern: the pattern to search in the text
	@return
		the position where the pattern has been found, 0 otherwise
}
Function PatternPosition(text, pattern: String): Integer; overload;

{
	Searches the given string if it is contains the given pattern.
	The case is considered.
	
	@param
		text: the text to be searched
	@param	
		pattern: the pattern to search in the text
	@param	
		ignoreCase: true if the case shall be ignored
	@return
		the position where the pattern has been found, 0 otherwise
}
Function PatternPosition(text, pattern: String; ignoreCase:Boolean): Integer; overload;

Function Split(text: String; startIdx, endIdx: Integer): String;

{
	Answers the question if the given char is within the given ordinal range of the both other chars
	
	@param	
		lowerChar: the char with the lower ordinal value
	@param	
		higherChar: the char witht he higher ordinal value
	@param	
		c: the char which has to be within the defined range
	@return
		true if lowerChar has a smaller rodinal value as the higherChar ordinal value, false otherwise
}
Function IsWithinOrdinalRange(lowerChar, higherChar, c: Char): Boolean;

Implementation

{
Initializes the skip table.
}
Function InitSkip(pattern: String): SkipArrayType;
Var
	ch: Char;
    pLength, j: Integer;  
Begin
    pLength := Length(pattern);
	// Fill array to avoid undefined values
	for ch := Low(CHAR) to High(CHAR) do begin
	  InitSkip[ch] := pLength;
	end;
	// set character position
	for j:= 1 to plength do begin
	  InitSkip[pattern[j]] := pLength - j;
	end;
End;
  
{ Contains }
Function Contains(text, pattern: String): Boolean; overload;
Begin
	Contains := Contains(text, pattern, false);
End;

Function Contains(text, pattern: String; ignoreCase:Boolean): Boolean; overload;
Var
  skip: SkipArrayType;
  sLength, pLength, i, j: Integer;    
Begin
  // If case should not be considered
  if (ignoreCase) then begin
	LowerCase(text);
	LowerCase(pattern);
  end;
  
  skip := InitSkip(pattern);
  sLength := Length(text);
  pLength := Length(pattern);
  i := pLength;
  j := pLength;
  
  repeat begin
    if (text[i] = pattern[j])then begin
      Dec(i);
      Dec(j);
    end 
    else begin
      i := i + skip[text[i]];
      j := pLength;
    end;
  end
  until (i > sLength) or (j < 1);
  
  if (j < 1) then begin
    Contains := true;
  end
  else begin
    Contains := false;
  end;
End;

Function PatternPosition(text, pattern: String): Integer; overload;
Begin
	PatternPosition := PatternPosition(text, pattern, false);
End;

Function PatternPosition(text, pattern: String; ignoreCase:Boolean): Integer; overload;
Var
  skip: SkipArrayType;
  sLength, pLength, i, j: Integer;    
Begin
  // If case should not be considered
  if (ignoreCase) then begin
	LowerCase(text);
	LowerCase(pattern);
  end;
  skip := InitSkip(pattern);
  sLength := Length(text);
  pLength := Length(pattern);
  i := pLength;
  j := pLength;
  
  repeat begin
    if (text[i] = pattern[j])then begin
      Dec(i);
      Dec(j);
    end 
    else if (pLength - j + 1) > (skip[text[i]]) then begin
      j := i + pLength - j + 1;
    end
	else begin		
      i := i + skip[text[i]];
	end;
  end
  until (i > sLength) or (j < 1);
  
  if (j < 1) then begin
    PatternPosition := i + 1;
  end
  else begin
    PatternPosition := 0;
  end;
End;

Function Split(text: String; startIdx, endIdx: Integer): String;
Var	
	s: String;
	i: Integer;
Begin
	s := '';
	// Validate range
	if (IsValidRange(startIdx, endIdx)) and (startIdx >= 1) and (endIdx <= Length(text)) then begin

		for i := startIdx to endIdx do begin
			s := s + text[i];
		end;
	end;
	
	Split := s;
End;

Function IsWithinOrdinalRange(lowerChar, higherChar, c: Char): Boolean;
Begin
	IsWithinOrdinalRange := (Ord(c) >= Ord(lowerChar)) and (Ord(c) <= Ord(higherChar));
End;

Begin
End.