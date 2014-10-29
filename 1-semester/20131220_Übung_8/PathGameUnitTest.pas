PROGRAM PathGameUnitTest;

USES PathGameUnit;

{ Tests the SetRasterField procedure }
PROCEDURE TestSetRasterField;
BEGIN
  WriteLn('---------------------------------------------------');
  WriteLn('Set field on raster');
  WriteLn('---------------------------------------------------');
  PathGameUnit.Reset;
  PathGameUnit.SetRasterField(Low(xRange), Low(yRange), true);
  PathGameUnit.SetRasterField(Low(xRange), High(yRange), true);
  PathGameUnit.SetRasterField(High(xRange), Low(yRange), true);
  PathGameUnit.SetRasterField(High(xRange), High(yRange), true);
  PathGameUnit.SetRasterField((High(xRange) DIV 2), (High(yRange) DIV 2), true);
  PathGameUnit.PrintGameField;  
  PathGameUnit.Reset;
END;

{ Tests the reset procedure }
PROCEDURE TestReset;
BEGIN
  PathGameUnit.Reset;
  WriteLn('---------------------------------------------------');
  WriteLn('Empty raster');
  WriteLn('---------------------------------------------------');
  PathGameUnit.PrintGameField;
  WriteLn;
  WriteLn('---------------------------------------------------');
  WriteLn('Filled raster');
  WriteLn('---------------------------------------------------');
  PathGameUnit.Reset;
  PathGameUnit.SetRasterField(1,1,true);
  PathGameUnit.SetRasterField(10,16,true);
  PathGameUnit.SetRasterField(11,11,true);
  PathGameUnit.SetRasterField(13,15,true);
  PathGameUnit.PrintGameField;
  PathGameUnit.Reset;
END;

{ Test get Path exists }
PROCEDURE TestPathExists;
BEGIN
  PathGameUnit.Reset;
  WriteLn;
  WriteLn('---------------------------------------------------');
  WriteLn('Straight on y-axis');
  WriteLn('---------------------------------------------------');
  PathGameUnit.SetRasterField(Low(xRange), High(yRange), true);
  PathGameUnit.PrintGameField;
  WriteLn(PathGameUnit.PathExists(Low(xRange), Low(yRange), Low(xRange), High(yRange) - 1, 18));
  
  PathGameUnit.Reset;
  WriteLn;
  WriteLn('---------------------------------------------------');
  WriteLn('Straight on x-axis');
  WriteLn('---------------------------------------------------');
  PathGameUnit.SetRasterField(High(xRange), Low(yRange), true);
  PathGameUnit.PrintGameField;
  WriteLn(PathGameUnit.PathExists(Low(xRange), Low(yRange), High(xRange) - 1, Low(yRange), 49));
END;

BEGIN
  TestSetRasterField;
  TestReset; 
  TestPathExists;
END.