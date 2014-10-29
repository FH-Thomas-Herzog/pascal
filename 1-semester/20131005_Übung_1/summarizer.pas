{
  This program is used to summarize positive Integer input.
  All integer input greater or equal to the first input value will
  be added to the 'countGreater' variable.
  All integer input smaller then the first input value will 
  be added to the 'countSmaller' variable.
  Negative values will be excluded and not added to any sum.
  When 0 is entered, the program will exit.
}
PROGRAM Summarizer;

VAR
  countSmaller, countGreater, first, value: INTEGER;
  
BEGIN
  countSmaller := 0;
  countGreater := 0;
  ReadLn(value);
  { 
    The var first is used to save the first read input value over the program lifetime.
    Need var first to be able to compare the following read input
    against the first input.
  }
  first := value;
    
  WHILE value <> 0 DO BEGIN
    {
      Exclude all negative input, because as specified only 
      positive integer greater than 0 are supposed to be added to the a sum
    }
    IF value > 0 THEN BEGIN
      {
        No need to check for the first read input, because when the first input
        was entered then it is guaranteed that the conditions fits and that
        the first input is added to the right sum
      }
      IF value >= first THEN 
        countGreater := countGreater + value
      ELSE
        countSmaller := countSmaller + value
    END;
    ReadLn(value)
  END;
  
  Write('Sum A: ', countGreater, ' / Sum B: ', countSmaller)
END.