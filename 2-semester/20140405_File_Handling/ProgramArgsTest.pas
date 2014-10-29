Program ProgramArgsTest;

Var
	i: Integer;
Begin
	writeln('Param arg[0]: ', Paramstr(0));
    writeln;
	If ParamCount = 0 then begin
		writeln('No arguments added to program run');
		writeln;
	end
	Else begin
		writeln('Parameter argument count: ', ParamCount);
		for i := 1 to ParamCount do begin
			Writeln('Param arg[', i, ']: ', ParamStr(i));
		end;
	end;
End.