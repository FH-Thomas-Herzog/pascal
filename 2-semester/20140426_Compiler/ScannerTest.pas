Program ScannerTest;

Uses 
	Scanner;
	
Var
	input: String;
	
Begin
	Write('->');
	ReadLn(input);
	while (input <> '') do begin
		InitScanner(input);
		while (GetCurrentSym <> END_SYM) and (GetCurrentSym <> NO_SYM) do begin
			GetNextSym;
		end;
		if(GetCurrentSym = NO_SYM) then begin
			writeln('Error at position: ', GetSymPosition);
		end
		else begin
			writeln('Success');
		end;
		writeln('->');
		Readln(input);
	end;
End.