Unit RegexUtils;

// ############################################ Interface part ############################################
Interface

Uses
	IntegerUtils, StringUtils;
Type
	{ The predefined error codes }
	Error = (NONE, INVALID_CHARACTER, INVALID_COUNT, INVALID_PATTERN);

{
	Creates a regex for irgnore. E.g.: 'AB...CD'
	
	@param		
		prefix: the prefix which prefixes the regex
	@param	
		postfix: the postfix postfixes the regex 
	@param
		count: the count of regex to be added
	@return
		the created regex
	@return	
		result: the result of this procedure invocation
		INVALID_CHARACTER: If the prefix and/or postfix contains predefined regex characters
		INVALID_COUNT: If the count < 0
}
Function CreateIgnoreRegex(prefix, postfix: String; count: Integer; Var result: Error): String;

{
	Creates a regex for a character set. E.g.: 'AB[abcde]CD'
	
	@param		
		prefix: the prefix which prefixes the regex
	@param	
		postfix: the postfix postfixes the regex 
	@param
		characters: the character t be contained in the character set
	@return
		the created regex
	@return	
		result: the result of this procedure invocation
		INVALID_CHARACTER: If the prefix and/or postfix contains predefined regex characters, or the given characters are empty
		INVALID_COUNT: If the count < 0
}
Function CreateCharacterSetRegex(prefix, characters, postfix: String; Var result: Error): String;

{
	Creates a regex for a character range. E.g.: 'AB[a-b]CD'
	
	@param		
		prefix: the prefix which prefixes the regex
	@param	
		postfix: the postfix postfixes the regex 
	@param
		lowerRange: the char representing the lower range
	@param
		higherRange: the char representing the higher range
	@return
		the created regex
	@return	
		result: the result of this procedure invocation
		INVALID_CHARACTER: If the prefix and/or postfix contains predefined regex characters, 
						   or the given characters ordinal values overflow each other
						   or the given character represent predfined regex characters
		INVALID_COUNT: If the count < 0
}
Function CreateCharacterRangeRegex(prefix, postfix: String; lowerRange, higherRange: Char; Var result: Error): String;

{
	Creates a regex for negation. E.g.: 'AB^CD'
	
	@param		
		prefix: the prefix which prefixes the regex
	@param	
		postfix: the postfix postfixes the regex 
	@return
		the created regex
	@return	
		result: the result of this procedure invocation
		INVALID_CHARACTER: If the prefix and/or postfix contains predefined regex characters,
							or if postfix is an empty string
		INVALID_COUNT: If the count < 0
}
Function CreateNegationRegex(prefix, postfix: String; Var result: Error): String;

{
	Creates a regex for a negation character set. E.g.: 'AB^[abcde]CD'
	
	@param		
		prefix: the prefix which prefixes the regex
	@param	
		postfix: the postfix postfixes the regex 
	@param
		characters: the character t be contained in the character set
	@return
		the created regex
	@return	
		result: the result of this procedure invocation
		INVALID_CHARACTER: If the prefix and/or postfix contains predefined regex characters, or the given characters are empty
		INVALID_COUNT: If the count < 0
}
Function CreateNegationCharacterSetRegex(prefix, characters, postfix: String; Var result: Error): String;

{
	Creates a regex for a negation character range. E.g.: 'AB^[a-b]CD'
	
	@param		
		prefix: the prefix which prefixes the regex
	@param	
		postfix: the postfix postfixes the regex 
	@param
		lowerRange: the char representing the lower range
	@param
		higherRange: the char representing the higher range
	@return
		the created regex
	@return	
		result: the result of this procedure invocation
		INVALID_CHARACTER: If the prefix and/or postfix contains predefined regex characters, 
						   or the given characters ordinal values overflow each other
						   or the given character represent predfined regex characters
		INVALID_COUNT: If the count < 0
}
Function CreateNegationCharacterRangeRegex(prefix, postfix: String; lowerRange, higherRange: Char; Var result: Error): String;

{
	Answers the question if the given pattern is contained in the given text, 
	where the pattern is allowed to contain regular expressions.
	
	@param
		text: the text to searched
	@param
		pattern: the pattern ot be searched in the text
	@return
		the position of the contained text, 0 if not found or if invalid pattern.
}
Function Matches(text, pattern: String): Integer;
// ############################################ Interface part ############################################

// ############################################ Just for testing ############################################
Function IsValidString(text: String): Boolean;
Function IsValidPattern(pattern: String): Boolean;
// ############################################ Just for testing ############################################

// ############################################ Implementation part ############################################
Implementation

Type	
	{ The predefined regex types }
	RegexType = (IGNORE, CHARACTER_SET, CHARACTER_RANGE, NEGATION);
	
Const
	{ the predefined regex characters }
	supportedRegex: Array [RegexType] of String = (
		('.'), 
		('[]'),
		('-'),
		('^')
	);

// ############################################ Private part ############################################
{
	Validates if the given text contains any predefined regex characters which is not allowed.
	
	@param	
		text: the text which gets validated
	@return	
		true if the text is valid false otherwise
}
Function IsValidString(text: String): Boolean;
Var	
	i, j, pLength, rLength: Integer;
	rType: RegexType;
	valid: Boolean;
	regex: String;
Begin
	i := 1;
	valid := true;
	pLength := Length(text);
	// Iterator over all characters of the text
	while (i <= pLength) and (valid) do begin
		for rType in RegexType do begin
			regex := supportedRegex[rType];
			rLength := Length(regex);
			j := 1;
			// Iterate over all regex predefined characters
			while (j <= rLength) and (valid) do begin
				valid := text[i] <> regex[j];
				Inc(j);
			end;
			// Break if valid, used because index overflow not possible with enumeration
			if (not valid) then begin
				Break;
			end;			
		end;
		Inc(i);
	end;
	IsValidString := valid;
End;

{
	Creates a single valued regex for the given regex type.
	
	@param	
		prefix: the prefix which prefixes the regex
	@param	
		prefix: the postfix which postfixes the regex
	@param	
		count: the count how often the regex shall be added
	@return	
		the created regex string
	@return	
		result: the result of this procedure invocation
		INVALID_CHARACTER: If the prefix and/or postfix contains regex characters
		INVALID_COUNT: If the count <= 0
}
Function CreateSingleValueRegex(prefix, postfix: String; count: Integer; rType: RegexType; Var result: Error): String;
Var	
	regex: String;
	i: Integer;
Begin
	CreateSingleValueRegex := '';
	result := Error.NONE;
	// Validate if pattern contains already regex characters
	if (NOT IsValidString(prefix)) or (NOT IsValidString(postfix)) then begin
		result := Error.INVALID_CHARACTER;
	end
	// Validate given count
	else if (count <= 0) then begin
		result := Error.INVALID_COUNT;
	end
	// Otherwise create regex string
	else begin
		regex := prefix;
		for i := 1 to count do begin
			regex := regex + supportedRegex[rType];
		end;
		CreateSingleValueRegex := regex + postfix;
	end;
End;

{
	Validates the given pattern if it contains a valid regex which can be handled by the matches function.
	
	@param	
		pattern: the pattern which shall be validated
	@return		
		true if the pattern is valid, false otherwise
}
Function IsValidPattern(pattern: String): Boolean;
Var	
	pos, pos1, pos2: Integer;
	split, tempPattern: String;
	valid: Boolean;
Begin
	pos := 0;
	pos1 := 0;
	pos2 := 0;
	valid := true;
	tempPattern := pattern;
	
	// Validate contained multiple regex
	pos1 := StringUtils.PatternPosition(tempPattern, supportedRegex[CHARACTER_SET][1]);
	pos2 := StringUtils.PatternPosition(tempPattern, supportedRegex[CHARACTER_SET][2]);		
	// Validate if ready to check for valid multiple regex
	while (valid) and ((pos1 <> 0) or (pos2 <> 0)) do begin
		{ writeln('tempPattern: ':15, tempPattern); }
		if (pos1 <> 0) and (pos2 <> 0) and (pos2 > (pos1 + 1)) then begin
			split := StringUtils.Split(tempPattern, pos1 + 1, pos2 - 1);
		    { writeln('split string: ':15, split);}
			if (StringUtils.Contains(split, supportedRegex[IGNORE], false)) // multiple select contains single regex
				or (StringUtils.Contains(split, supportedRegex[NEGATION], false)) // no negation within braces
					or (StringUtils.Contains(split, supportedRegex[CHARACTER_SET][1], false)) // no additional left brace embedded
						or (StringUtils.Contains(split, supportedRegex[CHARACTER_SET][2], false)) then begin // no additional right brace embedded
						valid := false;
			end
			// Check for range regex
			else if (valid) then begin
				pos := StringUtils.PatternPosition(split, supportedRegex[CHARACTER_RANGE]);
				if (pos <> 0) then begin
					if (Length(split) <> 3) or (split[2] <> supportedRegex[CHARACTER_RANGE]) 
						or (not IntegerUtils.IsValidRange(Ord(split[1]), Ord(split[3]))) 
							or (split[1] = supportedRegex[CHARACTER_RANGE]) 
								or (split[3] = supportedRegex[CHARACTER_RANGE]) then begin 
									valid := false;
					end;
				end;
				tempPattern := StringUtils.Split(tempPattern, pos2 + 1, Length(tempPattern));
				pos1 := StringUtils.PatternPosition(tempPattern, supportedRegex[CHARACTER_SET][1]);
				pos2 := StringUtils.PatternPosition(tempPattern, supportedRegex[CHARACTER_SET][2]);
			end;
		end
		// Invalid multiple regex
		else begin
			valid :=  false;
		end;
		tempPattern := StringUtils.Split(tempPattern, pos2 + 1, Length(tempPattern));
		pos1 := StringUtils.PatternPosition(tempPattern, supportedRegex[CHARACTER_SET][1]);
		pos2 := StringUtils.PatternPosition(tempPattern, supportedRegex[CHARACTER_SET][2]);
	end;
	
	// Validate single regex which can not be invalid positioned in multiple regex at this point
	tempPattern := pattern;
	pos := StringUtils.PatternPosition(tempPattern, supportedRegex[IGNORE]);
	while (valid) and (pos <> 0) do begin
		if (pos > 1) and (tempPattern[pos - 1] = supportedRegex[NEGATION]) then begin
			valid := false;
		end;
		tempPattern := StringUtils.Split(tempPattern, pos + 1, Length(tempPattern));
		pos := StringUtils.PatternPosition(tempPattern, supportedRegex[IGNORE]);
	end;
	
	// Validate negation regex if it stands alone
	tempPattern := pattern;
	pos := StringUtils.PatternPosition(tempPattern, supportedRegex[NEGATION]);
	while (valid) and (pos <> 0) do begin
		{ writeln('split: ', tempPattern); }
		if (pos = Length(tempPattern))
			or (pos < Length(tempPattern)) and (tempPattern[pos + 1] = supportedRegex[NEGATION]) then begin
				valid := false;
		end;
		tempPattern := StringUtils.Split(tempPattern, pos + 1, Length(tempPattern));
		pos := StringUtils.PatternPosition(tempPattern, supportedRegex[NEGATION]);
	end;
	
	IsValidPattern := valid;
End;
// ############################################ Private part ############################################

// ############################################ Public part ############################################
{ CreateIgnoreRegex }
Function CreateIgnoreRegex(prefix, postfix: String; count: Integer; Var result: Error): String;
Begin
	CreateIgnoreRegex := CreateSingleValueRegex(prefix, postfix, count, IGNORE, result);
End;

{ CreateCharacterSetRegex }
Function CreateCharacterSetRegex(prefix, characters, postfix: String; Var result: Error): String;
Begin
	CreateCharacterSetRegex := '';
	result := Error.NONE;
	// Validate if pattern contains already regex characters
	if (NOT IsValidString(prefix)) or (NOT IsValidString(postfix) or (NOT IsValidString(characters)) OR (Length(characters) = 0)) then begin
		result := Error.INVALID_CHARACTER;
	end
	// Otherwise create regex string
	else begin
		CreateCharacterSetRegex := prefix + supportedRegex[CHARACTER_SET][1] + characters + supportedRegex[CHARACTER_SET][2] + postfix;
	end;
End;

{ CreateCharacterRangeRegex }
Function CreateCharacterRangeRegex(prefix, postfix: String; lowerRange, higherRange: Char; Var result: Error): String;
Begin
	CreateCharacterRangeRegex := '';
	result := Error.NONE;
	// Validate if pattern contains already regex characters
	if (NOT IsValidString(prefix)) or (NOT IsValidString(postfix)) or (NOT IsValidString(lowerRange + higherRange)) or (Ord(lowerRange) > Ord(higherRange)) then begin
		result := Error.INVALID_CHARACTER;
	end
	// Otherwise create regex string
	else begin
		CreateCharacterRangeRegex := prefix + supportedRegex[CHARACTER_SET][1] + lowerRange + supportedRegex[CHARACTER_RANGE] + higherRange + supportedRegex[CHARACTER_SET][2] + postfix;
	end;
End;

{ CreateNegationRegex }
Function CreateNegationRegex(prefix, postfix: String; Var result: Error): String;
Begin
	CreateNegationRegex := '';
	result := Error.NONE;
	// Validate if pattern contains already regex characters
	if (NOT IsValidString(prefix)) or (NOT IsValidString(postfix)) or (Length(postfix) = 0) then begin
		result := Error.INVALID_CHARACTER;
	end
	// Otherwise create regex string
	else begin
		CreateNegationRegex := CreateSingleValueRegex(prefix, postfix, 1, NEGATION, result);
	end;
End;

{ CreateNegationCharacterSetRegex }
Function CreateNegationCharacterSetRegex(prefix, characters, postfix: String; Var result: Error): String;
Begin
	CreateNegationCharacterSetRegex := '';
	result := Error.NONE;
	// Validate if pattern contains already regex characters
	if (NOT IsValidString(prefix)) or (NOT IsValidString(postfix) or (NOT IsValidString(characters)) OR (Length(characters) = 0)) then begin
		result := Error.INVALID_CHARACTER;
	end
	// Otherwise create regex string
	else begin
		CreateNegationCharacterSetRegex := prefix + supportedRegex[NEGATION] + supportedRegex[CHARACTER_SET][1] + characters + supportedRegex[CHARACTER_SET][2] + postfix;
	end;
End;

{ CreateNegationCharacterRangeRegex }
Function CreateNegationCharacterRangeRegex(prefix, postfix: String; lowerRange, higherRange: Char; Var result: Error): String;
Begin
	CreateNegationCharacterRangeRegex := '';
	result := Error.NONE;
	// Validate if pattern contains already regex characters
	if (NOT IsValidString(prefix)) or (NOT IsValidString(postfix)) or (Ord(lowerRange) > Ord(higherRange)) then begin
		result := Error.INVALID_CHARACTER;
	end
	// Otherwise create regex string
	else begin
		CreateNegationCharacterRangeRegex := prefix + supportedRegex[NEGATION] + supportedRegex[CHARACTER_SET][1] + lowerRange + supportedRegex[CHARACTER_RANGE] + higherRange + supportedRegex[CHARACTER_SET][2] + postfix;
	end;
End;

{ Matches }
Function Matches(text, pattern: String): Integer;
Var
  textLength, patternLength, partLength, i ,j, k, idx, pos:Integer;
  textPart, part, patternBuf: String;
  negate, run: Boolean;
Begin
	Matches := 0;
	if (IsValidPattern(pattern)) then begin
		textLength := Length(text);
		patternLength := Length(pattern);
		pos := 0;
		i := 1;
		// Iterate over string to last possible position 
		while (pos = 0) and (i <= textLength) do begin
			j:= 1;
			idx := 1;
			run := true;
			{* writeln; *}
			{* writeln('j: ', j, ' - i: ', i); *}
			// Iterate over pattern an check for match
			while (run) and (j <= patternLength) and ((i + idx - 1) <= textLength) do begin 
				textPart := text[i + idx - 1];
				negate := false;
				// Ignore when single regex
				if (pattern[j] = supportedRegex[IGNORE]) then begin
					Inc(j);
				end
				else begin
					// Negation
					if (pattern[j] = supportedRegex[NEGATION]) then begin
						negate := true;
						{* writeln('negate':15); *}
						if (pattern[j + 1] = supportedRegex[CHARACTER_SET][1]) then begin	
							Inc(j);
							{* writeln('increased because of negated range'); *}
						end;
					end;
					// Check if multiple regex
					if (pattern[j] = supportedRegex[CHARACTER_SET][1]) then begin			
						// Need to cut the already handled parts because StringUtils.PatternPosition will always return the first occurance 
						// which would be the wrong one if contained multiple times
				        patternBuf := StringUtils.split(pattern, j, Length(pattern));
						part := StringUtils.split(pattern, j + 1, StringUtils.PatternPosition(patternBuf, supportedRegex[CHARACTER_SET][2]) + j - 2);
						partLength := Length(part);
						// Range
						if (part[2] = supportedRegex[CHARACTER_RANGE]) then begin
							if ((not negate) and (not StringUtils.IsWithinOrdinalRange(part[1], part[3], textPart[1]))) 
								or ((negate) and (StringUtils.IsWithinOrdinalRange(part[1], part[3], textPart[1])))  then begin
								run := false;
								{* writeln('negate: ':15, negate);
								writeln('text char: ':15, textPart[1]);
								writeln('pattern char: ':15, part[1]);
								writeln('pattern char: ':15, part[3]); *}
							end;
						end
						// No Range
						else begin
							writeln('text char: ':15, textPart);
							k := 1;
							while (k <= partLength) and (part[k] <> textPart) do begin
								{* writeln('part char: ':15, textPart); *}
								Inc(k);
							end;
							if ((not negate) and (k > partLength)) 
								or ((negate) and (k <= partLength)) then begin
								run := false;
							end;
						end;
						if (run) then begin
							j := j + partLength + Length(supportedRegex[CHARACTER_SET]);
						end;
					end
					else begin 
						// Compare character under consideration of negation
						run := ((negate) and (pattern[j + 1] <> textPart));
						if (run) then begin
							j := j + 2;
						end					
						else begin 
							run := ((not negate) and (pattern[j] = textPart));
							if (run) then begin	
								Inc(j);
							end;
						end;
					end;
				end;
				Inc(idx);
				// Cut out the already handled pattern parts
			end;
			// run still set and j overflows patternLength then we found the pattern
			if (run) and (j > patternLength) then begin
				pos := i;
				{* writeln('found when j: ', j); *}
			end
			// No need to increase i when match has been found
			else begin
				Inc(i);
			end;
		end;
		
		Matches := pos;
	end;
End;
// ############################################ Public part ############################################
// ############################################ Implementation part ############################################

Begin
End.