{
  This program is used to calculate the binomial formula (a + b)^2.
  The result will be displayed as a table in the console, where the table will be 
  displayd with a well design.
  This design is realized by calculating the maximum value width of a column and enhancing the 
  converted results strings to fit this width.
  
  Contained util functions:
  -------------------------
  1. ToString(value: INTEGER): STRING;
     Converts a integer to a string
      
  2. RepeatString(value: STRING; count: INTEGER): STRING;
     Repeats the given string count itmes
      
  3. EnhanceStringLength(value: STRING; width: INTEGER): STRING;
     Enahnces string width to fit specified width
      
  4. GetMaximumOfTwo(first, second: INTEGER): INTEGER;
     Gets the maximum of two numbers
  
  5. Power(value, n: INTEGER): INTEGER;
     Powers the given value by n
  
  6. CalcBinomial(a, b: INTEGER): INTEGER;
     Calculates (a + b)^2
}
PROGRAM BinomialCalculator;
  
  {
    Converts a integer to a string representation.
    @param value:
              the integer to be converted to a string
    @paaram the string representation of the given integer value
  }
  FUNCTION ToString(value: INTEGER): STRING;
  VAR 
    s: STRING;
  BEGIN
   Str(value, s);
   ToString := s
  END;
  
  {
    Repeats the given string as often as 'count' defines.
    @param value:
              the given string to be repeated
    @param count:
              defines the number of repeations
    @return the created string representing the repeated given string 'value'.
    If 'count <= 0' then a empty string is returned
  }
  FUNCTION RepeatString(value: STRING; count: INTEGER): STRING;
  VAR 
    i: INTEGER;
    str: STRING;
  BEGIN
    str := '';
    IF count > 0 THEN
      FOR i := 1 TO count DO
        str := str + value;
    
    RepeatString := str
  END;
  
  {
    Builds the string representation for the column and enhances the
    given string 'value' length to the length defined by 'width' by adding spaces
    to the given string.
    @param value:
              the given string to be added into the column string
    @param width:
              the intended length of the given string
    @return the created string, if width smaller then 'value' length, then 'value' is returned
    @see RepeatString(value: STRING; count: INTEGER): STRING;
  }
  FUNCTION EnhanceStringLength(value: STRING; width: INTEGER): STRING;
  VAR
    len: INTEGER;
    str: STRING;
  BEGIN
    str := value;
    len := width - Length(str);
    
    IF len > 0 THEN
      str := str + RepeatString(' ', len);
    
    EnhanceStringLength := str;
  END;
  
  {
    Function which gets the maximum of two numbers.
    @param first: 
                the first number for the maximum retrieval 
    @param second: 
                the second number for the maximum retrieval 
    @return the maximum of the two given numbers
  }
  FUNCTION GetMaximumOfTwo(first, second: INTEGER): INTEGER;
  BEGIN
    IF first > second THEN
      GetMaximumOfTwo := first
    ELSE
      GetMaximumOfTwo := second
  END;
  
  {
    Calculates 'value powered by n'.
    @param value:
                the value to powered
    @param n:
            the count how often the given 'value' shall be powered
    @return the given 'value powered by n', where when 'n <= 0' then the neutral 
            element is returned, which is 1
  }
  FUNCTION Power(value, n: INTEGER): INTEGER;
  VAR
    temp, i: INTEGER;
  BEGIN
    {
      Calculates the 'value powered by n' where the result is divided by the
      given value to get the proper result.
    }
    temp := value;
    IF n > 0 THEN
      FOR i := 1 TO n DO
        temp := temp * value;
        
    Power := temp DIV value;
  END;

  {
    Calculates the binomial formula (a + b)^2.
    @param a:
          the first value
    @param b:
          the second value
    @return the result of the formula
    @see Power(value ,n: INTEGER): INTEGER
  }
  FUNCTION CalcBinomial(a, b: INTEGER): INTEGER;
  BEGIN
    CalcBinomial := Power(a + b, 2);
  END;
  
  {
    Prints the result of the calculated formula in a table.
    The value 'b' in the formula will have values from '1 to 10', see CONST section of this procedure.
    @param minA:
            the bottom border of the value 'a' in the formula
    @param maxA:
            the top border of the value 'a' in the formula
            
    @see CalcBinomial(a, b: INTEGER): INTEGER;
    @see GetMaximumOfTwo(first, second: INTEGER): INTEGER;
    @see EnhanceStringLength(value: STRING; width: INTEGER): STRING;
    @see RepeatString(value: STRING; count: INTEGER): STRING;
    @see ToString(value: INTEGER): STRING;
  }
  PROCEDURE DisplayBFTable(minA, maxA: INTEGER);
  VAR
    {
      Two dimensional array which holds the calculated values.
    }
    table: ARRAY OF ARRAY OF INTEGER;
    {
      Array which holds the calculated maximum column width,
      which is needed to create the column strings width a proper width,
      so that the printed table will have a well design
    }
    maxColumWidth: ARRAY OF INTEGER;
    {
      i, j: iteration variables;
      rows: the calculated rows of the table
      maxWidth: Used for determining the maximum width of the column values
    }
    i, j, rows, maxWidth: INTEGER;
    {
      Used for building the printed lines of the table
    }
    line: STRING;
  CONST
    {
      Constant for the columns, representing 'b' in the formula (a + b)^2  
    }
    cols = 10;
    {
      Constant for the space between the columns
    }
    space = 3;
  BEGIN
    WriteLn();
    WriteLn('Calculating (a + b)^2 from : minA: ', minA, ' to maxA: ', maxA, ' / b: 1-', cols);
    {
      Check range of actual parameters and avoid border overflow.
    }
    IF minA > maxA THEN
      WriteLn('MinA is not supposed to overflow maxA: || minA: ', minA, ' / maxA: ', maxA)
    ELSE BEGIN
      {
       Calculate rows and set array dimensions.
      }
      rows := maxA - minA + 1;
      setLength(table, rows, cols);
      setLength(maxColumWidth, cols);
      
      {
        Calculate table values, and fill two dimensional 
        array which represents the table
      }
      FOR i := 0 TO rows - 1 DO
        FOR j := 0 TO cols - 1 DO
          table[i, j] := CalcBinomial((minA + i), ( j + 1));
          
      {
        Calculate the maximum width of the to display column, by comparision of the column 
        contained value width of the string representation of the hold value.
      }      
      FOR i := 0 TO cols - 1 DO BEGIN
        maxWidth := 0;
        FOR j := 0 TO rows - 1 DO
          maxWidth := GetMaximumOfTwo(maxWidth, Length(ToString(table[j, i])) + space);
        maxColumWidth[i] := maxWidth
      END;
      
      {
        Prints the table header and sets the column width to a proper width 
        by adding spaces to the string representation of the value to fit intended 
        column width, calculated before
      }
      line := EnhanceStringLength('a / b', 5) + ' | ';
      FOR i := 0 TO cols - 1 DO
        line := line + EnhanceStringLength(ToString(i + 1), maxColumWidth[i]);
      WriteLn(RepeatString('-', Length(line)));
      WriteLn(line);
      WriteLn(RepeatString('-', Length(line)));
            
      {
        Print the table content, where also the string representation of the value 
        will be set to a width to fit the before calculated column width.
      }
      FOR i := 0 TO rows -1 DO BEGIN
        line := EnhanceStringLength(ToString(minA + i), 5) + ' | ';
        FOR j := 0 TO cols - 1 DO 
          line := line + EnhanceStringLength(ToString(table[i, j]), maxColumWidth[j]);
        WriteLn(line)
      END;
      WriteLn(RepeatString('-', Length(line)))
    END;
  END;


VAR
  result: INTEGER;
BEGIN
  {
    Tests for DisplayBFTable
  }
  DisplayBFTable(8, 8);
  DisplayBFTable(8, 13);
  DisplayBFTable(15, 20);
  DisplayBFTable(8, 7);
  DisplayBFTable(21, 30);
END.