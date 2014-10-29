Program StackUnitType3Test;

Uses
	StackUnitType3;

Var
	i, e, error: Integer;
	s1, s2: Stack;
	value: String;
	
Begin
	StackUnitType3.Init(s1, 100);
	for i := 0 to 99 do begin
		writeln('Push to stack: ', (i + 2));
		StackUnitType3.Push(s1, i +2);
	end;
	while (not StackUnitType3.IsEmpty(s1)) do begin
		StackUnitType3.Pop(s1, e);
		writeln('Pop from stack: ', e);
	end;

	writeln;
	writeln('Second stack');
	StackUnitType3.Init(s2, 50);
	for i := 0 to 49 do begin
		writeln('Push to stack: ', i);
		StackUnitType3.Push(s2, i);
	end;
	while (not StackUnitType3.IsEmpty(s2)) do begin
		StackUnitType3.Pop(s2, e);
		writeln('Pop from stack: ', e);
	end;
	StackUnitType3.Dump(s1);
	StackUnitType3.Dump(s2);
End.