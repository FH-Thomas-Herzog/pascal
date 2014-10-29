{
  This unit hanldes time spans and is able to convert them into second representation
  and visa versa.
}
UNIT TimeSpanUnit;

{ ######################### Interface part ######################### }
INTERFACE
  TYPE
    {
      Record which holds the information of the time span representations and a eventually occurred error message as well.
    }
    TimeSpan = RECORD
        hour: INTEGER;
        minute: INTEGER;
        second: INTEGER;
        timeInSeconds: LONGINT;
        error: STRING;
    END;
    
  {
     This function is used to create a TimeSpan instance with the given values for the defined attributes.
     error attribute will be set to an empty string which indicates that no error has occured.

     @param
        h: the hour to be set on the instance
     @param
        m: the minute to be set on the instance
     @param
        s: the second to be set on the instance
     @return
         the created TimeSpan instance
  }
  FUNCTION CreateTimeSpan(h, m, s: INTEGER): TimeSpan;

  {
   Function which converts the given seconds to hour, minute and second values, 
   which will be set on the returned TimeSpan instance.
   If an error occured then´the error attribute will not be an empty string, but will contain the occured error description.

   @param 
       seconds: the seconds to convert into a time spend returned by a TimeSpan instance
   @return 
       the TimeSpan instance containing the calculated time representation of the set 'timeInSeconds' value, 
       or an set error message if an error occured
  }
  FUNCTION SecondsToTimeSpan(seconds: LONGINT): TimeSpan;
    
  {
    Function which calculates the second representation of the given time 'hh:mm:ss' set on the TimeSpan instance.
    If an error occurs then the error attribute will contain the the error description.
    
    @param 
        span: the TimeSpan instance which holds the time representation.
    @return 
        the TimeSpan instance with the set calculated 'timeInSeconds' value or the description of the occured error
    @see ValidateRange(value, range: INTEGER): BOOLEAN;
  }
  FUNCTION TimeSpanToSeconds(span: TimeSpan): TimeSpan;
  
  {
    Function which calculates the time difference in seconds between the two given TimeSpan 
    instances.
    
    @param
        before: the TimeSpan instance representing the lower time value
    @param
        after: the TimeSpan instance representing the higher time value
    @return 
        calcResult: the TimeSpan instance which holds the calculated time difference, or the set error
                    which would occur if 'before TimeSpan ' has a second value which is after the 'after TimeSpan' second value.
  }
  FUNCTION TimeDifference(before, after:TimeSpan): TimeSpan;
  
  {
    Function which answers the question if the before TimeSpan instance has a lower
    time value than the after TimeSpan.
    
    @param
        span1: the before TimeSpan instance
    @param
        span2: the after TimeSpan instance
    @return
        true if the span1 time span instance has a lower time value the the span2
        TimeSpan instance, false otherwise. If a error occured this function will return 
        false by default, because it has no way to populate the error to the caller.
  }
  FUNCTION IsShorterThan(span1, span2: TimeSpan):BOOLEAN;
  
  {
    Converts a TimeSpan isntance to its string representation.
    
    @param
        span: the TimeSpan instance which time span values shall be converted to a string
    @return
        the converted time span values of the given TimeSpan instance
  }
  FUNCTION TimeSpanToString(span: TimeSpan): STRING;
  
IMPLEMENTATION

TYPE
  {
    Enumeration which specifies the types of the time constants and is used to act as an array index.
    These enumerations specify the time attributes which do have constants settings.
  }
  TimeConstantType = (HOURS_PER_DAY, MINUTES_PER_HOUR, SECONDS_PER_MINUTE);

  {
    The array type which specifies an array with an index of the type 'TimeConstantType'
    Holds every time constants used for the conversion actions.
  }
  TimeConstantArray = ARRAY [TimeConstantType] OF INTEGER;

  {
    Constants which define the time constants. 
    The values are accessible via the 'TimeConstantType' enum values acting as the index of this array type.
    These constants are used for the time conversion actions.
    ATTENTION: The order of the values must fit the 'TimeConstantType' enumeration specification.
  }
  CONST
    timeConstant: TimeConstantArray = (24, 60, 60);


  { ######################### Private function and procedures ######################### }
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
    Converts a integer to a string representation.
    Used to have a function whic returns the converted integer instead of a procedure.
    WriteLn('h:', IntToStr(1), '');
    
    @param value:
              the integer to be converted to a string
    @return 
        the string representation of the given integer value
  }
  FUNCTION IntToStr(value: LONGINT): STRING;
  VAR 
    s: STRING;
  BEGIN
   
    Str(value, s);
    IntToStr := s
  
  END;
  
  { ######################### Public procedure and functions ######################### }  
  { Initializes the TimeSpan instance }
  FUNCTION CreateTimeSpan(h, m, s: INTEGER): TimeSpan;
  VAR
    span: TimeSpan;
  BEGIN

    span.hour := h;
    span.minute := m;
    span.second := s;
    span.timeInSeconds := 0;
    span.error := '';

    CreateTimeSpan := span;

  END;

  { Convert seconds to time span }
  FUNCTION SecondsToTimeSpan(seconds: LONGINT): TimeSpan;
  VAR 
    result: TimeSpan;
  BEGIN
    result := CreateTimeSpan(0, 0, 0);
    result.timeInSeconds := seconds;
    
    IF seconds >= 0 THEN BEGIN
      result.hour := seconds DIV (timeConstant[SECONDS_PER_MINUTE] * timeConstant[MINUTES_PER_HOUR]);
      result.minute := (seconds - (result.hour * (timeConstant[SECONDS_PER_MINUTE] * timeConstant[MINUTES_PER_HOUR]))) DIV timeConstant[MINUTES_PER_HOUR];
      result.second := (seconds - (result.hour * (timeConstant[SECONDS_PER_MINUTE] * timeConstant[MINUTES_PER_HOUR])) - (result.minute * timeConstant[MINUTES_PER_HOUR]));
    END
    ELSE
     result.error := 'Invalid Seconds: [' + IntToStr(seconds) + ']';
    
    SecondsToTimeSpan := result;

  END;

  { converts time span to seconds }
  FUNCTION TimeSpanToSeconds(span: TimeSpan): TimeSpan;
  VAR
    message: STRING;
    error: BOOLEAN;
  BEGIN
    message := '';
    error := false;
    
    IF span.hour < 0 THEN BEGIN
      message := message + '[' + IntToStr(span.hour) + ']';
      error := true;
    END
    ELSE   
      message := message + IntToStr(span.hour);
    IF NOT ValidateRange(span.minute, 0, (timeConstant[MINUTES_PER_HOUR] - 1)) THEN BEGIN
      message := message + ':[' + IntToStr(span.minute) + ']';
      error := true;
    END
    ELSE   
      message := message + ':' + IntToStr(span.minute);
    IF NOT ValidateRange(span.second, 0, (timeConstant[SECONDS_PER_MINUTE] - 1)) THEN BEGIN
      message := message + ':[' + IntToStr(span.second) + ']';
      error := true;
    END
    ELSE
      message := message + ':' + IntToStr(span.second);

    IF NOT error THEN
      span.timeInSeconds := (span.hour * timeConstant[MINUTES_PER_HOUR] * timeConstant[SECONDS_PER_MINUTE]) + (span.minute * timeConstant[SECONDS_PER_MINUTE]) + span.second
    ELSE
      span.error := 'Invalid time span: ' + message;
      
    TimeSpanToSeconds := span;

  END;

  { Reimplement the seconds difference conversion }
  FUNCTION TimeDifference(before, after:TimeSpan): TimeSpan;
  VAR
    result: TimeSpan;
    message: STRING;
  BEGIN
    message := '';
    result := CreateTimeSpan(0, 0, 0);
    before := TimeSpanToSeconds(before);
    after := TimeSpanToSeconds(after);
    
    { Handle detected error on time span }
    IF before.error <> '' THEN BEGIN
      message := 'Before: ' + before.error;
    END;
    IF after.error <> '' THEN BEGIN
      IF before.error <> '' THEN BEGIN
        message := message + ' | ';
      END;
      message := message + 'After: ' + after.error;        
    END;
    
    { Handle overflow }
    IF after.timeInSeconds < before.timeInSeconds THEN BEGIN
      message := 'after overflows before time span'
    END;
    
    IF message = '' THEN BEGIN
      result.timeInSeconds := after.timeInSeconds - before.timeInSeconds;
      TimeDifference := SecondsToTimeSpan(result.timeInSeconds);
    END
    ELSE BEGIN
      result.error := message;
      TimeDifference := result;
    END;
    
  END;
  
  { Check for shorter time span }
  FUNCTION IsShorterThan(span1, span2: TimeSpan):BOOLEAN;
  BEGIN
    span1 := TimeSpanToSeconds(span1);
    span2 := TimeSpanToSeconds(span2);
    
    IF (span1.error = '') AND (span2.error = '') AND (span1.timeInSeconds < span2.timeInSeconds) THEN BEGIN
      IsShorterThan := true
    END
    ELSE
      IsShorterThan := false;
  END;
  
  { Convert to string }
  FUNCTION TimeSpanToString(span: TimeSpan): STRING;
  BEGIN
    TimeSpanToString := IntToStr(span.hour) + ':' + IntToStr(span.minute) + ':' + IntToStr(span.second);
  END;
END.