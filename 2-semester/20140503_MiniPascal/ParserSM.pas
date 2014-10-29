Unit PArserSM;

Interface

  Var
    success: Boolean;
  
  Function Parse: Boolean;
  
Implementation

  Uses
    ScannerLA;
    
  Function IsNoSymbol(expected: TSymbol): Boolean;
  Begin
    success := (success) and (symbol = expected);
    writeln(symbol, ' - ', expected, ' - ', success);
    IsNoSymbol := symbol <> expected;
  End;
  
  Procedure SemanticError(msg: string);
  Begin
    writeln('Semantic error in line: ', symbolLnr, ', column: ', symbolCNr);
    writeln('     ', msg);
  End;
  
  Procedure MP; Forward;
  Procedure VarDeclaration; Forward;
  Procedure Statement; Forward;
  Procedure StatementSequence; Forward;
  Procedure Expression; Forward;
  Procedure Term; Forward;
  Procedure Factor; Forward;
  
  Function Parse: Boolean;
  Begin
    Writeln('Interpretaion started ...');
    success := true;
    MP;
    if (not success) or (IsNoSymbol(EOF_SYM)) then begin
      writeln('Error in line: ', symbolLnr:0, ' column: ', symbolCNr:0);
    end
    else begin
      Writeln('... interpretation succeded');
    end;
  End;
  
  Procedure MP;
  Begin
    if (IsNoSymbol(PROGRAMM_SYM)) then begin
      exit;
    end;
    NewSymbol;
    if (IsNoSymbol(IDENT_SYM)) then begin
      exit;
    end;
    NewSymbol;
    if (IsNoSymbol(SEMICOLON_SYM)) then begin
      exit;
    end;
    NewSymbol;
    if (symbol = VAR_SYM) then begin
      VarDeclaration;
      if (not success) then begin
        exit;
      end;
    end;
    if IsNoSymbol(BEGIN_SYM) then begin
      exit;
    end;  
    NewSymbol;
    
    StatementSequence;
    
    if (not success) then begin
      exit;
    end;
    if (IsNoSymbol(END_SYM)) then begin
      exit;
    end;
    NewSymbol;
    if (IsNoSymbol(PERIOD_SYM)) then begin
      exit;
    end;  
    NewSymbol;    
  End;
  
  Procedure VarDeclaration;
  Begin
    if (IsNoSymbol(VAR_SYM)) then begin
      exit;
    end;
    NewSymbol;
    if (IsNoSymbol(IDENT_SYM)) then begin
      exit;
    end;
    NewSymbol;
    while symbol = COMMA_SYM do begin
      NewSymbol;
      if (IsNoSymbol(IDENT_SYM)) then begin
        exit;
      end;
      NewSymbol;
    end;
    if (IsNoSymbol(COLON_SYM)) then begin
      exit;
    end;
    NewSymbol;
    if (IsNoSymbol(INT_SYM)) then begin
      exit;
    end;
    NewSymbol;
    if (IsNoSymbol(SEMICOLON_SYM)) then begin
      exit;
    end;
    NewSymbol;
  End;
  
  Procedure StatementSequence;
  Begin
    Statement;
    if (not success) then begin
      exit;
    end;
    while symbol = SEMICOLON_SYM do begin
      NewSymbol;
      Statement;
      if (not success) then begin
        exit;
      end;
    end;
  End;
  
  Procedure Statement;
  Begin
    Case symbol of
      IDENT_SYM: begin  
        NewSymbol;      
        if (IsNoSymbol(ASSIGN_SYM)) then begin
          exit;
        end;
        NewSymbol;
        writeln('before expression ', symbol);
        Expression; 
        writeln('after expression ', symbol);
        if (not success) then begin
          exit;
        end;
      end;
      READ_SYM: begin 
        NewSymbol;      
        if (IsNoSymbol(LEFT_PAIR_SYM)) then begin
          exit;
        end;
        NewSymbol;    
        if (IsNoSymbol(IDENT_SYM)) then begin
          exit;
        end;
        NewSymbol; 
        if (IsNoSymbol(RIGHT_PAIR_SYM)) then begin
          exit;
        end;
        NewSymbol;
      end;
      WRITE_SYM: begin  
        NewSymbol;      
        if (IsNoSymbol(LEFT_PAIR_SYM)) then begin
          exit;
        end;
        NewSymbol;
        Expression;     
        if (not success) then begin
          exit;
        end;
        if (IsNoSymbol(RIGHT_PAIR_SYM)) then begin
          exit;
        end;
        NewSymbol;
      end else begin
        success := false;
      end;
    end;
  End;
  
  Procedure Expression;
  Begin
    writeln('Expression begin ', symbol);
    Term;     
    writeln('Expression after ', symbol, ' - ', success);
    if (not success) then begin
      exit;
    end;
    while (symbol = PLUS_SYM) or (symbol = MINUS_SYM) do begin
      Case symbol of
        PLUS_SYM: begin
          NewSymbol;
          Term;
          if (not success) then begin
            exit;
          end;
        end;
        MINUS_SYM: begin
          NewSymbol;
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
    writeln('Fuck');
    Factor;
    if (not success) then begin
      exit;
    end;
    while (symbol = TIME_SYM) or (symbol = DIV_SYM) do begin
      Case symbol of
        TIME_SYM: begin
          NewSymbol;
          Factor;
          if (not success) then begin
            exit;
          end;
        end;
        DIV_SYM: begin
          NewSymbol;
          Factor;
          if (not success) then begin
            exit;
          end;
        end;
      end;
    end
  End;
  
  Procedure Factor;
  Begin
    writeln('Factore begin ', symbol);
    Case symbol of 
      IDENT_SYM: begin
        NewSymbol;
      end;
      NUMBER_SYM: begin
        NewSymbol;
      end;
      LEFT_PAIR_SYM: begin
        NewSymbol;
        writeln('term before expression ', symbol);
        Expression;
        writeln('term after expression ', symbol);
        if (not success) then begin
          exit;
        end;
        if (not IsNoSymbol(RIGHT_PAIR_SYM)) then begin
          writeln('error');
          exit;
        end;
        NewSymbol;        
      end
      else begin
        success := false;
        exit;
      end;
    end;
  End;
  
Begin
  success := true;
End.