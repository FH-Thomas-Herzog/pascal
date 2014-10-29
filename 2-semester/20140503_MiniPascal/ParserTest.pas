Program ParserTest;

Uses
  ScannerLA, ParserSM;
  
Var
  srcName: string;
  ok: Boolean;
  
Begin
    ok := false;
    InitScanner('Test.mpd', ok);
    Parse;
End.
  
