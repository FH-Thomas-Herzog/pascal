Program PatternMatcherLibTest;

Uses
  PatternMatcherLib;
  
Type
  PatternMatcherProcess = Procedure (s, p:String; Var pos:Integer);
  
Var
  s,p: string;
  pos: Integer;
Begin
  while (true) do begin
    writeln;
    writeln('Enter END [STRING] and [PATTERN} to end');
    writeln('Enter a value < 0 for [REPEATIONS] to end');
    writeln;
    write('[STRING]: ');
    Readln(s);
    if (s = 'END') then begin
      Halt;
    end;
    writeln;
    
    write('[PATTERN]: ');
    Readln(p);
    if (p = 'END') then begin
      Halt;
    end;
    writeln;
    
    BruteForceLR(s, p, pos);
    writeln('BruteForceLR:');
    writeln('Pattern ->', p);
    writeln('String -> ', s);
    writeln('Position -> ', pos);
    writeln;
    
    BruteForceRL(s, p, pos);
    writeln('BruteForceRL:');
    writeln('Pattern ->', p);
    writeln('String -> ', s);
    writeln('Position -> ', pos);
    writeln;
    
    KnuthMorrisPrattl(s, p, pos);
    writeln('KnuthMorrisPrattl1:');
    writeln('Pattern ->', p);
    writeln('String -> ', s);
    writeln('Positionv-> ', pos);
    writeln;
    
    KnuthMorrisPrattl2(s, p, pos);
    writeln('KnuthMorrisPrattl2:');
    writeln('Pattern ->', p);
    writeln('String -> ', s);
    writeln('Position -> ', pos);
    writeln;    
        
    BoyerMoore(s, p, pos);
    writeln('BoyerMoore:');
    writeln('Pattern ->', p);
    writeln('String -> ', s);
    writeln('Position -> ', pos);
    writeln;
        
    RabinKarp(s, p, pos);
    writeln('RabinKarp:');
    writeln('Pattern ->', p);
    writeln('String -> ', s);
    writeln('Position -> ', pos);
    writeln;
  end;
End.