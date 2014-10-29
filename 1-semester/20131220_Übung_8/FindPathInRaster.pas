{
  Unit which provides the functionality to find a field from a start field within a raster.
  It can also determine the shortest path to the intended field.
}
UNIT FindPathInRaster;

INTERFACE

TYPE
  { The range of the x coordinate }
  xRange = 1..20;
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
  Sets a raster FieldCell as a wall or an empty FieldCell.
  The existing type of the raster FieldCell will be overwritten.
  
  @param
      x: the x coordinate of the FieldCell
  @param
      y: the y coordinate of the FieldCell
  @param
      wall: true if the FieldCell shall be set as a wall, false otherwise
}
PROCEDURE SetCell(x: xRange; y: yRange; wall: BOOLEAN);

{
  Answers the question if the given FieldCell can be reached of the given position
  via a recursive implementation.
  
  @param
      ax, ay: the coordinates of the start position
  @param
      bx, by: the goal position
  @return
      true if the position can reached with the given steps, false otherwise
}
FUNCTION PathExists(ax: xRange; ay: yRange; bx: xRange; by: yRange): BOOLEAN;

{
  Answers the question if the given FieldCell can be reached of the given position
  via a iterative implementation.
  
  @param
      ax, ay: the coordinates of the start position
  @param
      bx, by: the goal position
  @return
      true if the position can reached with the given steps, false otherwise
}
FUNCTION PathExistsIt(ax: xRange; ay: yRange; bx: xRange; by: yRange): BOOLEAN;

{
  This function gets the shortest path length.
  
  @param
      x: the x coordinate of the start field
  @param
      y: the y coordinate of the start field
  @param
      x: the x coordinate of the goal field
  @param
      y: the y coordinate of the goal field
  @return
      the length of the shortest path or -1 if no path could be found
}
FUNCTION ShortestPathLength(ax: xRange; ay: yRange; bx: xRange; by: yRange): INTEGER;

IMPLEMENTATION

TYPE
  { The type of the FieldCell }
  FieldCell = RECORD
    wall: BOOLEAN;
    symbol: STRING;
    y: yRange;
    x: xRange;
  END;
  { The type for the game field which holds the cells }
  GameField = RECORD
    raster: ARRAY[yRange, xRange] OF FieldCell;
  END;
  { AType used for the found cells in the raster }
  FieldCellNode = ^FoundFieldCell;
  FoundFieldCell = RECORD
    cell: FieldCell;
    count: INTEGER;
    prev, next: FieldCellNode;
  END;
  { The type for the list of FieldCellnode }
  FoundFieldList = FieldCellNode;

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
  @param
     symbol: the symbol used for the FieldCell
  @return
      the created FieldCell instance
}
FUNCTION CreateRasterField(x: xRange; y: yRange; wall: BOOLEAN; symbol: STRING): FieldCell;
VAR
  cell: FieldCell;
BEGIN
  cell.x := x;
  cell.y := y; 
  cell.wall := wall;
  cell.symbol := symbol;
  CreateRasterField := cell;
END;

{
  Answers the question if the given coordinates are valid ones, by checking the ranges defined by the 
  custom type.
  
  @param
      x: the x coordinate
  @param
      y: the y coordinate
  @return
      true if the given coordinates are valid
}
FUNCTION IsValidCoordinate(x, y: INTEGER): BOOLEAN;
BEGIN
  IsValidCoordinate := ((x >= Low(xRange)) AND (x <= High(xRange)) AND (y >= Low(yRange)) AND (y <= High(yRange)));
END;

{
  Answers the question if the two given fields are the same by comparison of their coordinates.
  
  @param
      f1: the first FieldCell instance
  @param
      f2: the second FieldCell instance
  @return
      true if the both fields are equal, false otherwise
}
FUNCTION IsSameField(f1, f2: FieldCell): BOOLEAN;
BEGIN
  IsSameField := ((f1.x = f2.x) AND (f1.y = f2.y));
END;

{ ######################### List helper function and procedures ######################### }
{
  Creates a FieldCellNode instance.
  
  @param
      cell: the FieldCell to be hold by the created FieldCellNode instance
  @param
      count: the count to be hold by the FieldCellNode instance
  @return
      the created FieldCellNode instance
}
FUNCTION CreateFoundFieldCellNode(cell: FieldCell; count: INTEGER): FieldCellNode;
VAR
  node: FieldCellNode;
BEGIN
  New(node);
  node^.cell := cell;
  node^.count := count;
  node^.next :=  node;
  node^.prev := node;
  CreateFoundFieldCellNode := node;
END;

{
  Appends a FieldCellNode to the end of the given list.
  
  @param
      list: the list to append the node to the end
  @param
      node: the node to be added to the end of the list
}
PROCEDURE AppendFoundFieldNode(list: FoundFieldList; node: FieldCellNode);
BEGIN
  node^.next := list;
  node^.prev := list^.prev;
  list^.prev^.next := node;
  list^.prev := node;
END;

{
  Destroys the given list.
  
  @param
      list: the list to be destroyed
   @return
      list: the destroyed list which will be NIL
}
PROCEDURE DestroyFoundCellList(VAR list: FoundFieldList);
VAR
  node, next: FieldCellNode;
BEGIN
  node := list^.next;
  WHILE (node <> list) DO BEGIN
    next := node^.next;
    Dispose(node);
    node := next;
  END;
  Dispose(node);
  list := NIL;
END;

{
  Appends the neighbours of the FieldCell of the given coordinates to the given list.
  
  @param
      x: the x axis coordinate
  @param
      y: the y axis coordinate
  @param
      count: the count for FieldCellNode instance
  @param
      list: the list to add the neighbours to the list
}
PROCEDURE AppendNeighbourFieldCells(x, y, count: INTEGER; list: FoundFieldList);
BEGIN
  { Append right neighbour cell if possible }
  IF (IsValidCoordinate((x + 1), y)) THEN BEGIN
    AppendFoundFieldNode(list, CreateFoundFieldCellNode(game.raster[y][x + 1], count));
  END;
  { Append left neighbour cell if possible }
  IF (IsValidCoordinate(x - 1, y)) THEN BEGIN
    AppendFoundFieldNode(list, CreateFoundFieldCellNode(game.raster[y][x - 1], count));
  END;
  { Append bottom neighbour cell if possible }
  IF (IsValidCoordinate(x, y + 1)) THEN BEGIN
    AppendFoundFieldNode(list, CreateFoundFieldCellNode(game.raster[y + 1][x], count));
  END;
  { Append top neighbour cell if possible }
  IF (IsValidCoordinate(x, y - 1)) THEN BEGIN
    AppendFoundFieldNode(list, CreateFoundFieldCellNode(game.raster[y - 1][x], count));
  END;
END;

{
  Deletes a FieldCellNode from the given list.
  
  @param
      list: the list to remove the element from
  @param
      node: the node to remove from the list
}
PROCEDURE DeleteFoundFieldNode(list: FoundFieldList; removeNode: FieldCellNode);
VAR
  node: FieldCellNode;
BEGIN
  node := list^.next;
  { Search for the cell }
  WHILE ((NOT IsSameField(node^.cell, removeNode^.cell)) AND (node <> list)) DO BEGIN
    node := node^.next;
  END;
  { If cell has been found }
  IF (node <> list) THEN BEGIN
    node^.prev^.next := node^.next;
    node^.next^.prev := node^.prev;
    node^.next := NIL;
    node^.prev := NIL;
    Dispose(node);
  END;
END;

{
  Gets the FieldCellNode instance for the given FieldCell.
  
  @param
      list: the list to search for the FieldCell
  @param
      cell: the FieldCell to search for
  @return
      the FoudnFieldNode instance, NIL if the FieldCell could not be found in the list
}
FUNCTION GetFoundFieldNode(list: FoundFieldList; cell: FieldCell): FieldCellNode;
VAR
  node: FieldCellNode;
BEGIN
  GetFoundFieldNode := NIL;
  node := list^.next;
  WHILE ((NOT IsSameField(node^.cell, cell)) AND (node <> list)) DO BEGIN
    node := node^.next;
  END;
  IF (node <> list) THEN BEGIN
    (* WriteLn('found node: ', node^.cell.x, ',', node^.cell.y); *)
    GetFoundFieldNode := node;
  END;
END;

{
  Cleans the temporary list by removing all elements of the target list which are present in the list and which fit the following condition.
  
  1. List contains element with the same coordinate and with a equal or lower count as the target element
  2. Target element is a wall
  
  @param
      target: the target to remove the elements of
  @param
      list: the list to compare the elements of
}
PROCEDURE CleanFoundCellList(target, list: FoundFieldList);
VAR
  node, next, temp: FieldCellNode;
BEGIN
  node := target^.next;
  WHILE (node <> target) DO BEGIN
    next := node^.next;
    { Delete element if it is a wall }
    IF (node^.cell.wall) THEN BEGIN
      DeleteFoundFieldNode(target, node);
    END
    { Else check for same coordinate and equal or higher value of target element compared to found list element}
    ELSE BEGIN
      temp := GetFoundFieldNode(list, node^.cell);
      IF ((temp <> NIL) AND (node^.count >= temp^.count)) THEN BEGIN
        DeleteFoundFieldNode(target, node);
      END;
    END;
    node := next;
  END;
END;

{
  Adds all elements of the source list to the end of the target list.
  
  @param
      target: the list to add elements on the end
  @param
      source: the list to add its element to the target list
}
PROCEDURE AddAllCellsToList(target, source: FoundFieldList);
VAR
  node: FieldCellNode;
BEGIN
  node := source^.next;
  WHILE (node <> source) DO BEGIN
    AppendFoundFieldNode(target, CreateFoundFieldCellNode(node^.cell, node^.count));
    node := node^.next;
  END;
END;

{
  Answers the question if the given lists contains the given FieldCell.
  
  @param
      list: the list to search for the FieldCell
  @param
      cell: the FieldCell to search on the list elements
  @return
      true if the given list contains the FieldCell, false otherwise
}
FUNCTION ContainsField(list: FoundFieldList; cell: FieldCell): BOOLEAN;
BEGIN  
  ContainsField := (GetFoundFieldNode(list, cell) <> NIL);
END;

{
 Implements the main function of the algorithm which is used to find the path to the position in the game field.
 
 @param
    node the node to work with
 @param
    visited: the FoundFieldList which gets elements added, if possible
 @param
    count the current count to set on the found fields
 @return
    visited: the FoundFieldList which maybe got modified
}
PROCEDURE HandleCurrentFoundCell(node: FieldCellNode; VAR visited: FoundFieldList);
VAR
  tempList: FoundFieldList;
BEGIN
    { WriteLn; }
    { WriteLn('current-node: ', node^.cell.x, ',', node^.cell.y); }
    { Create the temporary list }
    tempList := CreateFoundFieldCellNode(CreateRasterField(Low(xRange), Low(yRange), false, ''), -1);
    { WriteLn('created found node'); }
    { Add the neighbours to the temporary list }
    AppendNeighbourFieldCells(node^.cell.x, node^.cell.y, (node^.count + 1), tempList);
    { WriteLn('appended neighbours'); }
    { Clean the temporary list }
    CleanFoundCellList(tempList, visited);
    { WriteLn('cleaned temp'); }
    { Append remaining items to the visited list }
    AddAllCellsToList(visited, tempList);
    { WriteLn('added cells to visited'); }
    { Destroy the temporary list }
    DestroyFoundCellList(tempList);
    { WriteLn('destroyed temp'); }
END;

{
   Gets the shortest path by comparison  of the neighbour fields if they have a lower count value.
   
   @param
       foundCell: the found FieldCellNode instance
  @param
     list: The list which has to contain the calculated neighbours
  @return
     the lowest count value of the path
}
FUNCTION GetShortestCountOfNeighbours(foundCell: FieldCellNode; list: FoundFieldList): INTEGER;
VAR
  x, y, count: INTEGER;
  found: FieldCellNode;
  cell: FieldCell;
BEGIN
  x := 0;
  y := 0;
  count := foundCell^.count;
      
  { Get count value of right neighbour }
  x := foundCell^.cell.x + 1;
  y := foundCell^.cell.y;
  IF (IsValidCoordinate(x, y)) THEN BEGIN
    cell := CreateRasterField(x, y, false, '');
    found := GetFoundFieldNode(list, cell);
    IF ((found <> NIL) AND (found^.count < count)) THEN BEGIN
      count := found^.count;
    END;
  END;
  
  { Get count value of left neighbour }
  x := foundCell^.cell.x - 1;
  y := foundCell^.cell.y;
  IF (IsValidCoordinate(x, y)) THEN BEGIN
    cell := CreateRasterField(x, y, false, '');
    found := GetFoundFieldNode(list, cell);
    IF ((found <> NIL) AND (found^.count < count)) THEN BEGIN
      count := found^.count;
    END;
  END;
  
  { Get count value of top neighbour }
  x := foundCell^.cell.x;
  y := foundCell^.cell.y + 1;
  IF (IsValidCoordinate(x, y)) THEN BEGIN
    cell := CreateRasterField(x, y, false, '');
    found := GetFoundFieldNode(list, cell);
    IF ((found <> NIL) AND (found^.count < count)) THEN BEGIN
      count := found^.count;
    END;
  END;
  
  { Get count value of top neighbour }
  x := foundCell^.cell.x;
  y := foundCell^.cell.y - 1;
  IF (IsValidCoordinate(x, y)) THEN BEGIN
    cell := CreateRasterField(x, y, false, '');
    found := GetFoundFieldNode(list, cell);
    IF ((found <> NIL) AND (found^.count < count)) THEN BEGIN
      count := found^.count;
    END;
  END;
  
  GetShortestCountOfNeighbours := count;
END;

{ ###################### Public Functions and Procedures ###################### }
{ Reset the memory }
PROCEDURE Reset;
VAR
  i, j: INTEGER;
BEGIN
  FOR i := Low(yRange) TO High(yRange) DO BEGIN
    FOR j := Low(xRange) TO High(xRange) DO BEGIN
      game.raster[i][j] := CreateRasterField(j, i, false, '.');
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
      Write(game.raster[i][j].symbol:3);
    END;
    WriteLn;
  END;
END;

{ Sets a raster field as a wall or empty }
PROCEDURE SetCell(x: xRange; y: yRange; wall: BOOLEAN);
VAR
  s: STRING;
BEGIN
  IF (wall) THEN BEGIN
    s := '#'
  END
  ELSE BEGIN
    s := '.';
  END;
  game.raster[y][x] := CreateRasterField(x, y, wall, s);
END; 

{ TODO: Checks for path exists }
FUNCTION PathExists(ax: xRange; ay: yRange; bx: xRange; by: yRange): BOOLEAN;
  FUNCTION Exists(goal: FieldCell; VAR node: FieldCellNode; VAR visited: FoundFieldList): BOOLEAN;
  BEGIN 
    { If last element has been reached }
    IF (node = visited) THEN BEGIN
      Exists := false;
      (* WriteLn('could not find path'); *)
    END
    { If start is part of the visited list after first iteration }
    ELSE IF (IsSameField(goal, node^.cell)) THEN BEGIN
      Exists := true;
      (* WriteLn('found node recursive: ', node^.cell.x, ',', node^.cell.y); *)
    END
    { Search for start position }
    ELSE BEGIN
      HandleCurrentFoundCell(node, visited);
      (* WriteLn('new count: ', count); *)
      Exists := Exists(goal, node^.next, visited);
    END;
  END;
VAR
  visited: FoundFieldList;
  goal, start: FieldCell;
BEGIN  
  start := game.raster[ay][ax];
  goal := game.raster[by][bx];
  
  { Set symbol to see the start and goal on the game field }
  start.symbol := 'S';
  game.raster[ay][ax] := start;
  goal.symbol := 'G';
  game.raster[by][bx] := goal;

  IF (start.wall) THEN BEGIN
    start.symbol := 'SW';
    game.raster[ay][ax] := start;
  END
  ELSE IF (goal.wall) THEN BEGIN
    goal.symbol := 'GW';
    game.raster[by][bx] := goal;
  END;
  
  { If one of the given cells is a wall break here }
  IF ((start.wall) OR (goal.wall) OR (IsSameField(goal, start))) THEN BEGIN
    PathExists := false;
  END
  { Else try to find out the path to the position }
  ELSE BEGIN  
    visited := CreateFoundFieldCellNode(goal, -1); 
    AppendFoundFieldNode(visited, CreateFoundFieldCellNode(start, 0));
    PathExists := Exists(goal, visited^.next, visited); 
    DestroyFoundCellList(visited);     
  END;  
END;

{ Checks for path exists } 
FUNCTION PathExistsIt(ax: xRange; ay: yRange; bx: xRange; by: yRange): BOOLEAN;
VAR
  visited: FoundFieldList; 
  node: FieldCellNode;
  goal, start: FieldCell;
BEGIN
  start := game.raster[ay][ax];
  goal := game.raster[by][bx];

  { Set symbol to see the start and goal on the game field }
  start.symbol := 'S';
  game.raster[ay][ax] := start;
  goal.symbol := 'G';
  game.raster[by][bx] := goal;

  IF (start.wall) THEN BEGIN
    start.symbol := 'SW';
    game.raster[ay][ax] := start;
  END
  ELSE IF (goal.wall) THEN BEGIN
    goal.symbol := 'GW';
    game.raster[by][bx] := goal;
  END;

  { If one of the given cells is a wall break here }
  IF ((start.wall) OR (goal.wall) OR (IsSameField(goal, start))) THEN BEGIN
    PathExistsIt := false;
  END
  { Else try to find out the path to the position }
  ELSE BEGIN  
    visited := CreateFoundFieldCellNode(goal, -1); 
    AppendFoundFieldNode(visited, CreateFoundFieldCellNode(start, 0));
    
    node := visited^.next;
    WHILE ((node <> visited) AND (NOT IsSameField(node^.cell, goal))) DO BEGIN  
      HandleCurrentFoundCell(node, visited);
      node := node^.next;
    END;
    PathExistsIt := (node <> visited);
    (* IF (node <> visited) THEN BEGIN
      WriteLn('found node iterative: ',node^.cell.x, ',', node^.cell.y);
    END; *)
    DestroyFoundCellList(visited);
  END;
END;

{ Gets the shortest path length }
FUNCTION ShortestPathLength(ax: xRange; ay: yRange; bx: xRange; by: yRange): INTEGER;
VAR
  visited: FoundFieldList; 
  node: FieldCellNode;
  goal, start: FieldCell;
  s: STRING;
BEGIN
  ShortestPathLength := -1;
  start := game.raster[ay][ax];
  goal := game.raster[by][bx];

  { Set symbol to see the start and goal on the game field }
  goal.symbol := 'G';
  game.raster[by][bx] := goal;

  IF (goal.wall) THEN BEGIN
    goal.symbol := 'GW';
    game.raster[by][bx] := goal;
  END;
  
  { If one of the given cells is a wall break here }
  IF ((NOT start.wall) AND (NOT goal.wall) AND (NOT IsSameField(goal, start))) THEN BEGIN
    visited := CreateFoundFieldCellNode(goal, -1); 
    AppendFoundFieldNode(visited, CreateFoundFieldCellNode(start, 0));
    
    node := visited^.next;
    WHILE ((node <> visited) AND (NOT IsSameField(node^.cell, goal))) DO BEGIN
      { WriteLn('x: ', node^.cell.x, ' y: ', node^.cell.y, ' count: ', node^.count); }
      Str(node^.count, s);
      game.raster[node^.cell.y][node^.cell.x] := CreateRasterField(node^.cell.x, node^.cell.y, false, s); 
      HandleCurrentFoundCell(node, visited);
      node := node^.next;
    END;
    IF (node <> visited) THEN BEGIN
      { WriteLn('x: ', node^.cell.x, ' y: ', node^.cell.y, ' count: ', node^.count); }
      ShortestPathLength := GetShortestCountOfNeighbours(node, visited) + 1;
    END;
    DestroyFoundCellList(visited);
  END;
END;

BEGIN
  { Creates a empty game field }
  Reset;
END.