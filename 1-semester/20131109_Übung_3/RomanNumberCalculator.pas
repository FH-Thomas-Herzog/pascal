{
  This porgam is used to calculate the roman number representation form
  an arabic number representation and visa versa.
  There are two ways to calculate the roman number representation.
  
  1. With no considering of the subtraction rule
  2. With considering of the subtraction rule.
  3. Conversion of roman to arabic representation with syntax and semantic check
}
PROGRAM RomanNumberCalculator;

{ #################### Type definitions ############################### }
TYPE
  {
    Enumeration Type which specifies the legal roman numbers.
    Used to act as the index for the constant array which holds
    all of the roman numbers with their necessary information
  }
  RomanNumbers = (M, D, C, L, X, V, I);
  {
    Enumeration which specifies the action types which identify the action to be performed on the ValueHolder instance.
  }
  ActionTypes = (ACTION_ROMAN_TO_INT, ACTION_INT_TO_ROMAN_1, ACTION_INT_TO_ROMAN_2, NO_ACTION);
  {
    Enumeration Type which specifies the error codes which can occur during conversion
  }
  ErrorCodes = (INVALID_CHARACTER, INVALID_SEMANTIC, OVERFLOW, NO_ERROR);
  {
    Error Array Type which is used to hold the determined error values
  }
  ErrorArray = ARRAY [ActionTypes] OF ErrorCodes;
  {
    Type which holds the information of a roman number, its corresponding
    arabic number and valid roman number prefix (subtraction rule)
  }
  RomanArabic = RECORD 
    roman: CHAR;
    romanEnum: RomanNumbers;
    arabic: INTEGER;
    romanPrefix: RomanNumbers;
  END;
  {
    ValueHolder type which is used to hold set value and result of the conversion
    and all occurred errors.
  }
  ValueHolder = RECORD
    roman: STRING;
    arabic: LONGINT;
    errors: ErrorArray;
    action: ActionTypes;
    errorMessage: STRING;
  END;
  {
    Array type used for the holding of the valid roman number instances
  }
  RomanArray = ARRAY[RomanNumbers] OF RomanArabic;
  {
    Array type which holds the translated roman string RomanArray instances
  }
  CharToRomanArray = ARRAY OF RomanArabic;


{ #################### Constant definitions ############################### }
CONST
  {
    Array constant to define all valid roman numbers from 
    the highest value to the lowest value.
  }
  romanAsArabicValueArray: RomanArray = (
    (roman: 'M'; romanEnum: M; arabic: 1000; romanPrefix: C),
    (roman: 'D'; romanEnum: D; arabic: 500; romanPrefix: C),
    (roman: 'C'; romanEnum: C; arabic: 100; romanPrefix: X),
    (roman: 'L'; romanEnum: L; arabic: 50; romanPrefix: X),
    (roman: 'X'; romanEnum: X; arabic: 10; romanPrefix: I),
    (roman: 'V'; romanEnum: V; arabic: 5; romanPrefix: I),
    (roman: 'I'; romanEnum: I; arabic: 1; romanPrefix: I)
  );
  {
    Constant which specifies the highest valid arabic number
    which is able to be converted.
  }
  maxArabicValue: INTEGER = 4999;
  {
    Constant which specifies the lowest valid arabic number.
    0 is not allowed to be converted, because there is no 
    roman number for this.
  }
  minArabicValue: INTEGER = 1;
  
  
{ #################### Util Functions and Procedures ############################### }
  {
    Function which creates a ValueHolder instance with the given values.
    This instance will not have any errors set.
    
    @param
        roman: the roman value to set on the ValueHolder instance
    @param
        arabic: the arabic value to be set on the ValueHolder instance
    @return
        the created ValueHolder instance
  }
  FUNCTION CreateValueHolder(roman: STRING; arabic: LONGINT; action: ActionTypes): ValueHolder;
  VAR
    i: ActionTypes;
    holder: ValueHolder;
  BEGIN
    holder.roman := roman;
    holder.arabic := arabic;
    holder.errorMessage := '';
    holder.action := action;
    
    FOR i := Low(holder.errors) TO High(holder.errors) DO 
      holder.errors[i] := NO_ERROR;
    
    CreateValueHolder := holder;
  END;
  
  {
    Converts a integer to a string representation.
    
    @param value:
              the integer to be converted to a string
    @return 
        the string representation of the given integer value
  }
  FUNCTION ToString(value: LONGINT): STRING;
  VAR 
    s: STRING;
  BEGIN
   
    Str(value, s);
    ToString := s
  
  END;
  
  {
    Calculates the ten potency of the given value, which must not be less than zero.
    @param
        value: the value to get container ten potency
    @return
        the ten potency contained by the given value, or -1 if value is less than 0
  }
  FUNCTION GetTensPontency(value: LONGINT): LONGINT;
  VAR
    pot: LONGINT;
    count: INTEGER;
  BEGIN
  
    count := 0;
    pot := 1;
    
    IF value >= 0 THEN BEGIN
      WHILE ((value DIV pot) >= 10) DO BEGIN
        count := count + 1;
        pot := pot * 10
      END;
      GetTensPontency := count;
    END
    ELSE
      GetTensPontency := -1;
    
  END;
  
  {
    Translates the given valid roman string to a array with the corresponding RomanArabic instance set.
    Invalid characters will be ignored, but the array will have a random character set on the missing indexes.
    So be aware to call this function only with a valid roman string.
    
    @param
        roman: the roman string to be translated to an array with its corresponding RomanArabic instances
    @return
        the translated roman string represented by an array with the corresponding ROmanArabic instances set
  }
  FUNCTION TranslateRomanString(roman: STRING): CharToRomanArray;
  VAR
    i: INTEGER;
    j: RomanNumbers;
    romanArabicArray: CharToRomanArray;
  BEGIN
    {
      Set the length of the array to fit character count of roman string
    }
    SetLength(romanArabicArray, Length(roman) + 1);
    {
      Iterate over each character and search for corresponding RomanArabic instances
    }
    FOR i:= 1 TO Length(roman) DO BEGIN
      FOR j := Low(romanAsArabicValueArray) TO High(romanAsArabicValueArray) DO BEGIN
        IF romanAsArabicValueArray[j].roman = roman[i] THEN BEGIN
          romanArabicArray[i] := romanAsArabicValueArray[j];
          BREAK;
        END;
      END;  
    END;
    
    TranslateRomanString := romanArabicArray;
  END;
  
  {
    Function which validates the range of the given 'value'.

    @param 
        value: the value which range shall be validated
    @param 
        bottom: the bottom border of the given 'value'
    @param 
        top: the top border of the given 'value'
    @return 
        true if the value is within the defined borders, false otherwise or if bottom > top
  }
  FUNCTION ValidateRange(value, bottom, top: INTEGER): BOOLEAN;
  BEGIN

    ValidateRange := false;

    IF (bottom <= top) AND (value >= bottom) AND (value <= top) THEN
      ValidateRange := true
          
  END; 
  
  {
    Function which detects an occurred error on the ValueHolder instance.
    An error is detected when at least one array element is set with an
    error not equal to 'NO_ERROR'.
    
    @param
        span: the ValueHolder instance to detect set errors on.
    @return
        true if an error has been detected, false otherwise
  }
  FUNCTION HasErrors(value: ValueHolder): BOOLEAN;
  VAR
    i: ActionTypes;
    code: ErrorCodes;
    error: BOOLEAN;
  BEGIN
  
    error := false;
    i := Low(value.errors);
    code := value.errors[i];
    
    IF code <> NO_ERROR THEN
        error := true;
        
    WHILE (NOT error) AND (i < High(value.errors)) DO BEGIN
      Inc(i);
      code := value.errors[i];
      
      IF code <> NO_ERROR THEN
        error := true;
        
    END;
    
    HasErrors := error;
    
  END;
  
  {
    Function which validates if the given ValueHolder instance contains
    only valid roman characters on its roman attribute.
    
    @param
        value: the given ValuHolder instance to be validated
    @return 
        the ValueHolder instance containing any errors which have occurred.
  }
  FUNCTION ValidateRomanSyntax(value: ValueHolder): ValueHolder;
  VAR
    result: ValueHolder;
    i: INTEGER;
    j: RomanNumbers;
    found: BOOLEAN;
    errorMessage: STRING;
  BEGIN
    
    result := CreateValueHolder(value.roman, value.arabic, NO_ACTION);
    errorMessage := '';
    
    {
      Iterate over each roman character
    }
    IF Length(result.roman) > 0 THEN BEGIN
      FOR i := 1 TO Length(value.roman) DO BEGIN
        found := false;   
        {
          Search for valid roman character
        }
        FOR j := Low(romanAsArabicValueArray) TO High(romanAsArabicValueArray) DO BEGIN
          IF romanAsArabicValueArray[j].roman = value.roman[i] THEN BEGIN
            found := true;
            BREAK;
          END;
        END;

        {
          Build error message with marked errors if current character is no valid roman character.
        }
        IF NOT found THEN BEGIN
          result.errors[result.action] := INVALID_CHARACTER;
          errorMessage := errorMessage + '[' + value.roman[i] + ']'
        END
        ELSE
          errorMessage := errorMessage + value.roman[i];    
      END;    
    END
    ELSE BEGIN
      result.errors[result.action] := INVALID_CHARACTER;
      errorMessage := errorMessage + '[' + value.roman + ']'
    END;
      
    
    {
      Set error message if an error have occurred
    }
    IF result.errors[result.action] <> NO_ERROR THEN
      result.errorMessage := errorMessage;

    ValidateRomanSyntax := result;
    
  END;
  
  
  {
    Function which answers the question if the given RomanArabic instance has a
    lower value then all other RomanArabic instances before the given index
    It has a lower value when the roman number occurs on or after the given index.
    
    @param
        roman: the RomanArabic instance to check for a higher value
    @param
        idx: the idx where to start the comparison to the given instance
    @return 
        true if the given RomanArabic instance has a higher value than all others in the constant array
        started on given idx
  }  
  FUNCTION IsLowerValue(roman: RomanArabic; idx: RomanNumbers):BOOLEAN;
  VAR 
    i: RomanNumbers;
    current: RomanArabic;
  BEGIN
    IsLowerValue := false;

    FOR i := idx TO High(romanAsArabicValueArray) DO BEGIN
      current := romanAsArabicValueArray[i];
      IF current.roman = roman.roman THEN BEGIN
        IsLowerValue := true;
        EXIT;
      END;
    END;
  END;
  
  {
    Function which checks if the given ValueHolder instance contains a roman number with
    a correct syntax.
    It is assumed that the roman string only contains valid roman characters.
    If a incorrect syntax is detected a error will be created and set on the returned 
    ValueHolder instance. Here all following invalid character are marked.
    E.g.: IMDMXLIVI -> I [M] [D] [M] X [L] IV [I]
    
    @param
        value: the ValueHolder instance to check for correct syntax on set roman string.
    @return 
        the ValueHolder instance containing all occurred errors.
  }
  FUNCTION ValidateRomanSemantic(value: ValueHolder): ValueHolder;
    VAR
      result: ValueHolder;
      i, j, count, formerIdx: INTEGER;
      k: 1..2;
      temp: STRING;
      pairFound, error: BOOLEAN;
      romanArabicInst, formerRoman: RomanArabic;
      formerRomanPair: ARRAY[1..2] OF INTEGER;
      romanArabicArray: ARRAY OF RomanArabic;
    BEGIN
      
      {
        Initiate preconditions
      }
      pairFound := false;  
      error := false;  
      result := CreateValueHolder(value.roman, -1, NO_ACTION);       
      romanArabicArray := TranslateRomanString(value.roman);
      formerIdx := 1;
      count := 1;
      
      FOR i := 1 TO High(romanArabicArray) DO BEGIN
        romanArabicInst := romanArabicArray[i];
        
        { Handle former single roman }
        IF i <> 1 THEN BEGIN
          IF NOT pairFound THEN BEGIN
            formerRoman := romanArabicArray[formerIdx];
            IF (IsLowerValue(romanArabicInst, formerRoman.romanEnum)) OR  (formerRoman.roman = romanAsArabicValueArray[romanArabicInst.romanPrefix].roman) THEN BEGIN (* (formerRoman.roman = romanArabicInst.roman) OR *)
              { set detected pair for validation on next step }
              IF (formerRoman.roman = romanAsArabicValueArray[romanArabicInst.romanPrefix].roman) AND (romanArabicInst.roman <> romanAsArabicValueArray[romanArabicInst.romanPrefix].roman) THEN BEGIN
                formerRomanPair[1] := formerIdx;
                formerRomanPair[2] := i;
                (* writeln('pair : ', romanArabicArray[formerRomanPair[1]].roman, '/', romanArabicArray[formerRomanPair[2]].roman);  *)             
                pairFound := true;
              END;
            END
            { Detected error }
            ELSE
              error := true;
          END

          { Handle former detected pair }
          ELSE BEGIN
            {
              Current roman character must not be equal to one of the detected pair.
            }
            FOR k := Low(formerRomanPair) TO High(formerRomanPair) DO BEGIN
              formerRoman := romanArabicArray[formerRomanPair[k]];
              IF (NOT IsLowerValue(romanArabicInst, romanArabicArray[formerRomanPair[k]].romanEnum)) OR (formerRoman.roman = romanArabicInst.roman) THEN BEGIN
                error := true; 
                (* writeln('paired error: ', romanArabicInst.roman);*)
                BREAK;
              END;
            END;
            { If error has been detected compare pair to following roman }
            IF NOT error THEN BEGIN
              (* writeln('no error: ', romanArabicInst.roman);*)
              pairFound := false;
            END;
          END;

        END;
        
        { Handle multiple following same roman (max 4 occurrences allowed) }
        IF NOT error THEN BEGIN
          count := 0;
          temp := '[';
          { Search for same occurrences and build error string }
          FOR j := i TO High(romanArabicArray) DO BEGIN
            IF romanArabicInst.roman = romanArabicArray[j].roman THEN BEGIN
              count := count + 1;
              temp := temp + romanArabicInst.roman;
            END
            ELSE
              BREAK;
          END;
          { If to much found set proper message and set idx of last element which is the next after current.roman }
          IF count > 4 THEN BEGIN
            temp := temp + ']';
            result.errorMessage := result.errorMessage + temp;
            Dec(j);
            i := j;
            error := true;
          END;
        END;
        
        { Handle detected error }
        IF error THEN BEGIN
          error := false;
          result.errors[result.action] := INVALID_SEMANTIC;
          { If no multiple occurrences have been occurred mark current error }
          IF count < 5 THEN BEGIN
            result.errorMessage := result.errorMessage + '[' + romanArabicInst.roman + ']';
          END;
        END
        ELSE BEGIN
          { Add valid roman to error message }
          result.errorMessage := result.errorMessage + romanArabicInst.roman;
        END;
        { preconditions for next step }
        formerIdx := i;
        count := 1;
      END;
      
      ValidateRomanSemantic := result;
      
  END;
  
  {
    Gets the current roman representation of the given value for the given valid roman
    number. If the current roman does not fit for this value an empty string is returned.
    
    @param
        araic: the arabic number to get the proper roman number for
    @param
        idx: the current index of the RomanNumbersArray to check if this roman number fits the
             given arabic value
    @return
        rest: the rest of the arabic number, means given arabic - calculated roman number/arabic value
        roman: the roman number if the current roman number fits, an empty string otherwise
  }
  PROCEDURE GetCurrentRoman(arabic: LONGINT; idx: RomanNumbers; VAR rest: LONGINT; VAR roman: STRING);
  VAR
    romanArabicInst: RomanArabic;
    temp, i: INTEGER;
  BEGIN
  
    { Initiate preconditions }
    romanArabicInst := romanAsArabicValueArray[idx];
    rest := arabic;
    roman := '';
    
    {
      Search for proper roman character which can be used for a part of the given arabic value
    }
    IF arabic >= romanArabicInst.arabic THEN BEGIN
      temp := arabic DIV romanArabicInst.arabic;

      if temp > 0 THEN
        FOR i := 1 TO temp DO
          roman := roman + romanArabicInst.roman;

      rest := arabic - (temp *  romanArabicInst.arabic);
    END;
  END;
  
  {
    Gets the roman representation for the given arabic number.
    The subtraction rule is not considered here.
    
    @param
        arabic: the arabic number to be converted
    @return
        the calculated roman representation represented by a string
  }
  FUNCTION IntToRoman(value: ValueHolder): ValueHolder;
  VAR
    i: RomanNumbers;
    currentRoman: STRING;
    first: BOOLEAN;
    result: ValueHolder;
  BEGIN
  
    { Init preconditions }
    first := true;
    
    result := CreateValueHolder('', value.arabic, value.action);
    
    { Check for border overflow }
    IF ValidateRange(result.arabic, minArabicValue, maxArabicValue) THEN BEGIN
      i := LOW(romanAsArabicValueArray);

      WHILE (i <= High(romanAsArabicValueArray)) AND (result.arabic > 0) DO BEGIN
        IF NOT first THEN
          Inc(i);
          
        { Calculate next roman character which fits current arabic number }
        GetCurrentRoman(result.arabic, i, result.arabic, currentRoman);
        result.roman := result.roman + currentRoman;

        first := false;

      END;
    END
    { Add error if border overflows }
    ELSE BEGIN
      result.errors[value.action] := OVERFLOW;
      result.errorMessage := 'The given arabic value overflows borders: min ' + ToString(minArabicValue) + ' / max: ' + ToString(maxArabicValue);
    END;
    
    result.arabic := value.arabic;
    IntToRoman := result;
      
  END;
  
  {
    Gets the roman representation for the given arabic number.
    The subtraction rule is considered here.
    
    @param
        arabic: the arabic number to be converted
    @return
        the ValueHolder instance containing the result or all occurred errors
  }
  FUNCTION IntToRoman2(value: ValueHolder): ValueHolder;
  VAR
    i: RomanNumbers;
    j, temp, potValue: INTEGER;
    currentRoman: STRING;
    first, substractionDone: BOOLEAN;
    result: ValueHolder;
  BEGIN
  
    {
      Initiate preconditions
    }
    result :=  CreateValueHolder('', value.arabic, value.action);
    first := true;
    i := LOW(romanAsArabicValueArray);
   
    {
      Validate arabic set borders
    }
    IF ValidateRange(result.arabic, minArabicValue, maxArabicValue) THEN BEGIN
      {
        Iterate from highest to lowest roman number and try to get proper arabic representation
      }
      WHILE (i <= High(romanAsArabicValueArray)) AND (result.arabic > 0) DO BEGIN
        IF NOT first THEN
          Inc(i);

        first := false;
        substractionDone := false;

        { 
          Check for subtraction rule 
        }
        IF i > Low(RomanNumbers) THEN BEGIN
          Dec(i);
          potValue := 1;
          { Calculate roman representation with subtraction rule }
          FOR j := 1 TO GetTensPontency(result.arabic) DO
            potValue := potValue * 10;
          temp := (result.arabic DIV potValue) * potValue;
          IF (romanAsArabicValueArray[i].arabic - romanAsArabicValueArray[romanAsArabicValueArray[i].romanPrefix].arabic = temp) THEN BEGIN
            result.roman := result.roman + romanAsArabicValueArray[romanAsArabicValueArray[i].romanPrefix].roman + romanAsArabicValueArray[i].roman;
            result.arabic := result.arabic - temp;
            substractionDone := true;
          END; 
          Inc(i);
        END;
        
        {
          Normal roman representation resolving 
        }
        IF NOT substractionDone THEN BEGIN
          GetCurrentRoman(result.arabic, i, result.arabic, currentRoman);
          result.roman := result.roman + currentRoman;
        END;

      END;

    END
    { Handle border overflow }
    ELSE BEGIN
      result.errors[result.action] := OVERFLOW;
      result.errorMessage := 'The given arabic value overflows borders: min ' + ToString(minArabicValue) + ' / max: ' + ToString(maxArabicValue);
    END;
      
    result.arabic := value.arabic;
    IntToRoman2 := result;
  END;
  
  {
    Function which calculates the arabic representation out of a roman 
    number representation. 
    This function can handle roman representations with subtraction rule
    contained, or not or mixed.
    
    @param 
        valueHolder: the ValueHolder instance to retrieve value from
    @return
        A ValueHolder instance which contains the calculated arabic value and all occurred errors.
  }
  FUNCTION RomanToInt(value: ValueHolder): ValueHolder;
  VAR
    i: INTEGER;
    result: ValueHolder;
    current, next: RomanArabic;
    add: BOOLEAN;
    romanArabicArray: ARRAY OF RomanArabic;
  BEGIN
      
    {
      Validate for valid characters and syntax
    }
    result := ValidateRomanSyntax(value);     
    IF NOT HasErrors(result) THEN
      result := ValidateRomanSemantic(result);
    
    {
      Initiate preconditions
    }
    add := false;
    result.arabic := 0;
    
    {
      Convert if no error occurred during validation
    }
    IF NOT HasErrors(result) THEN BEGIN
      {
        Translate string to RomanArabic instance array
      }
      romanArabicArray := TranslateRomanString(result.roman);
      FOR i := 1 TO High(romanArabicArray) DO BEGIN
        {
          Calculate with subtraction rule considered.
        }
        current := romanArabicArray[i];
        (*writeln('i: ', i , ' roman ', current.arabic);*)
        IF i < High(romanArabicArray) THEN BEGIN
          next := romanArabicArray[(i + 1)];
          IF (romanAsArabicValueArray[next.romanPrefix].roman = current.roman) AND (romanAsArabicValueArray[next.romanPrefix].roman <> next.roman) THEN BEGIN
            result.arabic := result.arabic + (next.arabic - current.arabic);
            Inc(i);
          END
          ELSE
            add := true;
        END
        ELSE
          add := true;

        {
          Calculate plain roman numbers
        }
        IF add THEN BEGIN
          add := false;
          result.arabic := result.arabic + current.arabic;
        END;
        
        {
          Validate if result overflows max representable arabic value
        }
        IF result.arabic > maxArabicValue THEN BEGIN
          result.errors[value.action] := OVERFLOW;
          result.arabic := 0;
          result.errorMessage := 'Roman String overflows maxValue "'+ ToString(maxArabicValue) + '" !!!'; 
        END;
        
        
      END; 
    END;
    
    RomanToInt := result;
  END;
 
  {
    Procedure for testing the main functions.
    This procedure ahndles the occurres error and prints them to the cosnole.
    
    @param
        value: the ValueHolder instance to use for the test
  }
  PROCEDURE Test(value: ValueHolder);
  VAR
    validAction: BOOLEAN;
    result: ValueHolder;
  BEGIN
  
    validAction := true;
    WriteLn('------------------------------------------');  
    
    IF value.action = ACTION_ROMAN_TO_INT THEN
      result := RomanToInt(value)
    ELSE IF value.action = ACTION_INT_TO_ROMAN_1 THEN
      result := IntToRoman(value)
    ELSE IF value.action = ACTION_INT_TO_ROMAN_2 THEN
      result := IntToRoman2(value)
    ELSE
      validAction := false;

    IF validAction THEN BEGIN
      WriteLn('Action           : ', result.action);  
      WriteLn('Rroman           : ', result.roman);  
      WriteLn('Arabic           : ', result.arabic);  
      IF HasErrors(result) THEN BEGIN
       WriteLn('Error Code       : ', result.errors[result.action]);    
        WriteLn('Error message    : ', result.errorMessage);  
      END
    END;
    
    WriteLn('------------------------------------------');  
  END;

BEGIN 

  WriteLn('');
  WriteLn('########### IntToRoman ###################');
  Test(CreateValueHolder('', 0, ACTION_INT_TO_ROMAN_1));
  Test(CreateValueHolder('', 5000, ACTION_INT_TO_ROMAN_1));
  Test(CreateValueHolder('', 4999, ACTION_INT_TO_ROMAN_1));
  Test(CreateValueHolder('', 1000, ACTION_INT_TO_ROMAN_1));
  Test(CreateValueHolder('', 500, ACTION_INT_TO_ROMAN_1));
  Test(CreateValueHolder('', 999, ACTION_INT_TO_ROMAN_1));
  
  WriteLn('');
  WriteLn('########### IntToRoman2 ##################');
  { Invalid values } 
  Test(CreateValueHolder('', 0, ACTION_INT_TO_ROMAN_2));
  Test(CreateValueHolder('', 5000, ACTION_INT_TO_ROMAN_2));
  Test(CreateValueHolder('', 4999, ACTION_INT_TO_ROMAN_2));
  Test(CreateValueHolder('', 1000, ACTION_INT_TO_ROMAN_2));
  Test(CreateValueHolder('', 500, ACTION_INT_TO_ROMAN_2));
  Test(CreateValueHolder('', 999, ACTION_INT_TO_ROMAN_2));
  
  WriteLn('');
  WriteLn('########### RomanToInt ##################');
  { Invalid roman count } 
  WriteLn('----------- Invalid characters -----------');
  Test(CreateValueHolder('', 0, ACTION_ROMAN_TO_INT));
  Test(CreateValueHolder(' MM12MXX ', 0, ACTION_ROMAN_TO_INT));
  WriteLn('----------- Invalid roman count ----------');
  Test(CreateValueHolder('MMMMMCMXCIX', 0, ACTION_ROMAN_TO_INT));
  Test(CreateValueHolder('MMMMCMXXXXXIV', 0, ACTION_ROMAN_TO_INT));
  Test(CreateValueHolder('CMXLVVVVVIIII', 0, ACTION_ROMAN_TO_INT));
  WriteLn('----------- Invalid pair -----------------');
  Test(CreateValueHolder('CMCDVI', 0, ACTION_ROMAN_TO_INT));
  Test(CreateValueHolder('MMMMCMCDXXXXIV', 0, ACTION_ROMAN_TO_INT));
  WriteLn('----------- Mixed ------------------------');
  Test(CreateValueHolder('CMCDXXXXXIVIIIII', 0, ACTION_ROMAN_TO_INT));
  WriteLn('----------- Correct behavior -------------');
  Test(CreateValueHolder('MMMMXLIV', 0, ACTION_ROMAN_TO_INT));
  Test(CreateValueHolder('MMMMCMXLIIII', 0, ACTION_ROMAN_TO_INT));
  Test(CreateValueHolder('MMMMXXXXVVVVIIII', 0, ACTION_ROMAN_TO_INT));
  Test(CreateValueHolder('MMMMXXXXVVVV', 0, ACTION_ROMAN_TO_INT));
  
END.
