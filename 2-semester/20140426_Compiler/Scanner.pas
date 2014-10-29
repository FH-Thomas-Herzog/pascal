Unit Scanner;

Interface
  Type 
    TSymbol = (NO_SYM, END_SYM, PLUS_SYM, MINUS_SYM, DIV_SYM, MULT_SYM, LEFT_PAIR_SYM, RIGHT_PAIR_SYM, NUMBER_SYM);

  Const 
    EOI = Chr(0);
  Procedure InitScanner (inp: String);

  Procedure GetNextSym;

  Function GetCurrentSym: TSymbol;

  Function GetSymPosition: Longint;

  Function GetCurrentNumberValue: Longint;


Implementation

  Var
    input: String;
    curPos: Longint;
    curChar: Char;
    curSym: TSymbol;
    curNumValue: Longint;

  {}  
  Procedure GetNextChar;
  Begin
    if (curPos < Length(input)) then begin
      Inc(curPos);
      curChar := input[curPos];
    end
    else begin
      curChar := EOI;
    end;
  End;

  Procedure InitScanner (inp: String);
  Begin
    input := inp;
    curPos := 0;
    curNumValue := 0;
    GetNextChar;
    GetNextSym;
  End;

  Procedure GetNextSym;
  Var 
    numStr: String;
    code: Integer;
    numberSym: TSymbol;
  Begin
    while (curChar = '') do begin
      GetNextChar;
    end;

    Case curChar of 
      // end of input reached
      EOI: begin curSym := END_SYM; end;
      // Plus symbol found
      '+': begin curSym := PLUS_SYM; GetNextChar; end;
      // Minus symbol found
      '-': begin curSym := MINUS_SYM; GetNextChar;end;
      // Div symbol found
      '/': begin curSym := DIV_SYM; GetNextChar; end;
      // Multiplication symbol found
      '*': begin curSym := MULT_SYM; GetNextChar; end;
      // left brackets symbol found
      '(': begin curSym := LEFT_PAIR_SYM; GetNextChar; end;
      // Right bracckets symbol found
      ')': begin curSym := RIGHT_PAIR_SYM; GetNextChar; end;
      // Number found
      '0'..'9': begin 
        numStr := '';
        while(curChar >= '0') and (curChar <= '9') do begin
          numStr := numStr + curChar;
          GetNextChar;
        end;
        curSym := NUMBER_SYM;
        Val(numStr, curNumValue, code);
      end
      else begin
        curSym := NO_SYM;
      end;
    end;
  End;

  Function GetCurrentSym: TSymbol;
  Begin
    GetCurrentSym := curSym;
  End;

  Function GetSymPosition: Longint;
  Begin
    GetSymPosition := curPos;
  End;

  Function GetCurrentNumberValue: Longint;
  Begin
    GetCurrentNumberValue := curNumValue;
  End;

Begin
  InitScanner('');
End.