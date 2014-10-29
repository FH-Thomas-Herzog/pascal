Unit Parser;
  
Interface
  Procedure InitParser(inp: String);

  Function Parse: Boolean;
  
  Function ErrorPos: Longint;
  
  Function GetResult: Integer;
  
Implementation

  Uses
    Scanner;
  Var
    success: Boolean;
    
  Procedure Expression; Forward;
  Procedure Term; Forward;
  Procedure Fact; Forward;
  
  
  Procedure Expression;
  Begin
    Term;
    If (not success) then 
      exit;
    while (GetCurrentSym = PLUS_SYM) or (GetCurrentSym = MINUS_SYM) do begin
      Case GetCurrentSym of
        PLUS_SYM: begin
          write(' + ');
          GetNextSym;
          Term;
          if (not success) then 
            exit;
        end;
        MINUS_SYM: begin
          write(' - ');
          GetNextSym;
          Term;
          if (not success) then begin
            exit;
          end;
        end;
      end;
    end;
  End;
  
  Procedure Term;
  Begin
    Fact;
    if (not success) then begin
      exit;
    end;
    while (GetCurrentSym = MULT_SYM) or (GetCurrentSym = DIV_SYM) do begin
      Case GetCurrentSym of
        MULT_SYM: begin
          write(' * ');
          GetNextSym;
          Fact;
          if (not success) then 
            exit;
        end;
        DIV_SYM: begin
          write(' / ');
          GetNextSym;
          Fact;
          if (not success) then 
            exit;
        end;
      end;
    end;
  End;
  
  Procedure Fact;
  Begin
    Case GetCurrentSym of
      NUMBER_SYM: begin
        write(GetCurrentNumberValue, '');
        GetNextSym;
      end;
      LEFT_PAIR_SYM: begin
        GetNextSym;
        Expression;
        if (not success) then
          exit;
        if GetCurrentSym <> RIGHT_PAIR_SYM then begin
          success := FALSE;
          exit;
        end;
        GetNextSym;
      end
      else begin
        success := False; 
        exit;
      end;
    end;
  End;
  
  Procedure InitParser(inp: String);
  Begin
    InitScanner(inp);
    success := false;
  End;
  
  Function Parse: Boolean;
  Begin
    success := true;
    Expression;
    if (GetCurrentSym <> END_SYM) then
      success := false;
      
    writeln(GetCurrentSym);
    Parse := success;
  End;

  Function ErrorPos: Longint;
  Begin
    ErrorPos := GetSymPosition;
  End;
  
  Function GetResult: Integer;
  Begin
    GetResult := 0;
  End;
  
Begin
  InitParser('');
End.