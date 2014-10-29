Program StackUnitType1Test;

Uses
	StackUnitType1;
	
Var
	i, e, error: Integer;
	s1: Stack;
	value: String;
	
Begin
	StackUnitType1.Init(s1);
	for i := 0 to 99 do begin
		writeln('Push to stack: ', i);
		StackUnitType1.Push(s1, i);
	end;
	while (not StackUnitType1.IsEmpty(s1)) do begin
		StackUnitType1.Pop(s1, e);
		writeln('Pop from stack: ', e);
	end;
	StackUnitType1.Done(s1);
End.