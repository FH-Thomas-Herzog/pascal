{
  This program is used to convert a second value to its time representation
  and to convert a time representation 'hh:mm:ss' to its second representation.
  
  Main function and procedure:
  ----------------------------
  1. SecondsToTimeSpan(sec: LONGINT; VAR hh, mm, ss, code: INTEGER);
     Converts the seconds to its time representation
     
  2. TimeSpanToSeconds(hh, mm, ss: INTEGER): LONGINT;
     Converts a time representation to its second representation
  
  Contained util function, procedures:
  ------------------------------------
  1. ToString(value: LONGINT): STRING;
     Converts a integer to its string representation
     
  2. ValidateRange(value, bottom, top: INTEGER): BOOLEAN;
     Validates if the given value is within the defined borders 
     
  3. GetErrorMessage(code: INTEGER): STRING;
     Resoles the proper error message regarding the given code
     
  4. TestTimeSpanToSeconds(hh, mm, ss: INTEGER);
     Procedure to test the TimeSpanToSeconds algorithm.
     
  5. TestSecondsToTimeSpan(sec: LONGINT);
     Procedure to test the SecondsToTimespan algorithm
}
PROGRAM TimeConverter;

  {
    Constans available in whole program, because they are used in several functions and procedures.
    These constans do define the maximum time part borders
    and the error codes if the time value or second value could not be converted 
  }
  CONST
    hoursPerDay: INTEGER = 24;
    minutesPerHour: INTEGER = 60;
    secondsPerMinute: INTEGER = 60;
    invalidHours: INTEGER = -1;
    invalidMinutes: INTEGER = -2;
    invalidSeconds: INTEGER = -3;
  
  {
    Converts a integer to a string representation.
    @param value:
              the integer to be converted to a string
    @paaram the string representation of the given integer value
  }
  FUNCTION ToString(value: LONGINT): STRING;
  VAR 
    s: STRING;
  BEGIN
   Str(value, s);
   ToString := s
  END;
  
  {
    Function which validates the range of the given value.
    
    @param value: 
            the value which range shall be validated
    @param bottom: 
            the bottom border of the givan 'value'
    @param top: 
            the top border of the given 'value'
    @return true if the value is within the defined borders, false otherwise or if bottom > top
  }
  FUNCTION ValidateRange(value, bottom, top: INTEGER): BOOLEAN;
  BEGIN
    ValidateRange := false;
    
    IF (bottom <= top) AND (value >= bottom) AND (value <= top) THEN
      ValidateRange := true
  END;
  
  {
    Function to resolve the error message regarding the error code.
    @param code: 
            the code containg the error message
    @return the proper error message, 'undefined error occured: [UNKNOWN_ERROR_CODE]' if an unknown error occured
    
  }
  FUNCTION GetErrorMessage(code: INTEGER): STRING;
  BEGIN
    GetErrorMessage := 'undefined error occured: ' + ToString(code); 
    
    IF code = invalidSeconds THEN
      GetErrorMessage := 'Given seconds are out of range !!! error-code: ' + ToString(code)
    ELSE IF code = invalidMinutes THEN
      GetErrorMessage := 'Given minutes are out of range !!! error-code: '  + ToString(code)
    ELSE IF code = invalidHours THEN
      GetErrorMessage := 'Given hours are out of range !!! error-code: '  + ToString(code)
  END;
  
  
  {
    Procedure which converts the given seconds to hour, minute and second values.
    @param seconds: 
              the seconds to convert to time representation
    @return 
        hour: the calculated hours
        min : the calculated minutes
        sec : the calculated seconds which are the rest 
  }
  PROCEDURE SecondsToTimeSpan(sec: LONGINT; VAR hh, mm, ss, code: INTEGER);
  BEGIN
    code := 0;
    hh := 0;
    mm := 0;
    ss := 0;
    
    {
      Calculate the time representation of the given 'seconds' when 'seconds > 0'.
      If 'seconds <= 0' then no calculation is necessary.
      Set error code invalidSeconds if 'sec < 0' to indicate that invalid second value has been detected
    }
    IF sec > 0 THEN BEGIN
      hh := sec DIV (secondsPerMinute * minutesPerHour);
      mm := (sec - (hh * (secondsPerMinute * minutesPerHour))) DIV minutesPerHour;
      ss := (sec - (hh * (secondsPerMinute * minutesPerHour)) - (mm * minutesPerHour));
    END ELSE IF sec < 0 THEN
      code := invalidSeconds
  END;
   
  {
    Function which calculates the second representation of the given time 'hh:mm:ss'.
    @param hh: 
            the hours to be converted to seconds
    @param mm: 
            the minutes to be cconverted to seconds
    @param ss: 
            the seconds to be added to the converted seconds of 'hour' and 'min'
    @return the seconds representation of the given time.
            If there is an invalid time value given e.g.: 123:60:60 then regarding to the first detected 
            timer part a constan will be returned to indicate where the error occured.
    @see ValidateRange(value, range: INTEGER): BOOLEAN;
    @see CONST at program head
         invalidHours: INTEGER = -1;
         invalidMinutes: INTEGER = -2;
         invalidSeconds: INTEGER = -3;
  }
  FUNCTION TimeSpanToSeconds(hh, mm, ss: INTEGER): LONGINT;
  VAR
    temp: LONGINT;
  BEGIN
    temp := 0;
    
    IF hh < 0 THEN
      temp := invalidHours
    ELSE IF NOT ValidateRange(mm, 0, (minutesPerHour - 1)) THEN
      temp := invalidMinutes
    ELSE IF NOT ValidateRange(ss, 0, (secondsPerMinute - 1)) THEN
      temp := invalidSeconds;
      
    IF temp = 0 THEN
        temp := (hh * minutesPerHour * secondsPerMinute) + (mm * secondsPerMinute) + ss;
        
    TimeSpanToSeconds := temp;
  END;
   
  {
    Procedure to test the Function TimeSpanToSeconds.
    Prints the result or the error to the console.
    @param hh: 
            the hours of the time
    @param mm: 
            the minutes of the time
    @param ss: 
            the seconds of the time
  }
  PROCEDURE TestTimeSpanToSeconds(hh, mm, ss: INTEGER);
  VAR 
    seconds: LONGINT;
  BEGIN
    seconds := TimeSpanToSeconds(hh,mm,ss); 
    WriteLn('Time: ', ToString(hh), ':', ToString(mm), ':', Tostring(ss), ' / ');
    
    IF seconds < 0 THEN
      WriteLn(GetErrorMessage(seconds))
    ELSE
      WriteLn('Seconds: ', seconds);
      
    WriteLn('-----------------------------------------------------------------------');
  END;
  
  {
    Tests the procedure SecondsToTimeSpan.
    Prints the result or the error to the console.
    @param sec: 
             the seconds to convert
  }
  PROCEDURE TestSecondsToTimeSpan(sec: LONGINT);
    VAR
      hh, mm ,ss, code: INTEGER;
  BEGIN
    WriteLn('Seconds: ', sec);
    SecondsToTimeSpan(sec, hh, mm, ss, code);  
    
    IF code < 0 THEN
      WriteLn(GetErrorMessage(code))
    ELSE
      WriteLn('Time: ', ToString(hh), ':', ToString(mm), ':', Tostring(ss), ' / ');
      
    WriteLn('-----------------------------------------------------------------------');
  END;
  
VAR
  input: LONGINT;
  hours, minutes, seconds, code: INTEGER;
BEGIN
  WriteLn('########################################################################');
  WriteLn('#                  Tests for TimeSpanToSeconds                         #');
  WriteLn('########################################################################');
  WriteLn();
  TestTimeSpanToSeconds(-1,0,0);
  TestTimeSpanToSeconds(0,-1,0);
  TestTimeSpanToSeconds(0,0,-1);
  TestTimeSpanToSeconds(0,60,0);
  TestTimeSpanToSeconds(0,0,60);
  TestTimeSpanToSeconds(0,60,60);
  TestTimeSpanToSeconds(0,0,0);
  TestTimeSpanToSeconds(1,0,0);
  TestTimeSpanToSeconds(0,1,0);
  TestTimeSpanToSeconds(0,0,1);
  TestTimeSpanToSeconds(25,0,0);
  TestTimeSpanToSeconds(0,59,0);
  TestTimeSpanToSeconds(0,0,59);
  TestTimeSpanToSeconds(25,59,59);
  
  WriteLn();
  WriteLn('########################################################################');
  WriteLn('#                  Tests for SecondsToTimeSpan                         #');
  WriteLn('########################################################################');
  WriteLn();
  TestSecondsToTimeSpan(-1);
  TestSecondsToTimeSpan(0);
  TestSecondsToTimeSpan(59);
  TestSecondsToTimeSpan(60);
  TestSecondsToTimeSpan(3559);
  TestSecondsToTimeSpan(3600);
END.