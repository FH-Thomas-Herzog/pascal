PROGRAM SchierpinskiTriangleUnitTest;

USES SchierpinskiTriangleUnit;

VAR
  i: INTEGER;
BEGIN
  WriteLn('########################################################');
  WriteLn('Triangle area after n iterations left:');
  WriteLn('########################################################');
  FOR i:= 0 TO 19 DO BEGIN
    WriteLn(i, '-recursive: ', SchierpinskiTriangleUnit.CalcAreaForItCount(i, 1):5);
    WriteLn(i, '-iterativ : ', SchierpinskiTriangleUnit.CalcAreaForItCountIt(i, 1):5); 
  END;
  WriteLn('########################################################');
  
  { Causes range check error }
  (* WriteLn;
  WriteLn('########################################################');
  WriteLn('Triangle area error 20 iterations :');
  WriteLn('########################################################');
  WriteLn('20-recursive: ', SchierpinskiTriangleUnit.CalcAreaForItCount(20, 1):5);
  WriteLn('20-iterativ :  ', SchierpinskiTriangleUnit.CalcAreaForItCountIt(20, 1):5); *)
  
  { Causes range check error }
  (* WriteLn;
  WriteLn('########################################################');
  WriteLn('Triangle area error 21 iterations :');
  WriteLn('########################################################');
  WriteLn('20-recursive: ', SchierpinskiTriangleUnit.CalcAreaForItCount(21, 1):5); *)
  
  WriteLn;
  WriteLn('########################################################');
  WriteLn('Placed triangle dimensions after n iterations:');
  WriteLn('########################################################');
  FOR i:= 0 TO 19 DO BEGIN
    WriteLn(i, '-recursive: ', SchierpinskiTriangleUnit.CalcTriangleDimesnions(i, 1):5);
    WriteLn(i, '-iterativ : ', SchierpinskiTriangleUnit.CalcTriangleDimesnionsIt(i, 1):5);
  END;
  WriteLn('########################################################');
  
  { Causes range check error }
  (* WriteLn;
  WriteLn('########################################################');
  WriteLn('Placed triangle dimensions after 20 iterations:');
  WriteLn('########################################################');
  WriteLn('20-recursive: ', SchierpinskiTriangleUnit.CalcTriangleDimesnions(20, 1):5);
  WriteLn('20-iterativ : ', SchierpinskiTriangleUnit.CalcTriangleDimesnionsIt(20, 1):5); *)
  
  { Causes range check error }
  (* WriteLn;
  WriteLn('########################################################');
  WriteLn('Placed triangle dimensions after 21 iterations:');
  WriteLn('########################################################');
  WriteLn('20-recursive: ', SchierpinskiTriangleUnit.CalcTriangleDimesnions(21, 1):5); *)
  
END. 