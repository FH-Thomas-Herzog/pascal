{
  This program calculates two sums over an open array where the used index
  does not matter for the ComputeSums function.
}
PROGRAM Summarizer;

  TYPE
    {
      Type whih specifies the index for a array with length of 7;
    }
    IntegerIDx1To7 = 1..7;
    {
      Specifies an array of (long)integer type which uses the index type 'IntegerIDx1To7'
    }
    ArrayWithIntegerIdx1To7 = ARRAY[IntegerIDx1To7] OF LONGINT;
    {
      Enumeration which gets used as index for an array
    }
    EnumIdx = (FIRST, SECOND, THRID, FOURTH, FIFTH);
    {
      Summary record which is used to hold the calculated values.
    }
    Summary = RECORD
      countGreater: LONGINT;
      countSmaller: LONGINT;
    END;
    
  {
    Function which calculates two sums over all numbers contained in the given 'numbers' array,
    as long as the current value is not equal to '0'.
    
    @param
        numbers: the array of (long)integers to build sum
    @return
        the Summary containing the builded summaries
  }
  FUNCTION ComputeSums(numbers: ARRAY OF LONGINT): Summary;
  VAR
    i, first, value: LONGINT;
    summaryHolder: Summary;
  BEGIN
  
    {
      Init the variables each time the procedure gets invoked.
      Get first 'value', set 'first' with 'value', increase i and add 'value' to countGreater sum
    }
    i := Low(numbers);
    summaryHolder.countSmaller := 0;
    summaryHolder.countGreater := 0;
    first := numbers[i];
      
    {
      Start at second element because first has already been handled.
    }
    WHILE (value <> 0) AND (i <= High(numbers)) DO BEGIN
       
      value := numbers[i]; 
      
      IF value > 0 THEN BEGIN
        IF value >= first THEN 
          summaryHolder.countGreater := summaryHolder.countGreater + value
        ELSE
          summaryHolder.countSmaller := summaryHolder.countSmaller + value
      END;
      
      Inc(i);
      
    END;

    ComputeSums := summaryHolder;
    
  END;

  {
    Tests the ComputeSum function, by printing the given values and results to the console
    and if intended generates random values for the given array of numbers.
    If the array is intended to be filled with random numbers then at the middle of the array
    a zero will be added, so that the COmputeSum method will have to stop there.
    
    @param
        numbers: the array of (long)integers to build sum over it, or generates random values 
                 for this array if fillRandom is set to true
    @param
        fillRandom: true if random values shall be generated for the array.
  }
  PROCEDURE Test(numbers: ARRAY OF LONGINT; fillRandom: BOOLEAN);
  VAR
    i, middleBorder: LONGINT;
    summaryHolder: Summary;
    print: BOOLEAN;
  BEGIN
  
    print := true;
    WriteLn('Given array of numbers: ');
    middleBorder := High(numbers) DIV 2;
    FOR i := Low(numbers) TO High(numbers) DO BEGIN
      IF fillRandom THEN
        IF middleBorder = i THEN
          numbers[i] := 0
        ELSE
          numbers[i] := Random(High(numbers)) + 1;
      IF print THEN BEGIN
        Write(numbers[i]);
        IF i < High(numbers) THEN
          Write(', ');
        IF numbers[i] = 0 THEN BEGIN
          print := false;
          IF i < High(numbers) THEN BEGIN
            WriteLn('');
            WriteLn('## stoped print on 0, but values are following ##');
          END;
          BREAK;
        END;
      END;
    END;
    
    summaryHolder := ComputeSums(numbers);
    WriteLn('');
    WriteLn('');
    WriteLn('Sum A: ', summaryHolder.countGreater, ' / Sum B: ', summaryHolder.countSmaller);
    WriteLn('-------------------------------------------------------');
    WriteLn('');
    
  END;

{
  Some arrays with different indexes and values for the tests.
}  
CONST
    arrayIntegerIdxSingleZero: ARRAY[1..1] OF LONGINT = (0);
    arrayIntegerIdxNoZero: ArrayWithIntegerIdx1To7 = (1,2,3,4,5,6,7);
    arrayIntegerIdxMidZero: ArrayWithIntegerIdx1To7 = (5,4,6,3,0,4,5);
    arrayIntegerIdxEndZero: ArrayWithIntegerIdx1To7 = (1,2,3,4,5,6,0);

{
  Some array with different indexes which are supposed to be filled before used for the test.
}
VAR  
    arrayInteger1To7Idx: ArrayWithIntegerIdx1To7;
    arrayEnumIdx: ARRAY[EnumIdx] OF LONGINT;
    arrayByteIdx: ARRAY[BYTE] OF LONGINT;
    arrayCharIdx: ARRAY[CHAR] OF LONGINT;
    
BEGIN

  { Fixed numbers }
    WriteLn('-------------------------------------------------------');
  WriteLn('Index type: 1..1');
  Test(arrayIntegerIdxSingleZero, false);
    WriteLn('-------------------------------------------------------');
  WriteLn('Index type: 1..7');
  Test(arrayIntegerIdxNoZero, false);
    WriteLn('-------------------------------------------------------');
  WriteLn('Index type: 1..7');
  Test(arrayIntegerIdxMidZero, false);
    WriteLn('-------------------------------------------------------');
  WriteLn('Index type: 1..7');
  Test(arrayIntegerIdxEndZero, false);
  
  { Random numbers }
    WriteLn('-------------------------------------------------------');
  WriteLn('Index type: 1..7 || random: true');
  Test(arrayInteger1To7Idx, true);
    WriteLn('-------------------------------------------------------');
  WriteLn('Index type: EnumIdx || random: true');
  Test(arrayEnumIdx, true);
    WriteLn('-------------------------------------------------------');
  WriteLn('Index type: BYTE || random: true');
  Test(arrayByteIdx, true);
    WriteLn('-------------------------------------------------------');
  WriteLn('Index type: CHAR || random: true');
  Test(arrayCharIdx, true);
  
  { All zero or undefined values }
    WriteLn('-------------------------------------------------------');
  WriteLn('Index type: BYTE || not initialized');
  Test(arrayByteIdx, false);
    WriteLn('-------------------------------------------------------');
  WriteLn('Index type: INTEGER || not initialized');
  Test(arrayCharIdx, false);
  
END.