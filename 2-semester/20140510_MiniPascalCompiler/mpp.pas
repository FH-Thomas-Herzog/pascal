PROGRAM MPP;

USES
	MP_Lex, MPP_SS;
	
VAR
	srcName: STRING;
	ok: BOOLEAN;
	
BEGIN
	WriteLn('MPP: MiniPascal Interpreter');
	WHILE TRUE DO BEGIN
		WriteLn;
		Write('MiniPascal Source File (*.mp) > ');
		ReadLn(srcName);
		IF Length(srcName) = 0 THEN
			EXIT;
			
		InitScanner(srcName, ok);
		IF ok THEN
			S (* interpretation *)
		ELSE
			WriteLn('...File not found!');
	END;
END.