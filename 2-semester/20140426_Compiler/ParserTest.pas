Program ParserTest;

Uses 
  Parser;

Var
  input: String;
  
Begin
  Write('->');
  ReadLn(input);
  while (input <> '') do begin
    InitParser(input);
    writeln;
    if (not Parse) then begin
      writeln('Error at: ', ErrorPos);
    end
    else begin
      writeln('Success ->');
    end;
    writeln('->');
    Readln(input);
  end;
End.