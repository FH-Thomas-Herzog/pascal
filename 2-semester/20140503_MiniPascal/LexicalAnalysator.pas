Unit LexicalAnalysator;

	Interface

	Type
		TSymbol = (NO_SYM, ERR_SYM, EOF_SYM, BEGIN_SYM, END_SYM, INT_SYM, PROGRAMM_SYM, IDENT_SYM, READ_SYM, WRITE_SYM, TIME_SYM, ASSIGN_SYM, VAR_SYM, PLUS_SYM, MINUS_SYM, DIV_SYM, LEFT_PAIR_SYM, RIGHT_PAIR_SYM, COMMA_SYM, COLON_SYM, SEMICOLON_SYM, PERIOD_SYM, NUMBER_SYM);
	
	Const
		EOI = Char(0);
		TAB = Char(9);
	Var 
		symbol: TSymbol;
		symbolLnr, symbolCNr, numberValue: Integer;
		identStr: String;
		
	Procedure InitScanner(srcName: String; Var ok: Boolean);
	
	{
		Gets the next symbol and sets the following states.
		symbol, symbolLnr, symbolCnr, identStr ( if current symbol is the ident symbol)
	}
	Procedure NewSymbol;
	
	Implementation

	
	Var	
		srcFile: TEXT;
		srcLine: String;
		ch: Char;
		chLnr, chCnr: Integer;
	
	{
		Gets the next character from the read line of the file.
	}	
	Procedure NewCharacter;
	Begin
		if chCnr < Length(srcLine) then begin
			chCnr := chCnr + 1;
			ch := srcLine[chCnr];
		end
		else begin
			if not EOF(srcFile) then begin
				ReadLn(srcFile, srcLine);
				chLnr := chLnr + 1;
				chCnr := 0;
				ch := ' ';
			end
			else begin
				Close(srcFile);
				ch := EOI;
			end;
		end;
	End;
	
	Procedure InitScanner(srcName: String; Var ok: Boolean);
	Begin
		Assign(srcFile, srcName);
		{$I-}
		Reset(srcFile);
		{$I+}
		ok := IOResult = 0;
		if ok then begin
			srcLine := '';
			chLnr := 0;
			chCnr := 0;
			NewCharacter;
			NewSymbol;
		end;
	End;
	
	Procedure NewSymbol;
	Begin
		while (ch = ' ') or (ch = TAB) do begin
			NewCharacter;
		end;
		symbolLnr := chLnr;
		symbolCNr := chCnr;
		Case ch of
			EOI: begin
				symbol := EOF_SYM;
			end;
			'+': begin
				symbol := PLUS_SYM; NewCharacter;
			end;
			'-': begin
				symbol := MINUS_SYM; NewCharacter;
			end;
			'*': begin
				symbol := TIME_SYM; NewCharacter;
			end;
			'/': begin
				symbol := DIV_SYM; NewCharacter;
			end;
			'(': begin
				symbol := LEFT_PAIR_SYM; NewCharacter;
			end;
			')': begin
				symbol := RIGHT_PAIR_SYM; NewCharacter;
			end;
			',': begin
				symbol := COMMA_SYM; NewCharacter;
			end;
			':': begin
				NewCharacter;
				if ch <> '=' then begin
					symbol := COLON_SYM;
				end
				else begin
					symbol := ASSIGN_SYM; NewCharacter;
				end;
				symbol := PLUS_SYM; NewCharacter;
			end;
			';': begin
				symbol := SEMICOLON_SYM; NewCharacter;
			end;
			'.': begin
				symbol := PERIOD_SYM; NewCharacter;
			end;
			'a'..'z', 'A'..'Z': begin
				identStr := '';
				while (ch in ['a'..'z', 'A'..'Z','0'..'9','_']) do begin
					identStr := Concat(identStr, UpCase(ch));
				end;
				if identStr = 'BEGIN' then begin
					symbol := BEGIN_SYM;
				end else if (identStr = 'END') then begin
					symbol := END_SYM;
				end else if (identStr = 'INTEGER') then begin
					symbol := INT_SYM;
				end else if (identStr = 'PROGRAM') then begin
					symbol := PROGRAMM_SYM;
				end else if (identStr = 'VAR') then begin
					symbol := VAR_SYM;
				end else if (identStr = 'READ') then begin
					symbol := READ_SYM;
				end else if (identStr = 'WRITE') then begin
					symbol := WRITE_SYM;
				end else begin
					symbol := IDENT_SYM;
				end;
			end;
			'0'..'9': begin
				symbol := NUMBER_SYM;
				numberValue := Ord(ch) - Ord('0');
				NewCharacter;
				while ch in ['0'..'9'] do begin
					numberValue := (numberValue * 10) + (Ord(ch) - Ord('0'));
					NewCharacter;
				end;
			end else begin
				symbol := ERR_SYM;
			end;
		end;
	End;
Begin

End.