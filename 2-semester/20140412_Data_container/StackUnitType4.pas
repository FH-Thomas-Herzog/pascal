Unit stackUnitType4;


// ###################### Interface part ######################
Interface
		
	Type	
		Stack = Pointer;
	
	Procedure Init(VAR  s: Stack; max: Integer);
	
	Procedure Dump(VAR  s: Stack);
	
	Procedure Push(VAR s: Stack; e: Integer);

	Procedure Pop(VAR s: Stack; VAR e: Integer); 

	Function IsEmpty(VAR s: Stack): Boolean; 


// ###################### Implementation part ######################
Implementation
		
	Type
		StackPtr = ^StackRec;
		StackRec = record
			top: Integer;
			data: Array[1..1] of Integer;
			range: INTEGER;
		End;
	Procedure Init(VAR  s: Stack; max: Integer);
	Begin
		GetMem(s, 4 + 2 * max);
		StackPtr(s)^.top := 0;
		StackPtr(s)^.range := max;
	End;
	
	Procedure Dump(VAR  s: Stack);
	Begin
		FreeMem(s, 4 + 2 * StackPtr(s)^.range);
		s := nil;
	End;
	
	Procedure Push(VAR s: Stack; e: Integer);
	Begin
		if (StackPtr(s)^.top = StackPtr(s)^.range) then begin
			writeln('Stackoverflow');
		end;
		StackPtr(s)^.top := StackPtr(s)^.top + 1;
		(*$R-*)
		StackPtr(s)^.data[StackPtr(s)^.top] := e;
		(*$R+*)
	End;

	Procedure Pop(VAR s: Stack; VAR e: Integer); 
	Begin
		if (StackPtr(s)^.top = 0) then begin
			writeln('Stackunderflow');
		end;
		(*$R-*)
		e := StackPtr(s)^.data[StackPtr(s)^.top];
		(*$R+*)
		StackPtr(s)^.top := StackPtr(s)^.top - 1;
	End;

	Function IsEmpty(VAR s: Stack): Boolean; 
	Begin
		IsEmpty := StackPtr(s)^.top = 0;
	End;
Begin
End.
