{
  Unit for the master mind application, which has a memory to hold the 
  randomlly generated color combination and intended difficulty specified by the 
  color count.
  By default this unit is initialized with a color combination of the depth Low(Range).
  The Range type specifies the range of supported colors.
  
  Call Init to reset or reinitialize the master mind memory
}
UNIT MasterMindUnit;

{ ##### Interface part of the master mind unit ##### }
INTERFACE

TYPE
  { Array which specifies the supported colors }
  SupportedColors = ARRAY[1..7] OF STRING;
  
  { Specifies the range of the supported color count for the generated color combination }
  Range = 1..6;
 
  { The combound which holds a color combination }
  ColorCombination = RECORD
    colors: ARRAY[Range] OF STRING;
  END;
 
  { The combound which holds the result of the user guess }
  Result = RECORD
    guess: ColorCombination;
    matchedIdx: ARRAY[Range] OF Range;
    matchCount: INTEGER
  END;

  { ###### Function and procedure visible to the main program ###### }
  {
    Initializes the mastermind memory by generation of a new color combination
    with the specified count.
    
    @param
        generatedCount: the count of to generated colors contained in the ColorCombination instance
  }
  PROCEDURE Init(generatedCount: Range);
  
  {
    Function which validates the user guess and returns the result of the validation via a Result instance.
    The case of the defined colors in the ColorCombination instance is ignored.
    
    @param 
        guess: the ColorCombination which holds the user guess
    @result
        the result represented by a Result instance which contains the user guess and an array with 
        the matched indexes and also the count of the matches.        
  }
  FUNCTION Validate(guess: ColorCombination): Result;
  
  {
    Gets the current count of the generated colors. 
    Allows on read access to the memory count.
    
    @return
        the current set color count
  }
  FUNCTION GetCurrentCount: INTEGER;
  
  {
    Returns the supported colors. 
    Allows only read access.
    
    @return
        the supported colors
  }
  FUNCTION GetSupportedColors: SupportedColors;
  
  {
    Function which answers the question if the given string represents a valid color.
    The case is ignored.
    
    @param
        color: the color to check if its is valid, which means it is supported 
    @return
        true if the´given color is a valid one, false otherwise
  }
  FUNCTION IsValidColor(color: STRING): BOOLEAN;
  
  {
    Initializes the a ColorCombination instance with default values.
    All colors will be set to an empty string
    
    @return
        the initialized ColorCombination instance
  }
  FUNCTION InitColorCombination: ColorCombination;
  
  (*{ ## Just for testing ## }
  FUNCTION GetGeneratedColors: ColorCombination;*) 
  
{ ##### Implementation part of the master mind unit ##### }
IMPLEMENTATION
      
  CONST    
    { Array which specifies the supported colors }
    Colors: SupportedColors = ('red', 'green', 'blue', 'yellow', 'orange', 'white', 'black');
    
  {
    the memory of this unit
  }
  VAR
    generated: ColorCombination;
    count: Range;
    
  { ###### Private function and procedures ###### }
  {
    Inits the a Result instance.
    1. mathCount will be set to 0
    2. matchedIdx to Low(Range) (Access shall be depending on the set mathCount)
    3. guess.colors will be set to empty string
    
    @return
        the initialized Result instance
  }
  FUNCTION InitResult:Result;
  VAR 
    i: RANGE;
  BEGIN
    InitResult.matchCount := 0;
    InitResult.guess := InitColorCombination; {.colors[i] := '';}
    FOR i := Low(Range) TO High(Range) DO BEGIN
      InitResult.matchedIdx[i] := Low(Range);
    END;
  END;
  
  { ###### Public function and procedures implementations ###### }
  
  { Init color combination instance }
  FUNCTION InitColorCombination: ColorCombination;
    VAR
      i: Range;
    BEGIN
      FOR i:= Low(Range) TO High(Range) DO BEGIN
        InitColorCombination.colors[i] := '';
      END;
  END;
  
  { Init the memeory }
  PROCEDURE Init(generatedCount: Range);
  VAR
    i: Range;
    idx: INTEGER;
  BEGIN
    { Aet memeory with default initialized state }
    count := generatedCount;
    generated := InitColorCombination;
    { generate random colors }
    Randomize;
    FOR i := Low(Range) TO count DO BEGIN
      idx := Random(High(Colors));
      { avoid 0 idx }
      IF idx = 0 THEN BEGIN
        idx := idx + 1;
      END;
      generated.colors[i] := Colors[idx];
    END;
  END;

  { Validates the user guess }
  FUNCTION Validate(guess: ColorCombination): Result;
  VAR
    i, k: Range;
    res: RESULT;
  BEGIN
    res := InitResult;
    k := Low(Range);
    
    FOR i := Low(Range) TO count DO BEGIN 
      res.guess.colors[i] := guess.colors[i];  
      IF generated.colors[i] = LowerCase(guess.colors[i]) THEN BEGIN
        res.matchCount := res.matchCount + 1;
        res.matchedIdx[k] := i;
        IF k < High(Range) THEN BEGIN
          Inc(k)
        END
      END
    END;
    
    Validate := res
  END;
  
  { checks for valid color string }
  FUNCTION IsValidColor(color: STRING): BOOLEAN;
  VAR
    i: INTEGER;
    valid: BOOLEAN;
  BEGIN
    valid := false;
    i := Low(Colors);
    WHILE (NOT valid) AND (i <= High(Colors)) DO BEGIN
      IF Colors[i] = LowerCase(color) THEN BEGIN
        valid := true;
      END;  
      Inc(i)
    END;
    
    IsValidColor := valid;
  END;
    

  { ###### Public getter functions, realizes only read access ###### }     
  { Gets the supported colors }
  FUNCTION GetSupportedColors: SupportedColors;
  BEGIN 
    GetSupportedColors := Colors;
  END;

  { read access tot eh current set count }
  FUNCTION GetCurrentCount: INTEGER;
  BEGIN
    GetCurrentCount := count;
  END;
  
  (* { ## Just for testing ## }
  FUNCTION GetGeneratedColors: ColorCombination; 
  BEGIN
    GetGeneratedColors := generated;
  END; *)
  
BEGIN
  { Init this unit with lowest valud, so that memory has no invalid state }
  Init(Low(Range));
END.