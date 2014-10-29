{
  This program is the refactored program of TimeConverter.
  It uses now custom spezified Types and not plain attributes anymore.
  For the made changes please see interface documentation.
}
PROGRAM TimeConverter;

  { #################### Type definitions #################### }
  TYPE
  
    {
      Enumeration which specifies the errors which can occur during an action invocation.
      These enumerations are used to identify the occurred errors during the error handling.
      The TimeSpan instance will hold any error which has occurred during an action invocation.
    }
    ErrorCodes = (NO_ERROR, INVALID_SECONDS, INVALID_MINUTES, INVALID_HOURS, SECOND_OVERFLOW);
    
    {
      This enumeration specifies the actions which can be performed on the TimeSpan instance.
      These enumerations are set on the TimeSpan instance to indicate which action shall be performed
      on this instance, to get a proper result.
    }
    ActionType = (NO_CONVERSION, TIME_TO_SECOND, SECOND_TO_TIME, CALC_DIFFERENCE);
    
    {
      Enumeration which specifies the possible error types and is used to act as an array index.
      These enumerations are used to identify the type of error.
      This means it indicates on which value the error has occurred.
    }
    ErrorType = (HOUR, MINUTE, SECOND, OVERFLOW);
    {
      Enumeration which specifies the types of the time constants and is used to act as an array index.
      These enumerations specify the time attributes which do have constants settings.
    }
    TimeConstantType = (HOURS_PER_DAY, MINUTES_PER_HOUR, SECONDS_PER_MINUTE);
    
    {
      Enumeration which specifies the types of the seconds hold by the TimeSpan instance.
      It acts as an array index, and is used to identify the before and after seconds during the error handling
      when calculate time difference action is performed.
    }
    SecondType = (BEFORE_TIME, AFTER_TIME);
    
    {
      The array type which specifies an array with an index of the type 'TimeConstantType'
      Holds every time constants used for the conversion actions.
    }
    TimeConstantArray = ARRAY [TimeConstantType] OF INTEGER;
    
    {
      The array type which specifies an array with an index of the type 'SecondType'.
      Holds the before and after seconds used for the error handling during calculate time difference action invocation.
    }
    SecondArray = ARRAY [SecondType] OF LONGINT;
    
    {
      The array type which specifies an array with an index of the type 'ErrorType'
      Holds the occurred errors which can occur during an action invocation.
    }
    ErrorArray = ARRAY [ErrorType] OF ErrorCodes;
    
    {
      Record which holds the information of the time representations.
      Acts as the data object used for all of the specified and implemented actions.
    }
    TimeSpan = RECORD
        hour: INTEGER;
        minute: INTEGER;
        second: INTEGER;
        timeInSeconds: LONGINT;
        secondsArray: SecondArray;
        actionType: ActionType;
        errorArray: ErrorArray;
    END;
  

  { #################### Constant definitions #################### }
  {
    Constants which define the time constants. 
    The values are accessible via the 'TimeConstantType' enum values acting as the index of this array type.
    These constants are used for the time conversion actions.
    ATTENTION: The order of the values must fit the 'TimeConstantType' enumeration specification.
  }
  CONST
    timeConstant: TimeConstantArray = (24, 60,60);


  { #################### Helper Functions and Procedures #################### }
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
     This function is used to initiate the TimeSpan instance with the given values for the defined attributes.
     The 'errorArray' will be set to 'NO_ERROR' by default.
  
     @param
        h: the hour to be set on the instance
     @param
        m: the minute to be set on the instance
     @param
        s: the second to be set on the instance
     @param
        timeInSeconds: the second representation to be set on the instance
     @param
        actionType: the action type to be set on the instance
     @return
         the instantiated TimeSpan instance
   }
   FUNCTION InitTimeSpan(h, m, s: INTEGER; timeInSeconds: LONGINT; actionType: ActionType): TimeSpan;
   VAR
      i: ErrorType;
      j: SecondType;
      span: TimeSpan;
   BEGIN

      span.hour := h;
      span.minute := m;
      span.second := s;
      span.timeInSeconds := timeInSeconds;
      span.actionType := actionType;

      FOR i := Low(span.errorArray) TO High(span.errorArray) DO
        span.errorArray[i] := NO_ERROR;

      FOR j := Low(span.secondsArray) TO High(span.secondsArray) DO
        span.secondsArray[j] := 0;
        
      InitTimeSpan := span;

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
    Function which detects an occurred error on the TimeSpan instance.
    An error is detected when at least one array element is set with an
    error not equal to 'NO_ERROR'.
    
    @param
        span: the TimeSpan instance to detect set errors on.
    @return
        true if an error has been detected, false otherwise
  }
  FUNCTION HasErrors(span: TimeSpan): BOOLEAN;
  VAR
    i: ErrorType;
    code: ErrorCodes;
    error: BOOLEAN;
  BEGIN
  
    error := false;
    i := Low(span.errorArray);
    code := span.errorArray[i];
    IF code <> NO_ERROR THEN
        error := true;
    
    WHILE (NOT error) AND (i < High(span.errorArray)) DO BEGIN
      Inc(i);
      code := span.errorArray[i];
      
      IF code <> NO_ERROR THEN
        error := true;
        
    END;
    
    HasErrors := error;
    
  END;
  
  {
    Function to handle any error occurred on an action invocation and set on the given TimeSpan instance.
    
    @param 
        span: the TimeSpan instance on which an action was performed and which could have any errors set.
    @return 
        the proper error message depending if errors were set on the TimeSpan instance.
    @changes
        This function now handles all of the occurred errors and displays them to the console.
        Formerly only the first detected error was handled.
  }
  FUNCTION HandleErrors(span: TimeSpan): STRING;
  VAR
    errors: STRING;
  BEGIN
  
    errors := '';
    HandleErrors := 'No error detected';
    
    IF HasErrors(span) THEN BEGIN
      {
        Get errors for 'TIME_TO_SECOND' conversion type
      }
      IF ((span.actionType = CALC_DIFFERENCE) OR (span.actionType = TIME_TO_SECOND)) AND (span.errorArray[OVERFLOW] <> SECOND_OVERFLOW) THEN BEGIN
        IF span.errorArray[HOUR] = INVALID_HOURS THEN
          errors := errors + '[' + ToString(span.hour) + ']:'
        ELSE
          errors := errors + ToString(span.hour) + ':';
        IF span.errorArray[MINUTE] = INVALID_MINUTES THEN
          errors := errors + '[' + ToString(span.minute) + ']:'
        ELSE
          errors := errors + ToString(span.minute) + ':';
        IF span.errorArray[SECOND] = INVALID_SECONDS THEN
          errors := errors + '['+ ToString(span.second) + ']'
        ELSE
          errors := errors + ToString(span.second) + '';
      END;
      {
        Get error for 'SECOND_TO_TIME'
      }
      IF (span.actionType = SECOND_TO_TIME) AND (span.errorArray[SECOND] = INVALID_SECONDS) THEN
        errors := errors + '[' + ToString(span.timeInSeconds) + ']';
      {
        Get the error for 'CALC_DIFFERENCE' 
      }
      IF (span.actionType = CALC_DIFFERENCE) AND (span.errorArray[OVERFLOW] = SECOND_OVERFLOW) THEN
        errors := errors + 'Overflow. before: ' + ToString(span.secondsArray[BEFORE_TIME]) + ' | after: ' + ToString(span.secondsArray[AFTER_TIME]);

      HandleErrors := 'One or more errors have been detected. ' + errors;       
    
    END;
  END;
  
  { #################### Action Functions and Procedures #################### }
  {
    Function which converts the 'timeInSeocnds' set on the given TimeSpan instance to hour, minute and second values, which will be set on the returned TimeSpan instance.
    
    @param 
        span: the TimeSpan instance which holds the to convert seconds
    @return 
        the TimeSpan instance containing the calculated time representation of the set 'timeInSeconds' value
    @changes
        Formerly this function was a procedure and this procedure had formal parameters for the timeInSeoonds and each calculated value to be returned. 
        Now all values are provided by the given TimeSpan instance and the result will be set on this instance as well. 
        This is the reason why this is now an function and not a procedure anymore.
  }
  FUNCTION SecondsToTimeSpan(span: TimeSpan): TimeSpan;
  BEGIN
  
    IF span.timeInSeconds > 0 THEN BEGIN
      span.hour := span.timeInSeconds DIV (timeConstant[SECONDS_PER_MINUTE] * timeConstant[MINUTES_PER_HOUR]);
      span.minute := (span.timeInSeconds - (span.hour * (timeConstant[SECONDS_PER_MINUTE] * timeConstant[MINUTES_PER_HOUR]))) DIV timeConstant[MINUTES_PER_HOUR];
      span.second := (span.timeInSeconds - (span.hour * (timeConstant[SECONDS_PER_MINUTE] * timeConstant[MINUTES_PER_HOUR])) - (span.minute * timeConstant[MINUTES_PER_HOUR]));
    END
    ELSE
      span.errorArray[SECOND] := INVALID_SECONDS;

    SecondsToTimeSpan := span;
      
  END;
    
  {
    Function which calculates the second representation of the given time 'hh:mm:ss' set on the TimeSpan instance.
    
    @param 
        span: the TimeSpan instance which holds the time representation.
    @return 
        the TimeSpan instance with the set calculated 'timeInSeconds' value or any occurred errors set on 'errorArray'
    @see ValidateRange(value, range: INTEGER): BOOLEAN;
    @see CONST at program head
        timeConstant Array with all used time constants
    @changes
        Formerly this function had formal parameters for all time values and returned the calculated seconds.
        Also this function was only able to detect one error, because only one error was handleable.
        The error was saved on the returned second value with a value less then zero.
        No all needed time values are hold by the given TimeSpan instance and also the result or all occurred errors
        are set on the returned TimeSpan instance.
  }
  FUNCTION TimeSpanToSeconds(span: TimeSpan): TimeSpan;
  BEGIN
    
    IF span.hour < 0 THEN
      span.errorArray[HOUR] := INVALID_HOURS;
    IF NOT ValidateRange(span.minute, 0, (timeConstant[MINUTES_PER_HOUR] - 1)) THEN 
      span.errorArray[MINUTE] := INVALID_MINUTES;
    IF NOT ValidateRange(span.second, 0, (timeConstant[SECONDS_PER_MINUTE] - 1)) THEN
      span.errorArray[SECOND] := INVALID_SECONDS;
    
    IF NOT HasErrors(span) THEN
      span.timeInSeconds := (span.hour * timeConstant[MINUTES_PER_HOUR] * timeConstant[SECONDS_PER_MINUTE]) + (span.minute * timeConstant[SECONDS_PER_MINUTE]) + span.second;
              
    TimeSpanToSeconds := span;

  END;
  
  {
    Procedure which calculates the time difference in seconds between the two given TimeSpan 
    instances.
    
    @param
        before: the TimeSpan instance representing the lower time value
    @param
        after: the TimeSpan instance representing the higher time value
    @return 
        calcResult: the TimeSpan instance which holds the calculated time difference, or the set error
                    which would occur if 'before TimeSpan ' has a second value which is after the 'after TimeSpan' second value.
        beforeResult: the before TimeSpan instance which holds the result or any occurres errors during seocnd conversion
        beforeResult: the after TimeSpan instance which holds the result or any occurres errors during seocnd conversion
  }
  PROCEDURE TimeDifference(before, after:TimeSpan; VAR beforeResult, afterResult, calcResult:TimeSpan);
  BEGIN
    calcResult := InitTimeSpan(0,0,0,0, CALC_DIFFERENCE);
    beforeResult := TimeSpanToSeconds(before);
    afterResult := TimeSpanToSeconds(after);
    calcResult.secondsArray[BEFORE_TIME] := beforeResult.timeInSeconds;
    calcResult.secondsArray[AFTER_TIME] := afterResult.timeInSeconds;
    
    IF (NOT HasErrors(beforeResult)) AND (NOT HasErrors(afterResult)) THEN BEGIN
      IF beforeResult.timeInSeconds <= afterResult.timeInSeconds THEN
        calcResult.timeInSeconds := afterResult.timeInSeconds - beforeResult.timeInSeconds
      ELSE
        calcResult.errorArray[OVERFLOW] := SECOND_OVERFLOW;
    END;
  END;

  { #################### Test Procedures #################### }
  {
    Procedure to test the Function TimeSpanToSeconds.
    Prints the result or the error to the console.
    
    @param 
        span: the TimeSpan instance which holds the to convert time representation
    @changes
        This procedure now works with the TimeSpan instance and not with the formerly given time values.
  }
  PROCEDURE TestTimeSpanToSeconds(span: TimeSpan);
  BEGIN
  
    span := TimeSpanToSeconds(span); 
    WriteLn('Time: ', span.hour, ':', span.minute, ':', span.second, ' / ');

    IF HasErrors(span) THEN
      WriteLn(HandleErrors(span))
    ELSE
      WriteLn('Seconds: ', span.timeInSeconds);
            
  END;
  
  {
    Tests the procedure SecondsToTimeSpan.
    Prints the result or the error to the console.
    @param sec: 
             the seconds to convert
    @changes
        This procedure now works with the given TimeSpan instance and not with the formerly given second value
  }
  PROCEDURE TestSecondsToTimeSpan(span: TimeSpan);
  BEGIN
  
    WriteLn('Seconds: ', span.timeInSeconds);
    span := SecondsToTimeSpan(span);  

    IF HasErrors(span) THEN
      WriteLn(HandleErrors(span))
    ELSE
      WriteLn('Time: ', span.hour, ':', span.minute, ':', span.second, ' / ');
        
  END;
   
  {
    Tests the function SecondsToTimeSpan.
    Prints the result or the error to the console.
    @param 
        before: the TimeSpan instance containing the lower second value.
    @param 
        after: the TimeSpan instance containing the higher second value.      
  }
  PROCEDURE TestTimeDifference(before, after: TimeSpan);
  VAR 
    result, beforeResult, afterResult: TimeSpan;
  BEGIN
  
    TimeDifference(before, after, beforeResult, afterResult, result);  

    WriteLn('Before       : ', beforeResult.hour, ':', beforeResult.minute, ':', beforeResult.second);
    WriteLn('Before error : ', HandleErrors(beforeResult));
    WriteLn('After        : ', afterResult.hour, ':', afterResult.minute, ':', afterResult.second);
    WriteLn('After error  : ', HandleErrors(afterResult));
    WriteLn('Result: error: ', HandleErrors(result));
    WriteLn('Difference   : ', result.timeInSeconds);
        
  END; 
  
  {
    Procedure which tests the actions which can be performed on the given TimeSpan instances depending on the set 'actionType'.
    If an unexpected action type is detected a error message will e printed to the console,
    otherwise the proper function/procedure is invoked.
    
    @param
        span1: the first TimeSpan instance to test action invocation on. 
    @param
        span2: the second TimeSpan instance to test action invocation on. Only used when actionType = 'CALC_DIFFERENCE' 
  }
  PROCEDURE Test(span1, span2: TimeSpan);
  BEGIN
  
    IF span1.actionType = TIME_TO_SECOND THEN
      TestTimeSpanToSeconds(span1)
    ELSE IF span1.actionType = SECOND_TO_TIME THEN
      TestSecondsToTimeSpan(span1)
    ELSE IF (span1.actionType = CALC_DIFFERENCE) AND (span2.actionType = CALC_DIFFERENCE) THEN
      TestTimeDifference(span1, span2)
    ELSE 
      WriteLn('No action type defined !!!');

    WriteLn('-----------------------------------------------------------------------');
    
  END;

  { #################### Main program #################### }
VAR
  temp: TimeSpan;
BEGIN

  {
    Dummy TimeSpan instance, needed because two TimeSpan instances are defined a formal parameters on Test procedure.
    SO only one test procedure is needed, and this one can handle an undefined actionType.
  }
  temp := InitTimeSpan(-1,0,0,0,NO_CONVERSION);
  WriteLn('########################################################################');
  WriteLn('#                  Tests for TimeSpanToSeconds                         #');
  WriteLn('########################################################################');
  WriteLn();
  Test(InitTimeSpan(-1,0,0,0,NO_CONVERSION), temp);
  Test(InitTimeSpan(-1,-1,0,0,TIME_TO_SECOND), temp);
  Test(InitTimeSpan(-1,-1,-1,0,TIME_TO_SECOND), temp);
  Test(InitTimeSpan(120,60,0,0,TIME_TO_SECOND), temp);
  Test(InitTimeSpan(120,60,60,0,TIME_TO_SECOND), temp);
  Test(InitTimeSpan(0,0,0,-1,TIME_TO_SECOND), temp);
  Test(InitTimeSpan(120,59,59,-1,TIME_TO_SECOND), temp);
  
  WriteLn();
  WriteLn('########################################################################');
  WriteLn('#                  Tests for SecondsToTimeSpan                         #');
  WriteLn('########################################################################');
  WriteLn();
  Test(InitTimeSpan(-1,-1,-1,0,SECOND_TO_TIME), temp);
  Test(InitTimeSpan(-1,-1,-1,-1,SECOND_TO_TIME), temp);
  Test(InitTimeSpan(0,0,0,59,SECOND_TO_TIME), temp);
  Test(InitTimeSpan(0,0,0,60,SECOND_TO_TIME), temp);
  Test(InitTimeSpan(0,0,0,3599,SECOND_TO_TIME), temp);
  Test(InitTimeSpan(0,0,0,3600,SECOND_TO_TIME), temp);
  
  WriteLn();
  WriteLn('########################################################################');
  WriteLn('#                  Tests for TimeDifference                            #');
  WriteLn('########################################################################');
  WriteLn();
  Test(InitTimeSpan(1,60,60,0,CALC_DIFFERENCE), InitTimeSpan(-1,60,59,0,CALC_DIFFERENCE));
  Test(InitTimeSpan(1,1,59,0,CALC_DIFFERENCE), InitTimeSpan(1,1,58,0,CALC_DIFFERENCE));
  Test(InitTimeSpan(1,1,58,0,CALC_DIFFERENCE), InitTimeSpan(1,1,59,0,CALC_DIFFERENCE));
  Test(InitTimeSpan(1,1,59,0,CALC_DIFFERENCE), InitTimeSpan(1,1,59,0,CALC_DIFFERENCE));
  Test(InitTimeSpan(1,1,59,0,CALC_DIFFERENCE), InitTimeSpan(3,2,59,0,CALC_DIFFERENCE));
  
END.