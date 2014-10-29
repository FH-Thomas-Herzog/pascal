Program RegexUtilsTest;

Uses
  RegexUtils, PrintUtils, Crt;

Const
  headerLength = 40;
{
	Tests the internal validation method which validates if a given string
	which has benn passed to a regex generating method is a valid one,
	means that this string does not contain any regex specifc characters.
}
Procedure TestIsValidString;
Var
  v: String;
Begin
  PrintUtils.PrintHeader('Test IsValidString (Private)', headerLength);
  v := 'AB.CD';
  writeln(v, ' -> ':15, RegexUtils.IsValidString(v));
  v := 'AB^CD';
  writeln(v, ' -> ':15, RegexUtils.IsValidString(v));
  v := 'AB[CD';
  writeln(v, ' -> ':15, RegexUtils.IsValidString(v));  
  v := 'AB]CD';
  writeln(v, ' -> ':15, RegexUtils.IsValidString(v));  
  v := 'AB-CD';
  writeln(v, ' -> ':15, RegexUtils.IsValidString(v));
  v := 'ABCD';
  writeln(v, ' -> ':15, RegexUtils.IsValidString(v));
End;

{
	Tests the CreateIgnoreRegex prozedure which creates a pattern which cotnains 
	regex to be able to ignore characters on specific positions in the pattern 
}
Procedure TestCreateIgnoreRegex;
Var 
	pre, pos, regex: String;
	result: Error;
Begin
	// invalid character on prefix
	PrintUtils.PrintHeader('invalid character on prefix', headerLength);
	pre := 'PR.E';
	pos := 'SUF';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	regex := RegexUtils.CreateIgnoreRegex(pre, pos, 0, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// invalid character on suffix
	PrintUtils.PrintHeader('invalid character on suffix', headerLength);
	pre := 'PRE';
	pos := 'PO.S';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	regex := RegexUtils.CreateIgnoreRegex(pre, pos, 0, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Invalid count
	PrintUtils.PrintHeader('Invalid count', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	regex := RegexUtils.CreateIgnoreRegex(pre, pos, 0, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// 1 time
	PrintUtils.PrintHeader('1 time', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	regex := RegexUtils.CreateIgnoreRegex(pre, pos, 1, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// 5 times
	PrintUtils.PrintHeader('5 times', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	regex := RegexUtils.CreateIgnoreRegex(pre, pos, 5, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// 1 time no prefix
	PrintUtils.PrintHeader('1 times no prefix', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	regex := RegexUtils.CreateIgnoreRegex('', pos, 1, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// 1 time no suffix
	PrintUtils.PrintHeader('1 times no suffix', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	regex := RegexUtils.CreateIgnoreRegex(pre, '', 1, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// 1 time no pre and suffix
	PrintUtils.PrintHeader('1 times no pre- and suffix', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	regex := RegexUtils.CreateIgnoreRegex('', '', 1, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);
End;

{
	Tests the procedure CreateNegationRegex which creates a pattern which cotnains 
	´a regex which allows to negate the following character.
}
Procedure TestCreateNegationRegex;
Var 
	pre, pos, regex: String;
	result: Error;
Begin	
	// Invalid character on prefix
	PrintUtils.PrintHeader('invalid character on prefix', headerLength);
	pre := 'PR.E';
	pos := 'SUF';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	regex := RegexUtils.CreateNegationRegex(pre, pos, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Invalid character on suffix
	PrintUtils.PrintHeader('invalid character on suffix', headerLength);
	pre := 'PRE';
	pos := 'PO.S';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	regex := RegexUtils.CreateNegationRegex(pre, pos, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);
	
	// Invalid no suffix
	pre := 'PRE';
	pos := ''; 
	PrintUtils.PrintHeader('Invalid no suffix', headerLength);
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	regex := RegexUtils.CreateNegationRegex(pre, '', result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Valid perfix and suffix
	pre := 'PRE';
	pos := 'SUF'; 
	PrintUtils.PrintHeader('Valid prefix and suffix', headerLength);
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	regex := RegexUtils.CreateNegationRegex(pre, pos, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);
	
	// No prefix 
	pre := '';
	pos := 'SUF';
	PrintUtils.PrintHeader('Valid no prefix', headerLength);
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	regex := RegexUtils.CreateNegationRegex(pre, pos, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);
End;

{
	Tests teh procedure CreateCharacterSetRegex which creates a pattern which allows to specify 
	a set of characters which are allowed on the specified position.
}
Procedure TestCreateCharacterSetRegex;
Var 
	pre, pos, characters, regex: String;
	result: Error;
Begin  
	// invalid character on prefix
	PrintUtils.PrintHeader('Invalid character on prefix', headerLength);
	pre := 'PR.E';
	pos := 'SUF';
	characters := 'absce';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('characters: ':20, characters);
	regex := RegexUtils.CreateCharacterSetRegex(pre, characters, pos, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// invalid character on suffix
	PrintUtils.PrintHeader('Invalid character on suffix', headerLength);
	pre := 'PRE';
	pos := 'SU.F  ';
	characters := 'absce';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('characters: ':20, characters);
	regex := RegexUtils.CreateCharacterSetRegex(pre, characters, pos, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// invalid character on suffix
	PrintUtils.PrintHeader('Invalid character on characters', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	characters := 'abs.ce';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('characters: ':20, characters);
	regex := RegexUtils.CreateCharacterSetRegex(pre, characters, pos, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Empty characters
	PrintUtils.PrintHeader('Empty characters', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	characters := '';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('characters: ':20, characters);
	regex := RegexUtils.CreateCharacterSetRegex(pre, characters, pos, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Valid
	PrintUtils.PrintHeader('Valid', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	characters := 'absce';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('characters: ':20, characters);
	regex := RegexUtils.CreateCharacterSetRegex(pre, characters, pos, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);
End;

{
	Tests the procedure CreateCharacterSetRangeRegex which creates a regex
	which specifies a ordinal range the following character must fit.
}
Procedure TestCreateCharacterRangeRegex;
Var 
	pre, pos, regex: String;
	lower, higher: Char;
	result: Error;
Begin  
	// Invalid character on prefix
	PrintUtils.PrintHeader('Invalid character on prefix', headerLength);
	pre := 'PR.E';
	pos := 'SUF';
	lower := 'a';
	higher := 'c';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('lower: ':20, lower);
	writeln('higher: ':20, higher);
	regex := RegexUtils.CreateCharacterRangeRegex(pre, pos, lower, higher, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Invalid character on suffix
	PrintUtils.PrintHeader('Invalid character on suffix', headerLength);
	pre := 'PRE';
	pos := 'PO.S';
	lower := 'a';
	higher := 'c';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('lower: ':20, lower);
	writeln('higher: ':20, higher);
	regex := RegexUtils.CreateCharacterRangeRegex(pre, pos, lower, higher, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Invalid character on range left
	PrintUtils.PrintHeader('Invalid character on range left', headerLength);
	pre := 'PRE';
	pos := 'POS';
	lower := '.';
	higher := 'c';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('lower: ':20, lower);
	writeln('higher: ':20, higher);
	regex := RegexUtils.CreateCharacterRangeRegex(pre, pos, lower, higher, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Invalid character on range right
	PrintUtils.PrintHeader('Invalid character on range right', headerLength);
	pre := 'PRE';
	pos := 'POS';
	lower := 'a';
	higher := '.';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('lower: ':20, lower);
	writeln('higher: ':20, higher);
	regex := RegexUtils.CreateCharacterRangeRegex(pre, pos, lower, higher, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Invalid ordinal order
	PrintUtils.PrintHeader('Invalid range ordinal', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	lower := 'c';
	higher := 'a';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('lower: ':20, lower);
	writeln('higher: ':20, higher);
	regex := RegexUtils.CreateCharacterRangeRegex(pre, pos, lower, higher, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Valid
	PrintUtils.PrintHeader('Valid', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	lower := 'a';
	higher := 'c';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('lower: ':20, lower);
	writeln('higher: ':20, higher);
	regex := RegexUtils.CreateCharacterRangeRegex(pre, pos, lower, higher, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);
End;

{
	Tests teh procedure CreateCharacterSetRegex which creates a pattern which allows to specify 
	a set of characters which are not allowed on the specified position.
}
Procedure TestCreateNegationCharacterSetRegex;
Var 
	pre, pos, characters, regex: String;
	result: Error;
Begin  
 	// invalid character on prefix
	PrintUtils.PrintHeader('Invalid character on prefix', headerLength);
	pre := 'PR.E';
	pos := 'SUF';
	characters := 'absce';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('characters: ':20, characters);
	regex := RegexUtils.CreateNegationCharacterSetRegex(pre, characters, pos, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// invalid character on suffix
	PrintUtils.PrintHeader('Invalid character on suffix', headerLength);
	pre := 'PRE';
	pos := 'SU.F  ';
	characters := 'absce';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('characters: ':20, characters);
	regex := RegexUtils.CreateNegationCharacterSetRegex(pre, characters, pos, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// invalid character on suffix
	PrintUtils.PrintHeader('Invalid character on characters', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	characters := 'abs.ce';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('characters: ':20, characters);
	regex := RegexUtils.CreateNegationCharacterSetRegex(pre, characters, pos, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Empty characters
	PrintUtils.PrintHeader('Empty characters', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	characters := '';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('characters: ':20, characters);
	regex := RegexUtils.CreateNegationCharacterSetRegex(pre, characters, pos, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Valid
	PrintUtils.PrintHeader('Valid', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	characters := 'absce';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('characters: ':20, characters);
	regex := RegexUtils.CreateNegationCharacterSetRegex(pre, characters, pos, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);
End;

{
	Tests the procedure CreateCharacterSetRangeRegex which creates a regex
	which specifies a ordinal range the following character must not fit.
}
Procedure TestCreateNegationCharacterRangeRegex;
Var 
	pre, pos, regex: String;
	lower, higher: Char;
	result: Error;
Begin  
	// Invalid character on prefix
	PrintUtils.PrintHeader('Invalid character on prefix', headerLength);
	pre := 'PR.E';
	pos := 'SUF';
	lower := 'a';
	higher := 'c';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('lower: ':20, lower);
	writeln('higher: ':20, higher);
	regex := RegexUtils.CreateNegationCharacterRangeRegex(pre, pos, lower, higher, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Invalid character on suffix
	PrintUtils.PrintHeader('Invalid character on suffix', headerLength);
	pre := 'PRE';
	pos := 'PO.S';
	lower := 'a';
	higher := 'c';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('lower: ':20, lower);
	writeln('higher: ':20, higher);
	regex := RegexUtils.CreateNegationCharacterRangeRegex(pre, pos, lower, higher, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Invalid character on range left
	PrintUtils.PrintHeader('Invalid character on range left', headerLength);
	pre := 'PRE';
	pos := 'POS';
	lower := '.';
	higher := 'c';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('lower: ':20, lower);
	writeln('higher: ':20, higher);
	regex := RegexUtils.CreateNegationCharacterRangeRegex(pre, pos, lower, higher, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Invalid character on range right
	PrintUtils.PrintHeader('Invalid character on range right', headerLength);
	pre := 'PRE';
	pos := 'POS';
	lower := 'a';
	higher := '.';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('lower: ':20, lower);
	writeln('higher: ':20, higher);
	regex := RegexUtils.CreateNegationCharacterRangeRegex(pre, pos, lower, higher, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Invalid ordinal order
	PrintUtils.PrintHeader('Invalid range ordinal', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	lower := 'c';
	higher := 'a';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('lower: ':20, lower);
	writeln('higher: ':20, higher);
	regex := RegexUtils.CreateNegationCharacterRangeRegex(pre, pos, lower, higher, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);

	// Valid
	PrintUtils.PrintHeader('Valid', headerLength);
	pre := 'PRE';
	pos := 'SUF';
	lower := 'a';
	higher := 'c';
	writeln('Prefix: ':20, pre);
	writeln('Suffix: ':20, pos);
	writeln('lower: ':20, lower);
	writeln('higher: ':20, higher);
	regex := RegexUtils.CreateNegationCharacterRangeRegex(pre, pos, lower, higher, result);
	writeln('generated regex -> ':20, regex);
	writeln('procedure result -> ':20, result);
End;

{
	Tests the function IsValidPattern which validates the given pattern is it 
	contains only valid regular expressions
}
Procedure TestIsValidPattern;
Var
	result: Boolean;
	pattern: String;
Begin
	PrintUtils.PrintHeader('1.', headerLength);
	pattern := 'Hagenberg^';
	result := RegexUtils.IsValidPattern(pattern);
	writeln('pattern -> ':20, pattern);
	writeln('result -> ':20, result);
	
	PrintUtils.PrintHeader('2.', headerLength);
	pattern := 'Hag^.enberg';
	result := RegexUtils.IsValidPattern(pattern);
	writeln('pattern -> ':20, pattern);
	writeln('result -> ':20, result);
	
	PrintUtils.PrintHeader('3.', headerLength);
	pattern := 'Hag[abcd.]enberg';
	result := RegexUtils.IsValidPattern(pattern);
	writeln('pattern -> ':20, pattern);
	writeln('result -> ':20, result);
	
	PrintUtils.PrintHeader('4.', headerLength);
	pattern := 'Hag[aa-b]enberg';
	result := RegexUtils.IsValidPattern(pattern);
	writeln('pattern -> ':20, pattern);
	writeln('result -> ':20, result);
	
	PrintUtils.PrintHeader('5.', headerLength);
	pattern := 'Hag[a-aa]enberg';
	result := RegexUtils.IsValidPattern(pattern);
	writeln('pattern -> ':20, pattern);
	writeln('result -> ':20, result);
	
	PrintUtils.PrintHeader('6.', headerLength);
	pattern := 'Hag[a-.]enberg';
	result := RegexUtils.IsValidPattern(pattern);
	writeln('pattern -> ':20, pattern);
	writeln('result -> ':20, result);
	
	PrintUtils.PrintHeader('7.', headerLength);
	pattern := 'Hag]a-aa[enberg';
	result := RegexUtils.IsValidPattern(pattern);
	writeln('pattern -> ':20, pattern);
	writeln('result -> ':20, result);
	
	PrintUtils.PrintHeader('8.', headerLength);
	pattern := '^Ha.ga^[a-b]e.nb^e[abcde]rg';
	result := RegexUtils.IsValidPattern(pattern);
	writeln('pattern -> ':20, pattern);
	writeln('result -> ':20, result);
	
	PrintUtils.PrintHeader('8.', headerLength);
	pattern := 'Hagenberg';
	result := RegexUtils.IsValidPattern(pattern);
	writeln('pattern -> ':20, pattern);
	writeln('result -> ':20, result);
End;

Procedure TestMatches;
Var	
	text, pattern: String;
	pos: Integer;
	result: Error;
Begin
	text := 'Ich bin ein Hagenberger';
	
	// Invalid Pattern
	PrintUtils.PrintHeader('Invalid pattern', headerLength);
	pattern := 'Hagen^';
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// No regex invalid
	PrintUtils.PrintHeader('No regex invalid', headerLength);
	pattern := 'Bagen';
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// Ignore regex invalid
	PrintUtils.PrintHeader('Ignore regex invalid', headerLength);
	pattern := RegexUtils.CreateIgnoreRegex('Ha', 'gen', 1, result);
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// Negation regex invalid
	PrintUtils.PrintHeader('Negation regex invalid', headerLength);
	pattern := RegexUtils.CreateNegationRegex('Hagenb', 'erger', result);
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// Character sequence invalid
	PrintUtils.PrintHeader('Character sequence invalid', headerLength);
	pattern := RegexUtils.CreateCharacterSetRegex('Hagen', 'cdef', 'erger', result);
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// Character range invalid
	PrintUtils.PrintHeader('Character range invalid', headerLength);
	pattern := RegexUtils.CreateCharacterRangeRegex('Hagen',  'erger','c', 'f', result);
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// Character negated sequence invalid
	PrintUtils.PrintHeader('Character negated sequence invalid', headerLength);
	pattern := RegexUtils.CreateNegationCharacterSetRegex('Hagen', 'abe', 'erger', result);
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// Character negated range invalid
	PrintUtils.PrintHeader('Character negated range invalid', headerLength);
	pattern := RegexUtils.CreateNegationCharacterRangeRegex('Hagen',  'erger','a', 'f', result);
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// No regex valid
	PrintUtils.PrintHeader('No regex valid', headerLength);
	pattern := 'bin';
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// Ignore regex valid
	PrintUtils.PrintHeader('Ignore regex valid', headerLength);
	pattern := RegexUtils.CreateIgnoreRegex('Ha', 'en', 1, result);
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// Negation regex valid
	PrintUtils.PrintHeader('Negation regex valid', headerLength);
	pattern := RegexUtils.CreateNegationRegex('Hagenb', 'urger', result);
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// Character sequence valid
	PrintUtils.PrintHeader('Character sequence valid', headerLength);
	pattern := RegexUtils.CreateCharacterSetRegex('Hagen', 'abc', 'erger', result);
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// Character range valid
	PrintUtils.PrintHeader('Character range valid', headerLength);
	pattern := RegexUtils.CreateCharacterRangeRegex('Hagen',  'erger','a', 'f', result);
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// Character negated sequence valid
	PrintUtils.PrintHeader('Character negated sequence valid', headerLength);
	pattern := RegexUtils.CreateNegationCharacterSetRegex('Hagen', 'cde', 'erger', result);
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// Character negated range valid
	PrintUtils.PrintHeader('Character negated range valid', headerLength);
	pattern := RegexUtils.CreateNegationCharacterRangeRegex('Hagen',  'erger','d', 'f', result);
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
	
	// Multiple regex valid
	PrintUtils.PrintHeader('Character negated range valid', headerLength);
	pattern := RegexUtils.CreateIgnoreRegex('H', 'ge', 1, result)
			    + RegexUtils.CreateNegationRegex('', 'm', result)
				+ RegexUtils.CreateCharacterRangeRegex('', '', 'a', 'c', result)
				+ RegexUtils.CreateNegationCharacterRangeRegex('er',  'er','k', 'm', result);
	pattern := 'H.ge^m[a-c]er^[k-m]er';
	pos := RegexUtils.Matches(text, pattern);
	writeln('text: ':20, ' -> ', text);
	writeln('pattern: ':20, ' -> ', pattern);
	writeln('pos: ':20, ' -> ', pos);
End;

Begin
	PrintUtils.Print('Tests for function IsValidString', Green, White, headerLength);
	TestIsValidString;

	writeln;
	PrintUtils.Print('Tests for function CreateIgnoreRegex', Green, White);
	TestCreateIgnoreRegex;

	writeln;
	PrintUtils.Print('Tests for procedure CreateNegationRegex', Green, White);
	TestCreateNegationRegex;
	writeln;

	PrintUtils.Print('Tests for procedure CreateCharacterSetRegex', Green, White);
	TestCreateCharacterSetRegex;
	writeln;

	PrintUtils.Print('Tests for procedure CreateCharacterRangeRegex', Green, White);
	TestCreateCharacterRangeRegex;
	writeln;
  
	PrintUtils.Print('Tests for procedure CreateNegationCharacterSetRegex', Green, White);
	TestCreateNegationCharacterSetRegex;
	writeln;

	PrintUtils.Print('Tests for procedure CreateNegationCharacterRangeRegex', Green, White);
	TestCreateNegationCharacterRangeRegex;
	writeln;
 
	PrintUtils.Print('Tests for procedure IsValidPattern', Green, White);
	TestIsValidPattern;
	writeln;

	PrintUtils.Print('Tests for procedure Matches', Green, White);
	TestMatches;
	writeln;
	
End.