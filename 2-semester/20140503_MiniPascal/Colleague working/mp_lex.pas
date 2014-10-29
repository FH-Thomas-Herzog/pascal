UNIT MP_Lex;

INTERFACE

TYPE
	Symbol = (noSy, errSy, eofSy, beginSy, endSy, integerSy, 
			  programSy, readSy, varSy, writeSy, plusSy, minusSy, 
			  timesSy, divSy, leftParSy, rightParSy, commaSy, colonSy, 
			  assignSy, semicolonSy, periodSy, identSy, numberSy);

VAR
	sy: Symbol; (* current symbol *)
	syLnr, syCnr: INTEGER; (* starting position of current symbol *)
	identStr: STRING; (* string when symbol = identSy *)
	numberVal: INTEGER; (* value when symbol = numberSy *)
	
PROCEDURE initScanner(srcName: STRING; VAR ok: BOOLEAN);
PROCEDURE NewSy; (* updates sy, syLnr, syCnr and 
					when sy = identSy then identStr or 
					when sy = numberSy then numberVal *)
					
IMPLEMENTATION

CONST
	EF = Chr(0);
	TAB = Chr(9);

VAR
	srcFile: TEXT;
	srcLine: STRING;
	ch: CHAR; (* current character *)
	chLnr, chCnr: INTEGER; (* pos of current character *)

PROCEDURE NewCh;
BEGIN
	if chCnr < Length(srcLine) THEN BEGIN
		chCnr := chCnr + 1;
		ch := srcLine[chCnr];
	END ELSE BEGIN
		IF NOT EOF(srcFile) THEN BEGIN
			ReadLn(srcFile, srcLine);
			chLnr := chLnr + 1;
			chCnr := 0;
			ch := ' ';
		END ELSE BEGIN
			Close(srcFile);
			ch := EF;
		END;
	END;
END;
	
PROCEDURE initScanner(srcName: STRING; VAR ok: BOOLEAN);
BEGIN
	Assign(srcFile, srcName);
	{$I-}
		Reset(srcFile);	
	{$I+}
	ok := (IOResult = 0);
	
	IF ok THEN BEGIN
		srcLine := '';
		chLnr := 0;
		chCnr := 1;
		NewCh;
		NewSy;
	END;
END;

PROCEDURE NewSy;
BEGIN
	WHILE (ch = ' ') OR (ch = TAB) DO BEGIN
		NewCh;
	END;
	syLnr := chLnr;
	syCnr := chCnr;
	CASE ch OF
		EF: BEGIN
			sy := eofSy;
		END;
		'+': BEGIN
			sy := plusSy; NewCh;
		END;
		'-': BEGIN
			sy := minusSy; NewCh;
		END;
		'/': BEGIN
			sy := divSy; NewCh;
		END;
		'*': BEGIN
			sy := timesSy; NewCh;
		END;
		'(': BEGIN
			sy := leftParSy; NewCh;
		END;
		')': BEGIN
			sy := rightParSy; NewCh;
		END;
		',': BEGIN
			sy := commaSy; NewCh;
		END;
		':': BEGIN
			NewCh;
			IF ch <> '=' THEN
				sy := colonSy
			ELSE BEGIN
				sy := assignSy; NewCh;
			END;
		END;
		';': BEGIN
			sy := semicolonSy; NewCh;
		END;
		'.': BEGIN
			sy := periodSy; NewCh;
		END;
		'a'..'z', 'A'..'Z': BEGIN
			identStr := '';
			WHILE ch IN ['a'..'z', 'A'..'Z', '0'..'9', '_'] DO BEGIN
				identStr := Concat(identStr, UpCase(ch));
				NewCh;
			END;
			IF identStr = 'BEGIN' THEN
				sy := beginSy
			ELSE IF identStr ='END' THEN
				sy := endSy
			ELSE IF identStr ='INTEGER' THEN
				sy := integerSy
			ELSE IF identStr ='PROGRAM' THEN
				sy := programSy
			ELSE IF identStr ='READ' THEN
				sy := readSy
			ELSE IF identStr ='WRITE' THEN
				sy := writeSy
			ELSE IF identStr ='VAR' THEN
				sy := varSy
			ELSE
				sy := identSy;
		END;
		'0'..'9': BEGIN
			sy := numberSy;
			numberVal := Ord(ch) - Ord('0');
			NewCh;
			WHILE ch IN ['0'..'9'] DO BEGIN
				numberVal := ((numberVal * 10) * Ord(ch) - Ord('0'));
				NewCh;
			END;
		END;
		ELSE
			sy := errSy;
	END;
END;

BEGIN

END.