Unit StackUnitType2;


// ###################### Interface part ######################
Interface
	Const
		MAX = 100;
	Type
		Stack = ^StackRec;
		StackRec = record
			top: Integer;
			data: Array[1..MAX] of Integer;
		End;
		
	
	Procedure Init(VAR  s: Stack);
	
	Procedure Dump(VAR  s: Stack);
	
	Procedure Push(VAR s: Stack; e: Integer);

	Procedure Pop(VAR s: Stack; VAR e: Integer); 

	Function IsEmpty(VAR s: Stack): Boolean; 


// ###################### Implementation part ######################
Implementation
	
	Procedure Init(VAR  s: Stack);
	Begin
		New(s);
		s^.top := 0;
	End;
	
	Procedure Dump(VAR  s: Stack);
	Begin
		Dispose(s);
		s := nil;
	End;
	
	Procedure Push(VAR s: Stack; e: Integer);
	Begin
		if (s^.top = MAX) then begin
			writeln('Stackoverflow');
		end;
		s^.top := s^.top + 1;
		s^.data[s^.top] := e;
	End;

	Procedure Pop(VAR s: Stack; VAR e: Integer); 
	Begin
		if (s^.top = 0) then begin
			writeln('Stackunderflow');
		end;
		e := s^.data[s^.top];
		s^.top := s^.top - 1;
	End;

	Function IsEmpty(VAR s: Stack): Boolean; 
	Begin
		IsEmpty := s^.top = 0;
	End;
Begin
End.
