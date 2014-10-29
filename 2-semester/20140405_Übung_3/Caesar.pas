Program Caesar;

Uses
	CaesarUnit, PrintUtils, Crt;
	
Var
	runType: String;
	inFile, outFile: Text;
	key, error: Integer;
Begin
	PrintUtils.PrintHeader('Caesar encryption/decryption program');
	writeln('reading program arguments...');
	if (ParamCount <> 4) then begin
		writeln('Four argmunets must be present. -e [encrypt] or -d[decrypt] inputFilePath outputFilePath');
	end
	else begin
		runType := ParamStr(1);
		if (runtype <> '-e') and (runType <> '-d') then begin
			writeln('First argument is invalid. Must be either -e [encrypt] or -d[decrypt] but is: ', runType);
		end
		else begin
			Val(ParamStr(2), key, error);
			if (error <> 0) then begin
				writeln('Second parameter must be of type Integer but was: ', ParamStr(2));
			end
			else begin
				Assign(inFile, ParamStr(3));	
				Reset(inFile);
				error := IOResult;
				if (error <> 0) then begin
					writeln('Error on opening input file: ', error);
				end 
				else begin
					Assign(outFile, ParamStr(4));
					if (runType = '-e') then begin
						writeln('encrypting file');
						CaesarUnit.Encrypt(inFile, outFile, key);
					end else begin
						writeln('decrypting file');
						CaesarUnit.Decrypt(inFile, outFile, key);
					end;
				end;
			end;
		end;
	end;
End.