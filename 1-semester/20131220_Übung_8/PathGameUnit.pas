UNIT PathGameUnit;

INTERFACE

TYPE
  { The range of the x coordinate }
  xRange = 1..50;
  { The range of the y coordinate }
  yRange = 1..20;
  
{
  Resets the game by creating a new game field with no walls.
}
PROCEDURE Reset;

{
  Prints the game field to the console.
}
PROCEDURE PrintGameField;

{
  Sets a raster field as a wall or an empty field.
  The existing type of the raster field will be overwritten.
  
  @param
      x: the x coordinate of the raster field
  @param
      y: the y coordinate of the raster field
  @param
      wall: true if the raster field shall be set as a wall, false otherwise
}
PROCEDURE SetRasterField(x: xRange; y: yRange; wall: BOOLEAN);

{
  Answers the question if the given field can be reached of the given position in the given steps
  via a recursive implementation.
  
  @param
      ax, ay: the coordinates of the start position
  @param
      bx, by: the goal position
  @param
      maxSteps: the maximum count of the steps
  @return
      true if the position can reached with the given steps, false otherwise
}
FUNCTION PathExists(ax: xRange; ay: yRange; bx: xRange; by: yRange; maxSteps: INTEGER): BOOLEAN;

{
  Answers the question if the given field can be reached of the given position in the given steps
  via a iterative implementation.
  
  @param
      ax, ay: the coordinates of the start position
  @param
      bx, by: the goal position
  @param
      maxSteps: the maximum count of the steps
  @return
      true if the position can reached with the given steps, false otherwise
}
FUNCTION PathExistsIt(ax: xRange; ay: yRange; bx: xRange; by: yRange; maxSteps: INTEGER): BOOLEAN;

{ ###################### Public for testing ###################### }

IMPLEMENTATION

TYPE
  { The type of the raster field }
  Field = RECORD
    wall: BOOLEAN;
    symbol: STRING;
    y: yRange;
    x: xRange;
  END;
  { The type for the game field which holds the raster fields }
  GameField = RECORD
    raster: ARRAY[yRange, xRange] OF FIELD;
  END;
  { Array type which is used to hold the information about the visited raster fields }
  VisitedRasterFieldArray = ARRAY[yRange, xRange] OF BOOLEAN;
  Direction = (NONE, LEFT, UP, RIGHT, DOWN);

VAR
  { The GameField instance visible only for this module }
  game: GameField;
    
{ ###################### Private Functions and Procedures ###################### }
{
  Creates a raster field of the specified type.
  
  @param
      x: the x coordinate where the field resides 
  @param
      y: the y coordinate where the field resides
  @param
      wall: if true then the field will be created as a wall, as an empty field otherwise.
  @return
      the created Field instance
}
FUNCTION CreateRasterField(x: xRange; y: yRange; wall: BOOLEAN): Field;
VAR
  f: Field;
BEGIN
  f.wall := wall;
  f.x := x;
  f.y := y;
  
  IF (wall) THEN BEGIN  
    f.symbol := '#';
  END
  ELSE BEGIN
    f.symbol := '.';
  END;
  CreateRasterField := f;
END;

{
  Inits the VisitedRasterFieldArray instance by setting every array field to null;
  
  @return
      the initialized VisitedRasterFieldArray instance with all field set to null
}
FUNCTION InitVisitedRasterFieldArray: VisitedRasterFieldArray;
VAR
  raster: VisitedRasterFieldArray;
  i, j: INTEGER;
BEGIN
  FOR i := Low(yRange) TO High(yRange) DO BEGIN
    FOR j := Low(xRange) TO High(xRange) DO BEGIN
      raster[i][j] := false;
    END;
  END;
  
  InitVisitedRasterFieldArray := raster;
END;

FUNCTION GetDirectionOnY(currentField: Field; goalField: Field): Direction;
BEGIN
  IF (currentField.y < goalField.y) THEN BEGIN
    GetDirectionOnY := DOWN;
  END
  ELSE IF (currentField.y > goalField.y)  THEN BEGIN
    GetDirectionOnY := UP;
  END
  ELSE BEGIN
    GetDirectionOnY := NONE;
  END;
END;

FUNCTION GetDirectionOnX(currentField: Field; goalField: Field): Direction;
BEGIN
  IF (currentField.x < goalField.x) THEN BEGIN
    GetDirectionOnX := RIGHT;
  END
  ELSE IF (currentField.x > goalField.x)  THEN BEGIN
    GetDirectionOnX := LEFT;
  END
  ELSE BEGIN
    GetDirectionOnX := NONE;
  END;
END;

{
  Answers the question if the the both fields are the same.
  This is determined via their coordinates.
  
  @param
      currentField: the first field 
  @param
      goalField: the second field 
  @return
      true if the both fields do have the same coordinates, false otherwise
}
FUNCTION IsSameField(currentField, goalField: Field): BOOLEAN;
BEGIN
  IsSameField := ((currentField.x = goalField.x) AND (currentField.y = goalField.y));
END;

FUNCTION ReachedBorder(x, y: INTEGER): BOOLEAN;
BEGIN
  ReachedBorder := ((x < Low(xRange)) OR (x > High(xRange)) OR (y < Low(yRange)) OR (y > High(yRange)));
END;

FUNCTION AlreadyVisited(x, y: INTEGER; visitedFields: VisitedRasterFieldArray): BOOLEAN;
BEGIN
  AlreadyVisited := visitedFields[y][x];
END;

FUNCTION IsWall(x, y: INTEGER): BOOLEAN;
BEGIN
  IsWall := game.raster[y][x].wall;
END;

PROCEDURE MoveOnXAxis(VAR currentField: Field; goalField: Field; VAR visitedFields: VisitedRasterFieldArray);
VAR
  x, y: INTEGER;
BEGIN
  x := currentField.x;
  y := currentField.y;
  
  { Move down in raster }
  IF (GetDirectionOnX(currentField, goalField) = LEFT) THEN BEGIN
    { No border reached and not already visited }
    IF ((NOT ReachedBorder(x - 1, Low(yRange))) AND (NOT AlreadyVisited(x - 1, y, visitedFields))) THEN BEGIN
      x := currentField.x - 1;
    END;
  END
  { Move up in raster }
  ELSE IF (GetDirectionOnX(currentField, goalField) = RIGHT) THEN BEGIN
    IF ((NOT ReachedBorder(x + 1, Low(yRange))) AND (NOT AlreadyVisited(x + 1, y, visitedFields))) THEN BEGIN
      x := currentField.x + 1;
    END
  END;
  currentField.x := x;
  currentField.y := y;
END;

PROCEDURE MoveOnYAxis(VAR currentField: Field; goalField: Field; VAR visitedFields: VisitedRasterFieldArray);
VAR
  x, y: INTEGER;
BEGIN   
  x := currentField.x;
  y := currentField.y;
  
  { Move down in raster }
  IF (GetDirectionOnY(currentField, goalField) = DOWN) THEN BEGIN
    { No border reached and not already visited }
    IF ((NOT ReachedBorder(Low(xRange), y + 1)) AND (NOT AlreadyVisited(x, y + 1, visitedFields))) THEN BEGIN
      y := currentField.y + 1;
    END;
  END
  { Move up in raster }
  ELSE IF (GetDirectionOnY(currentField, goalField) = UP) THEN BEGIN
    IF ((NOT ReachedBorder(Low(xRange), y - 1)) AND (NOT AlreadyVisited(x, y - 1, visitedFields))) THEN BEGIN
      y := currentField.y - 1;
    END
  END;
  
  currentField.x := x;
  currentField.y := y;
END;

{ ###################### Public Functions and Procedures ###################### }
{ Reset the memory }
PROCEDURE Reset;
VAR
  i, j: INTEGER;
BEGIN
  FOR i := Low(yRange) TO High(yRange) DO BEGIN
    FOR j := Low(xRange) TO High(xRange) DO BEGIN
      game.raster[i][j] := CreateRasterField(j, i, false);
    END;
  END;
END;

{ Print game field }
PROCEDURE PrintGameField;
VAR
  i, j: INTEGER;
BEGIN
  FOR i := Low(game.raster) TO High(game.raster) DO BEGIN
    FOR j := Low(game.raster[i]) TO High(game.raster[i]) DO BEGIN
      Write(game.raster[i][j].symbol);
    END;
    WriteLn;
  END;
END;

{ Sets a raster field as a wall or empty }
PROCEDURE SetRasterField(x: xRange; y: yRange; wall: BOOLEAN);
BEGIN
  game.raster[y][x] := CreateRasterField(x, y, wall);
END; 

{ TODO: Checks for path exists }
FUNCTION PathExists(ax: xRange; ay: yRange; bx: xRange; by: yRange; maxSteps: INTEGER): BOOLEAN;
  FUNCTION Exists(startField, goalField, currentField: Field; visited: VisitedRasterFieldArray; maxSteps, steps: INTEGER): BOOLEAN;
  BEGIN
    { If field could not be reached in maxSteps, or maxSteps is lower or eaul then 0 }
    IF (maxSteps <= 0) THEN BEGIN
      Exists := false;
      WriteLn('maxSteps invalid');
    END
    { If start and goal field are the same }
    ELSE IF (IsSameField(startField, goalField)) THEN BEGIN
      Exists := false;
      WriteLn('same field');
    END   
    { If either start or goal field are walls }
    ELSE IF ((goalField.wall) OR (startField.wall)) THEN BEGIN
      Exists := false;    
      WriteLn('goal is wall');
    END
    { Check for found goal on last step }
    ELSE IF (steps > maxSteps) THEN BEGIN
      WriteLn('maximum reached');
      { If field has been reached }
      IF (IsSameField(currentField, goalField)) THEN BEGIN
        WriteLn('field found');
        Exists := true;
      END
      { If field has not been reached }
      ELSE BEGIN      
        WriteLn('field not found');  
        Exists := false;
      END;
    END    
    { If field has been reached }
    ELSE IF (IsSameField(currentField, goalField)) THEN BEGIN
      WriteLn('field found');
      Exists := true;
    END
    { Trying to reach the field }
    ELSE BEGIN
      { Try to move on y axis }
      (*MoveOnYAxis(currentField, goalField, visited);*)
      WriteLn(steps, '-x: ', currentField.x);
      WriteLn(steps, '-y: ', currentField.y);
      MoveOnXAxis(currentField, goalField, visited);
      Exists := Exists(startField, goalField, currentField, visited, maxSteps, steps + 1);
    END;  
  END;
  
BEGIN
  PathExists := Exists(game.raster[ay][ax], game.raster[by][bx], game.raster[ay][ax], InitVisitedRasterFieldArray, maxSteps, 1);
END;

{ TODO: Checks for path exists }
FUNCTION PathExistsIt(ax: xRange; ay: yRange; bx: xRange; by: yRange; maxSteps: INTEGER): BOOLEAN;
BEGIN
END;

BEGIN
  { Creates a empty game field }
  Reset;
END.