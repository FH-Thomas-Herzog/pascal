Program IOResultTest;

Var
	F : File;
	s: String;
	result: Integer;
	
	
Begin
	{$I-}
	Assign(f, '......');
	Reset(f);
	result := IOResult;
	if result <> 0 then begin
		writeln('IOResult: ', result);
	end;
	{$I-}
End.