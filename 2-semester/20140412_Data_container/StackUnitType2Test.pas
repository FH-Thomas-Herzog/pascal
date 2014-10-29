Program StackUnitType1Test;

Uses
	StackUnitType2;
	
Var
	i, e, error: Integer;
	s1: Stack;
	value: String;
	
Begin
	StackUnitType2.Init(s1);
	for i := 0 to 99 do begin
		writeln('Push to stack: ', i);
		StackUnitType2.Push(s1, i);
	end;
	while (not StackUnitType2.IsEmpty(s1)) do begin
		StackUnitType2.Pop(s1, e);
		writeln('Pop from stack: ', e);
	end
	StackUnitType2.Done(s1);
End.