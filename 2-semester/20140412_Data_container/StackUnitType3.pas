Unit stackUnitType3;


// ###################### Interface part ######################
Interface

	Type
		Stack = ^StackRec;
		StackRec = record
			top: Integer;
			data: Array[1..1] of Integer;
			range: INTEGER;
		End;
		
	
	Procedure Init(VAR  s: Stack; max: Integer);
	
	Procedure Dump(VAR  s: Stack);
	
	Procedure Push(VAR s: Stack; e: Integer);

	Procedure Pop(VAR s: Stack; VAR e: Integer); 

	Function IsEmpty(VAR s: Stack): Boolean; 


// ###################### Implementation part ######################
Implementation
	
	Procedure Init(VAR  s: Stack; max: Integer);
	Begin
		GetMem(s, 4 + 2 * max);
		s^.top := 0;
		s^.range := max;
	End;
	
	Procedure Dump(VAR  s: Stack);
	Begin
		FreeMem(s, 4 + 2 * s^.range);
		s := nil;
	End;
	
	Procedure Push(VAR s: Stack; e: Integer);
	Begin
		if (s^.top = s^.range) then begin
			writeln('Stackoverflow');
		end;
		s^.top := s^.top + 1;
		(*$R-*)
		s^.data[s^.top] := e;
		(*$R+*)
	End;

	Procedure Pop(VAR s: Stack; VAR e: Integer); 
	Begin
		if (s^.top = 0) then begin
			writeln('Stackunderflow');
		end;
		(*$R-*)
		e := s^.data[s^.top];
		(*$R+*)
		s^.top := s^.top - 1;
	End;

	Function IsEmpty(VAR s: Stack): Boolean; 
	Begin
		IsEmpty := s^.top = 0;
	End;
Begin
End.
