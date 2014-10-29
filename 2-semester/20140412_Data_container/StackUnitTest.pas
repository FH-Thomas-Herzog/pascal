Program StackUnitTest;

Uses 
	StackUnit, StackUnitType1;
	
Var
	val, i: Integer;
	
Begin
	for i := 0 to 99 do begin
		writeln('Push to stack: ', i);
		StackUnit.Push(i);
	end;
	while (StackUnit.IsEmpty) do begin
		writeln('Pop from stack: ', StackUnit.Pop);
	end
End.