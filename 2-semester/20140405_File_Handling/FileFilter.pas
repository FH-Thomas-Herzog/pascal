PROGRAM Filter;
(*
	filter (read stdin, write stdout)
	filter inFile (write stdout)
	filter inFile outFile
*)
CONST
	bufferSize = 1024;
	
VAR
	inName, outName, line: STRING;
	mode: (byChars, byLines, byBlocks);
	ch: CHAR;
	inFile, outFile: FILE;
	charsRead, charsWritten: LONGINT;
	linesRead, linesWritten: LONGINT;
	blocksRead, blocksWritten: LONGINT;
	bytesInBlockRead, bytesInBlockWritten: INTEGER;
	
	buffer: ARRAY[1..bufferSize] OF CHAR;

PROCEDURE WritePerformanceInfo;
BEGIN
	WriteLn;
	WriteLn('chars read: ', charsRead, 'chars written: ', charsWritten);
	WriteLn('lines read: ', linesRead, ' lines written: ', linesWritten);
	WriteLn('blocks read: ', blocksRead, ' blocks written: ', blocksWritten);
END;

PROCEDURE ResetPerformanceInfo;
BEGIN
	charsRead := 0; charsWritten := 0;
	linesRead := 0; linesWritten := 0;
	blocksRead := 0; blocksWritten := 0;
END;

BEGIN
	mode := byLines;
	
	IF (mode = byBlocks) AND (ParamCount <> 2) THEN
		WriteLn('ERROR: paramter inFile and/or outFile missing!');
		
	IF ParamCount > 0 THEN BEGIN
		inName := ParamStr(1);
		{$I-}
		IF (mode = byChars) OR (mode = byLines) THEN BEGIN
			Assign(input, inName);
			Reset(input);
		END ELSE BEGIN (* mode = byBlocks *)
			Assign(inFile, inName);
			Reset(inFile, 1);
		END;
		IF IOResult <> 0 THEN BEGIN
			WriteLn('ERROR: file ', inName, ' not found!');
			HALT;
		END;
		{$I+}
		
		IF ParamCount > 1 THEN BEGIN
			outName := ParamStr(2);
			IF (mode = byChars) OR (mode = byLines) THEN BEGIN
				Assign(output, outName);
				ReWrite(output);
			END ELSE BEGIN
				Assign(outFile, outName);
				ReWrite(outFile, 1);
			END;
		END;
	END;
	
	CASE mode OF
		byChars: BEGIN
			REPEAT
				Read(input, ch);
				Inc(charsRead);
				Write(output, ch);
				Inc(charsWritten);
			UNTIL EOF(input);
		END;
		byLines: BEGIN
			WriteLn('byLines');
			REPEAT
				ReadLn(input, line);
				Inc(linesRead);
				WriteLn(output, line);
				Inc(linesWritten);
			UNTIL EOF(input);
		END;
		byBlocks: BEGIN
			BlockRead(inFile, buffer, bufferSize, bytesInBlockRead);
			blocksRead := 1;
			WHILE bytesInBlockRead > 0 DO BEGIN
				BlockWrite(outFile, buffer, bytesInBlockRead, bytesInBlockWritten);
				Inc(blocksWritten);
				IF bytesInBlockRead <> bytesInBlockWritten THEN BEGIN
					WriteLn('ERROR: number of bytes in block read <> writtten');
					HALT;
				END;
				BlockRead(inFile, buffer, bufferSize, bytesInBlockRead);
				Inc(blocksRead);
			END;
		END;
	END;
	
	IF ParamCount > 0 THEN BEGIN
		IF (mode = byChars) OR (mode = byLines) THEN
			Close(input)
		ELSE
			Close(inFile);
			
		IF ParamCount > 1 THEN BEGIN
			IF (mode = byChars) OR (mode = byLines) THEN
				Close(output)
			ELSE
				Close(outFile);
		END;
	END;
	
	IF ParamCount > 1 THEN BEGIN
		Assign(output, ''); (* reassign output to stdout *)
		ReWrite(output);
	END;
	WriteLn;
	WritePerformanceInfo;
	ResetPerformanceInfo;
END.