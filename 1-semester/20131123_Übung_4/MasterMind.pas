{
  Programm which implements a game called master mind, with colors.
  It uses the MasterMindUnit because it provides all necessary functionality 
  needed to realize a implementation of this game.
  
  The game works via the console, and will ask the user as long as has guessed the colors
  correctly. 
  The user is able to configure the game by entering the count of colors.
  On start and after the user has guessed the colors correctly, the user is 
  asked if he wants to proceed.
  If he says no then the program exists, otherwise the program will restart.
}
PROGRAM MasterMind;

{
  The MasterMindUnit to be used in this main program.
}
USES MasterMindUnit;
 

  {
    Start the application by asking the user if he wants to start.
    If the user won't start then this function will return false, otherwise true
    
    @return
        true if the user wnats to start the application, false otherwise    
  }  
  FUNCTION Start: BOOLEAN;
  VAR
    input: STRING;
    initialized: BOOLEAN;
  BEGIN
    initialized := false;
    WHILE NOT initialized DO BEGIN
      Write('Do you want to start the game [y, n] ?: ');
      ReadLn(input); 
      { Validate the user input }
      IF ('y' = LowerCase(input)) OR ('n' = LowerCase(input)) THEN BEGIN
        IF 'y' = LowerCase(input) THEN BEGIN
          initialized := true;
          Start := true;    
          WriteLn('---------------------------------------------------------');
        END
        { return false on no option }
        ELSE IF 'n' = LowerCase(input) THEN BEGIN
          initialized := true;
          Start := false; 
        END;
      END
      { Handle invalid input }
      ELSE BEGIN
        Writeln('Invalid input [', input, ']');        
      END
    END;
  END;
 
  {
    Procedure which configures the application. 
    The user can enter the color count which defines the difficulty.
    
    @return
        the defined configuration which would be the color count
  }
  FUNCTION Configure: Range;
  VAR
    input: STRING;
    i, count, code: INTEGER;
    valid: BOOLEAN;
  BEGIN
    valid := false;
    count := 0;
    code := 0;
    { run as long as the user has not entered a valid configuration }
    WHILE NOT valid DO BEGIN
      Write('How many colors you would like to play [', Low(Range), '-', High(Range), ']?: ');
      ReadLn(input);  
      Val(input, count, code);
      { Validate color range }
      IF (code = 0) AND (count >= Low(Range)) AND (count <= High(Range)) THEN BEGIN          
        Writeln('You have chosen ', count, ' color(s)');    
        WriteLn('');   
        Writeln('Supported colors: ');
        { Print the supported colors }
        FOR i := Low(getSupportedColors) TO High(GetSupportedColors) DO BEGIN
          Write(getSupportedColors[i]);
          IF i < High(GetSupportedColors) THEN BEGIN
            Write(', ');
          END
        END;
        WriteLn('');
        valid := true
      END
      { Handle invalid input }
      ELSE
        Writeln('Invalid input [', input, ']');  
    END;
    
    Configure := count;
  END;
  
  {
    Reads the user input as long as all inputs have been done correctly.
    
    @return
        the ColorCombination isntance which holds a valid user input
  }
  FUNCTION ReadUserInput: ColorCombination;
  VAR
    input: STRING;
    i: Range;
    count: INTEGER;
  BEGIN
    ReadUserInput := MasterMindUnit.InitColorCombination;
    count := 1;
    i := Low(Range);
       
    Writeln('');
    Writeln('Make your guess !');      
    Writeln('');
    
    { Get all color guesses which are necessary }
    WHILE count <= MasterMindUnit.GetCurrentCount DO BEGIN
      Write(count, ' Color: ');
      ReadLn(input);
      { Validate for correct input }
      IF MasterMindUnit.isValidColor(input) THEN BEGIN
        ReadUserInput.colors[i] := input;
        count := count + 1;
        IF i < High(Range) THEN BEGIN
          Inc(i);
        END
      END
      { Handle invalid input }
      ELSE BEGIN        
       Writeln('');       
       WriteLn('Color not supported [', input, ']');   
       Writeln('')
      END;
    END 
    
  END;
  
  {
    Validates the user input against the generated colors and prints the result to 
    the console.
    
    @param
        guess: the user made guess
    @return
        true if the user has matched the generated colors
  }
  FUNCTION ValidateUserInput(guess: ColorCombination): BOOLEAN;
  VAR
    res: Result;
    i: Range;
  BEGIN
    { Init result and get validation }
    ValidateUserInput := false;
    res := MasterMindUnit.validate(guess);  
    Writeln('');
    { If at least one but not all colors have been gueesed correctly }
    IF (res.matchCount > 0) AND (res.matchCount < MasterMindUnit.GetCurrentCount) THEN BEGIN
      WriteLn('The following ', res.matchCount, ' colors are correct: ');
      FOR i := Low(Range) TO (Low(Range) + res.matchCount -1) DO BEGIN 
        WriteLn(res.matchedIdx[i], ' Color: ', res.guess.colors[res.matchedIdx[i]]);
      END;
    END
    { All colors have been guessed ccorectlly }
    ELSE IF res.matchCount = MasterMindUnit.GetCurrentCount THEN BEGIN
      WriteLn('Congratulations, all colors have been guessed correctly !');
      ValidateUserInput := true;
    END
    { If no color has been guessed correctly }
    ELSE BEGIN
      WriteLn('Sorry no color have been guessed correctly ! ');
    END;  
    Writeln('');
  END;

  {
    Procedure which represents the running game.
    It will run as long as the user intends to.
    
    @see
      Start
      Configure
      ReadUserInput
      ValidateUserInput
  }
  PROCEDURE Run;
  VAR
    count: Range;
    run, valid: BOOLEAN;
    guess: ColorCombination;
  BEGIN
    run := true;
    { Run game as long as the user wants to
      If a run has started then it must be completed and cannot
      be aborted
    }
    WriteLn('#################### Mastermind #########################');    
    WHILE run DO BEGIN
      { 1. Start the game }
      run := Start;
      IF run THEN BEGIN
        { 2. Configure the pplication }
        count := Configure;

        { 2. Init the game }
        MasterMindUnit.Init(count);
        
        { Read user input and validate it as long as the user has guessed the correct colors }
        valid := false;
        WHILE NOT valid DO BEGIN
          WriteLn('---------------------------------------------------------');
          { 3. Read user input }
          guess := ReadUserInput;
          { 3. Validate user input }
          valid := validateUserInput(guess);
          WriteLn('---------------------------------------------------------');
        END;
      END;
    END;
    WriteLn('#################### Mastermind #########################');    
    
  END;

  (*PROCEDURE TestMasterMindUnit;
  VAR
    i, j: INTEGER;
    color: STRING;
    res: RESULT;
    guess: ColorCombination;
  BEGIN

    { Test isValidColor }
    FOR i:= Low(GetSupportedColors) TO High(GetSupportedColors) DO BEGIN
      color := GetSupportedColors[i];
      WriteLn(i, '-Color: ', color:8, ' / valid: ', MasterMindUnit.isValidColor(color));
    END;
    WriteLn('----------------------------------------------------------------------------');

    { Test Init }
    FOR i := Low(Range) TO High(Range) DO BEGIN
      Init(i);
      WriteLn('Generated Colors: ', i);
      FOR j := Low(Range) TO High(Range) DO BEGIN
        WriteLn(j, '-color: ', GetGeneratedColors.colors[j]);
      END;
     WriteLn('----------------------------------------------------------------------------');
    END;

    { Test Validate }
    FOR i := Low(Range) TO High(Range) DO BEGIN
      Init(i);
      guess := InitColorCombination;
      FOR j := Low(Range) TO i DO BEGIN
        guess.colors[j] := GetGeneratedColors.colors[j];
      END;
      res := Validate(guess);
      FOR j := Low(Range) TO High(Range) DO BEGIN    
        WriteLn(j, '-generated-color: ', GetGeneratedColors.colors[j]:8, ' / ', j, '-guessed-color: ', res.guess.colors[j]:6, ' / match count: ', res.matchCount);
      END;
      WriteLn('----------------------------------------------------------------------------');
    END;
  END;*)

BEGIN
  (*TestMasterMindUnit;*)
  { Runs the game as long as the user stops it, after he has guessed the colors correctly }
  Run;
END.