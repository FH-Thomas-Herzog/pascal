Unit StackUnit;

// ###################### Interface part ######################
Interface

	Procedure Push(e: Integer);

	Function Pop: Integer; 

	Function IsEmpty: Boolean; 


// ###################### Implementation part ######################
Implementation

	Const
		MAX = 100;
		
	Var
		top: Integer;
		data: Array[1..MAX] of Integer;	
		
	Procedure Push(e: Integer);
	Begin
		if (top = MAX) then begin
			Writeln('Stack overflow');
			HALT;
		end;
		top := top + 1;
		data[top] := e;
	End;

	Function Pop: Integer; 
	Begin
		if top = 0 then begin
			Writeln('Stack underflow');
		end;
		Pop := data[top];
		top := top -1;
	End;

	Function IsEmpty: Boolean; 
	Begin
		IsEmpty := top = 0;
	End;

Begin
	top := 0;
End.
