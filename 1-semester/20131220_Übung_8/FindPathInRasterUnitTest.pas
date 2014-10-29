PROGRAM FindPathInRasterUnitTest;

USES FindPathInRaster;

{ Tests the reset procedure }
PROCEDURE TestReset;
BEGIN
  WriteLn;
  FindPathInRaster.Reset;
  WriteLn('---------------------------------------------------');
  WriteLn('Before reset');
  WriteLn('---------------------------------------------------');
  FindPathInRaster.SetCell(1,1,true);
  FindPathInRaster.SetCell(10,16,true);
  FindPathInRaster.SetCell(11,11,true);
  FindPathInRaster.SetCell(13,15,true);
  FindPathInRaster.PrintGameField;
  
  WriteLn;
  FindPathInRaster.Reset;  
  WriteLn('---------------------------------------------------');
  WriteLn('After reset');
  WriteLn('---------------------------------------------------');
  FindPathInRaster.PrintGameField;
  FindPathInRaster.Reset;  
END;

{ Tests the SetCell procedure }
PROCEDURE TestSetCell;
BEGIN
  WriteLn;
  WriteLn('---------------------------------------------------');
  WriteLn('Set field on raster');
  WriteLn('---------------------------------------------------');
  FindPathInRaster.Reset;
  FindPathInRaster.SetCell(Low(xRange), Low(yRange), true);
  FindPathInRaster.SetCell(Low(xRange), High(yRange), true);
  FindPathInRaster.SetCell(High(xRange), Low(yRange), true);
  FindPathInRaster.SetCell(High(xRange), High(yRange), true);
  FindPathInRaster.SetCell((High(xRange) DIV 2), (High(yRange) DIV 2), true);
  FindPathInRaster.PrintGameField;  
  FindPathInRaster.Reset;
END;

{ Test get Path exists }
PROCEDURE TestPathExists;
VAR
  i, j: INTEGER;
  top: BOOLEAN;
BEGIN 
  WriteLn;
  WriteLn('---------------------------------------------------');
  WriteLn('PathExists');
  WriteLn('---------------------------------------------------');
  FindPathInRaster.Reset;
  FindPathInRaster.SetCell(High(xRange), Low(yRange), true);
  WriteLn('Start is wall: ');
  WriteLn('Start: x:', High(xRange), ', y:', Low(yRange));
  WriteLn('Goal : x:',Low(xRange), ', y:', High(yRange));
  WriteLn('Path exists recursive: ', FindPathInRaster.PathExists(High(xRange), Low(yRange), Low(xRange), High(yRange)));
  WriteLn('Path exists iterative: ', FindPathInRaster.PathExists(High(xRange), Low(yRange), Low(xRange), High(yRange)));
  FindPathInRaster.PrintGameField;
  
  WriteLn;
  WriteLn('---------------------------------------------------');
  FindPathInRaster.Reset;
  FindPathInRaster.SetCell(Low(xRange), High(yRange), true);
  WriteLn('Goal is wall: ');
  WriteLn('Start: x:', High(xRange), ', y:', Low(yRange));
  WriteLn('Goal : x:',Low(xRange), ', y:', High(yRange));
  WriteLn('Path exists recursive: ', FindPathInRaster.PathExists(High(xRange), Low(yRange), Low(xRange), High(yRange)));
  WriteLn('Path exists iterative: ', FindPathInRaster.PathExists(High(xRange), Low(yRange), Low(xRange), High(yRange)));
  FindPathInRaster.PrintGameField;

  WriteLn;
  WriteLn('---------------------------------------------------');
  FindPathInRaster.Reset;
  FindPathInRaster.SetCell(5, 1, true);
  FindPathInRaster.SetCell(5, 2, true);
  FindPathInRaster.SetCell(5, 3, true);
  FindPathInRaster.SetCell(5, 4, true);
  FindPathInRaster.SetCell(1, 4, true);
  FindPathInRaster.SetCell(2, 4, true);
  FindPathInRaster.SetCell(3, 4, true);
  FindPathInRaster.SetCell(4, 4, true);
  FindPathInRaster.SetCell(5, 4, true);
  WriteLn('Goal is enclosed: ');
  WriteLn('Start: x:', High(xRange), ', y:', Low(yRange));
  WriteLn('Goal : x:', 2, ', y:', 2);
  WriteLn('Path exists recursive: ', FindPathInRaster.PathExists(High(xRange), Low(yRange), 2, 2));
  WriteLn('Path exists iterative: ', FindPathInRaster.PathExists(High(xRange), Low(yRange), 2, 2));
  FindPathInRaster.PrintGameField;
  
  WriteLn;
  WriteLn('---------------------------------------------------');
  FindPathInRaster.Reset;
  FindPathInRaster.SetCell(5, 1, true);
  FindPathInRaster.SetCell(5, 2, true);
  FindPathInRaster.SetCell(5, 3, true);
  FindPathInRaster.SetCell(5, 4, true);
  FindPathInRaster.SetCell(1, 4, true);
  FindPathInRaster.SetCell(2, 4, true);
  FindPathInRaster.SetCell(3, 4, true);
  FindPathInRaster.SetCell(4, 4, true);
  FindPathInRaster.SetCell(5, 4, true);
  WriteLn('Goal and Start are enclosed: ');
  WriteLn('Start: x:', 4, ', y:', 3);
  WriteLn('Goal : x:', 2, ', y:', 2);
  WriteLn('Path exists recursive: ', FindPathInRaster.PathExists(4, 3, 2, 2));
  WriteLn('Path exists iterative: ', FindPathInRaster.PathExists(4, 3, 2, 2));
  FindPathInRaster.PrintGameField;
  

  FindPathInRaster.Reset;
  { Do not Randomize to produce same output }
  top := true;
  FOR i := (Low(xRange) + 1) TO (High(xRange) - 1) DO BEGIN
    FOR j := Low(xRange) TO High(yRange) DO BEGIN
      IF (((i mod 2) <> 0) AND (top) AND (j > Low(yRange))) THEN BEGIN
        FindPathInRaster.SetCell(i, j, true); 
      END
      ELSE IF (((i mod 2) <> 0) AND (NOT top) AND (j < High(yRange))) THEN BEGIN
        FindPathInRaster.SetCell(i, j, true); 
      END;      
    END;
    IF ((i mod 2) <> 0) THEN BEGIN 
      IF (top) THEN BEGIN
        top := false;
      END
      ELSE BEGIN
        top := true;
      END;
    END;
  END;  
  WriteLn;
  WriteLn('---------------------------------------------------');
  WriteLn('Find path:');
  WriteLn('Start: x:', 1, ', y:', 1);
  WriteLn('Goal : x:', High(xRange), ', y:', High(yRange));
  WriteLn('Path exists recursive: ', FindPathInRaster.PathExists(1, 1, High(xRange), High(yRange)));
  WriteLn('Path exists iterative: ', FindPathInRaster.PathExists(1, 1, High(xRange), High(yRange)));
  FindPathInRaster.PrintGameField;
  FindPathInRaster.Reset;
END;

{ Test get Path exists }
PROCEDURE TestShortestPathLength;
VAR
  i, j: INTEGER;
  top: BOOLEAN;
BEGIN 
  WriteLn;
  WriteLn('---------------------------------------------------');
  WriteLn('ShortestPathLength');
  WriteLn('---------------------------------------------------');
  
  FindPathInRaster.Reset;
  FindPathInRaster.SetCell(High(xRange), Low(yRange), true);
  WriteLn('Start is wall: ');
  WriteLn('Start: x:', High(xRange), ', y:', Low(yRange));
  WriteLn('Goal : x:',Low(xRange), ', y:', High(yRange));
  WriteLn('Shortest path: ', FindPathInRaster.ShortestPathLength(High(xRange), Low(yRange), Low(xRange), High(yRange)));
  FindPathInRaster.PrintGameField;

  WriteLn;
  WriteLn('---------------------------------------------------');
  FindPathInRaster.Reset;
  FindPathInRaster.SetCell(Low(xRange), High(yRange), true);
  WriteLn('Goal is wall: ');
  WriteLn('Start: x:', High(xRange), ', y:', Low(yRange));
  WriteLn('Goal : x:',Low(xRange), ', y:', High(yRange));
  WriteLn('Shortest path: ', FindPathInRaster.ShortestPathLength(High(xRange), Low(yRange), Low(xRange), High(yRange)));
  FindPathInRaster.PrintGameField;

  WriteLn;
  WriteLn('---------------------------------------------------');
  FindPathInRaster.Reset;
  FindPathInRaster.SetCell(5, 1, true);
  FindPathInRaster.SetCell(5, 2, true);
  FindPathInRaster.SetCell(5, 3, true);
  FindPathInRaster.SetCell(5, 4, true);
  FindPathInRaster.SetCell(1, 4, true);
  FindPathInRaster.SetCell(2, 4, true);
  FindPathInRaster.SetCell(3, 4, true);
  FindPathInRaster.SetCell(4, 4, true);
  FindPathInRaster.SetCell(5, 4, true);
  WriteLn('Goal is enclosed: ');
  WriteLn('Start: x:', High(xRange), ', y:', Low(yRange));
  WriteLn('Goal : x:', 2, ', y:', 2);
  WriteLn('Shortest path: ', FindPathInRaster.ShortestPathLength(High(xRange), Low(yRange), 2, 2));
  FindPathInRaster.PrintGameField;
  
  FindPathInRaster.Reset;
  WriteLn('Path found ');
  top := true;
  FOR i := (Low(xRange) + 1) TO (High(xRange) - 1) DO BEGIN
    FOR j := Low(xRange) TO High(yRange) DO BEGIN
      IF (((i mod 2) <> 0) AND (top) AND (j > Low(yRange))) THEN BEGIN
        FindPathInRaster.SetCell(i, j, true); 
      END
      ELSE IF (((i mod 2) <> 0) AND (NOT top) AND (j < High(yRange))) THEN BEGIN
        FindPathInRaster.SetCell(i, j, true); 
      END;      
    END;
    IF ((i mod 2) <> 0) THEN BEGIN 
      IF (top) THEN BEGIN
        top := false;
      END
      ELSE BEGIN
        top := true;
      END;
    END;
  END;  
  WriteLn;
  WriteLn('Start: x:', Low(xRange), ', y:', Low(yRange));
  WriteLn('Goal : x:', High(xRange), ', y:', High(yRange));
  WriteLn('Shortest path: ', FindPathInRaster.ShortestPathLength(Low(xRange), Low(yRange), High(xRange), High(yRange)));
  FindPathInRaster.PrintGameField;
END;

BEGIN
  TestReset; 
  TestSetCell; 
  TestPathExists;
  TestShortestPathLength;
END.