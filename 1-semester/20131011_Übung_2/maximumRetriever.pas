{
  This program contains three functions which are used
  to get the maximum of several numbers.
  
  Contained functions:
  -----------------------------------------
  1. Max2(first, second: INTEGER): INTEGER;
     Gets the maximum of two numbers.
  
  2. Max3a(first, second, third: INTEGER): INTEGER;
     Gets the maximum of three numbers.
      
  3. Max3b(first, second, third: INTEGER): INTEGER;
     Gets the maximum of three numbers by reusing the function 'Max3a'.
}
PROGRAM MaximumRetriever;

  {
    Function which gets the maximum of two numbers.
    @param first:
                the first number for the maximum retrieval 
    @param second:
                the second number for the maximum retrieval 
    @return 
          the maximum of the two given numbers
  }
  FUNCTION Max2(first, second: INTEGER): INTEGER;
  BEGIN
    IF first > second THEN
      Max2 := first
    ELSE
      Max2 := second
  END;
  
  {
    Function which gets the maximum of three numbers.
    @param first: 
                the first number for the maximum retrieval 
    @param second: 
                the second number for the maximum retrieval 
    @param third: 
                the third number for the maximum retrieval 
    @return 
          the maximum of the three given numbers
  }
  FUNCTION Max3a(first, second, third: INTEGER): INTEGER;
  VAR
    temp: INTEGER;
  BEGIN
    {
      Copy result of the first comparison to 'temp' which represents 
      the maximum of the first two numbers.
      This result gets later compared to 'third' to get the maximum of 'temp' and 'third'.
    }
    IF first > second THEN
      temp := first
    ELSE
      temp := second;
      
    IF temp > third THEN
      Max3a := temp
    ELSE
      Max3a := third
  END;
  
    
  {
    Function which gets the maximum of three numbers, by reusing the function Max3a.
    @param first: 
                the first number for the maximum retrieval 
    @param second: 
                the second number for the maximum retrieval 
    @param third: 
                the third number for the maximum retrieval 
    @return 
          the maximum of the three given numbers
    @see
        Max2(first, second: INTEGER): INTEGER
        Function which gets the maximum of two numbers
  }
  FUNCTION Max3b(first, second, third: INTEGER): INTEGER;
  BEGIN
    Max3b := Max2(Max2(first, second), third)
  END;

BEGIN
  {
    Tests for function Max2
  }
  WriteLn('--------------------------------------');
  WriteLn('1. Test for Max2: first: 10 / second: 13');
  WriteLn('Maximum: ', Max2(10, 13));
  WriteLn('--------------------------------------');
  WriteLn('2. Test for Max2: first: 13 / second: 10');
  WriteLn('Maximum: ', Max2(13, 10));
  WriteLn('--------------------------------------');
  WriteLn('3. Test for Max2: first: 10 / second: 10');
  WriteLn('Maximum: ', Max2(10, 10));
  WriteLn('--------------------------------------');
  WriteLn('3. Test for Max2: first: -10 / second: -20');
  WriteLn('Maximum: ', Max2(-10, -20));
  WriteLn('--------------------------------------');
  
  {
    Tests for function Max3a
  }
  WriteLn();
  WriteLn('--------------------------------------');
  WriteLn('1. Test for Max3a: first: 10 / second: 13 / third: 4');
  WriteLn('Maximum: ', Max3a(10, 13, 4));
  WriteLn('--------------------------------------');
  WriteLn('3. Test for Max3a: first: 4 / second: 10 / third: 13');
  WriteLn('Maximum: ', Max3a(4, 10, 13));
  WriteLn('--------------------------------------');
  WriteLn('2. Test for Max3a: first: 10 / second: 10 / third: 4');
  WriteLn('Maximum: ', Max3a(10, 10, 4));
  WriteLn('--------------------------------------');
  WriteLn('2. Test for Max3a: first: 10 / second: 10 / third: 10');
  WriteLn('Maximum: ', Max3a(10, 10, 10));
  WriteLn('--------------------------------------');
  WriteLn('2. Test for Max3a: first: -10 / second: -3 / third: -10');
  WriteLn('Maximum: ', Max3a(-10, -3, -10));
  WriteLn('--------------------------------------');
  
  {
    Tests for function Max3b
  }
  WriteLn();
  WriteLn('--------------------------------------');
  WriteLn('1. Test for Max3b: first: 10 / second: 13 / third: 4');
  WriteLn('Maximum: ', Max3b(10, 13, 4));
  WriteLn('--------------------------------------');
  WriteLn('3. Test for Max3b: first: 4 / second: 10 / third: 13');
  WriteLn('Maximum: ', Max3b(4, 10, 13));
  WriteLn('--------------------------------------');
  WriteLn('2. Test for Max3b: first: 10 / second: 10 / third: 4');
  WriteLn('Maximum: ', Max3b(10, 10, 4));
  WriteLn('--------------------------------------');
  WriteLn('2. Test for Max3b: first: 10 / second: 10 / third: 10');
  WriteLn('Maximum: ', Max3b(10, 10, 10));
  WriteLn('--------------------------------------');
  WriteLn('2. Test for Max3b: first: -10 / second: -3 / third: -10');
  WriteLn('Maximum: ', Max3b(-10, -3, -10));
  WriteLn('--------------------------------------');
END. 