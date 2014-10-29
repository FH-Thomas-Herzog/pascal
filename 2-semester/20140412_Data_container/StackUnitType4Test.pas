Program StackUnitType4Test;

Uses
	StackUnitType4;

Var
	i, e, error: Integer;
	s1, s2: Stack;
	value: String;
	
Begin
	StackUnitType4.Init(s1, 100);
	for i := 0 to 99 do begin
		writeln('Push to stack: ', (i + 2));
		StackUnitType4.Push(s1, i +2);
	end;
	while (not StackUnitType4.IsEmpty(s1)) do begin
		StackUnitType4.Pop(s1, e);
		writeln('Pop from stack: ', e);
	end;

	writeln;
	writeln('Second stack');
	StackUnitType4.Init(s2, 50);
	for i := 0 to 49 do begin
		writeln('Push to stack: ', i);
		StackUnitType4.Push(s2, i);
	end;
	while (not StackUnitType4.IsEmpty(s2)) do begin
		StackUnitType4.Pop(s2, e);
		writeln('Pop from stack: ', e);
	end;
	StackUnitType4.Dump(s1);
	StackUnitType4.Dump(s2);
End.