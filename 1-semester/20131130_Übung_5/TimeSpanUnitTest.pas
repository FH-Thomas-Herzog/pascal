{
  Programm which test the TimeSpanUnit.
}
PROGRAM TimeSpanUnitTest;

USES TimeSpanUnit;

{
  Tests the TimeDifference function.
  
  @param
      before: the before TimeSpan instance
  @param
      after: the after TimeSpan instance
}
PROCEDURE TestTimeDifference(before, after: TimeSpan);
VAR
  result: TimeSpan;
BEGIN
  result := TimeDifference(before, after);
  WriteLn('before:         ', TimeSpanToString(before));
  WriteLn('after:          ', TimeSpanToString(after));
  WriteLn('result (h:m:s): ', TimeSpanToString(result));
  WriteLn('result (sec):   ', result.timeInSeconds);
  WriteLn('error:  ', result.error);
  WriteLn('');
END;

{
  Test the TimeSpanToSeconds function.
  
  @param
      span: the TimeSpan instance
}
PROCEDURE TestTimeSpanToSeconds(span: TimeSpan);
VAR
  result: TimeSpan;
BEGIN
  result := TimeSpanToSeconds(span);
  WriteLn('time span:    ', TimeSpanToString(result));
  WriteLn('result (sec): ', result.timeInSeconds);
  WriteLn('error:        ', result.error);
  WriteLn('');
END;

{
  Test the SecondsToTimeSpan function.
  
  @param
      seconds: the seconds to convert
}
PROCEDURE TestSecondsToTimeSpan(seconds: LONGINT);
VAR
  result: TimeSpan;
BEGIN
  result := SecondsToTimeSpan(seconds);
  WriteLn('seconds:   ', seconds);
  WriteLn('time span: ', TimeSpanToString(result));
  WriteLn('error:     ', result.error);
  WriteLn('');
END;

{
  Test the IsShorterThan function.
  
  @param
      before: the before TimeSpan instance
  @param
      after: the after TimeSpan instance
}
PROCEDURE TestIsShorterThan(before, after: TimeSpan);
BEGIN
  WriteLn('before: ', TimeSpanToString(before));
  WriteLn('after:  ', TimeSpanToString(after));
  WriteLn('result: ', IsShorterThan(before, after));
  WriteLn('');
END;

BEGIN
  { Test convert span to seconds }
  WriteLn('################ TimeSpanToSeconds ################');
  TestTimeSpanToSeconds(CreateTimeSpan(-1,-1,-1));
  TestTimeSpanToSeconds(CreateTimeSpan(1,60,60));
  TestTimeSpanToSeconds(CreateTimeSpan(1,59,60));
  TestTimeSpanToSeconds(CreateTimeSpan(1,1,1));
  
  { Test convert seconds to time span }
  WriteLn('################ SecondsToTimeSpan ################');
  TestSecondsToTimeSpan(-1);
  TestSecondsToTimeSpan(0);  
  TestSecondsToTimeSpan(1);
  TestSecondsToTimeSpan(3600);
  TestSecondsToTimeSpan(3601);
  TestSecondsToTimeSpan(3661);
  
  { Test get time difference }
  WriteLn('################ TimeDifference ################');
  TestTimeDifference(CreateTimeSpan(-1, -1, -1), CreateTimeSpan(-1, -1, -1));
  TestTimeDifference(CreateTimeSpan(0, -1, -1), CreateTimeSpan(0, -1, -1));
  TestTimeDifference(CreateTimeSpan(0, 0, -1), CreateTimeSpan(0, 0, -1));
  TestTimeDifference(CreateTimeSpan(0, 60, -1), CreateTimeSpan(0, 60, -1));
  TestTimeDifference(CreateTimeSpan(0, 0, 2), CreateTimeSpan(0, 0, 1));
  TestTimeDifference(CreateTimeSpan(0, 59, 1), CreateTimeSpan(0, 59, 1));
  TestTimeDifference(CreateTimeSpan(10, 10, 10), CreateTimeSpan(10, 10, 10));
  TestTimeDifference(CreateTimeSpan(9, 9, 9), CreateTimeSpan(10, 10, 10));

  
  { Test is shorter than }
  WriteLn('################ IsShorterThan ################');
  TestIsShorterThan(CreateTimeSpan(10, 10, -1), CreateTimeSpan(10, 10, 9));
  TestIsShorterThan(CreateTimeSpan(10, 10, 9), CreateTimeSpan(10, 10, -1));
  TestIsShorterThan(CreateTimeSpan(10, 10, 10), CreateTimeSpan(10, 10, 10));
  TestIsShorterThan(CreateTimeSpan(10, 10, 9), CreateTimeSpan(10, 10, 10));
  
  { Test convert time span to string }
  WriteLn('################ TImeSpanToString ################');
  WriteLn(TimeSpanToString(CreateTimeSpan(10, 10, 10)));
  WriteLn(TimeSpanToString(CreateTimeSpan(23, 59, 59)));
  WriteLn(TimeSpanToString(CreateTimeSpan(23, 60, -1)));
  WriteLn('');
  
END.