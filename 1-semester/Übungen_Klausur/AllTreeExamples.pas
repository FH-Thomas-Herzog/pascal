PROGRAM AllTreeExamples;

TYPE
  TreeNodePtr = ^TreeNodeRecord;
  TreePtr = TreeNodePtr;
  TreeNodeRecord = RECORD
    data: INTEGER;
    left: TreePtr;
    right: TreePtr;
  END;

FUNCTION CreateTreeNode(data: INTEGER): TreeNodePtr;
VAR
  node: TreeNodePtr;
BEGIN
  New(node);
  node^.data := data;
  node^.left := NIL;
  node^.right := NIL;
  CreateTreeNode := node;
END;

PROCEDURE DisplayTree(tr: TreePtr);
BEGIN
  IF (tr <> NIL) THEN BEGIN 
    Write(tr^.data, ' ');
    DisplayTree(tr^.right); 
    DisplayTree(tr^.left);
  END
END;

PROCEDURE DisposeTree(VAR tr: TreePtr);
BEGIN
  IF (tr <> NIL) THEN BEGIN 
    DisplayTree(tr^.right); 
    DisplayTree(tr^.left);
    Dispose(tr);
  END
END;

PROCEDURE AddToTreeSorted(VAR tree: TreePtr; node: TreeNodePtr);  
VAR
  parent, t: TreePtr;
BEGIN
  // In this case node is root
  IF (tree = NIL) THEN BEGIN
    tree := node;
  END
  // Otherwise get node where to add the given node
  ELSE BEGIN
    // Need parent to kepp it otherwise no add possible
    parent := NIL;
    t := tree;
    WHILE (t <> NIL) DO BEGIN
      parent := t;
      // Data smaller then node.data go left
      IF (node^.data < t^.data) THEN BEGIN
        t := t^.left;
      END
      // Data greater then node.data go left
      ELSE BEGIN
        t := t^.right;
      END;
    END;
    
    // Append node to proper site
    IF (node^.data < parent^.data) THEN BEGIN
      parent^.left :=node;
    END
    ELSE BEGIN
      parent^.right := node;
    END;
  END;
END;


// ################## Reference to node with highest value ############################
FUNCTION GetHighestDataNode(VAR tree: TreePtr): TreeNodePtr;
BEGIN
  // No nodes then reslt is NIL
  IF (tree = NIL) THEN
    GetHighestDataNode := NIL
  // We know in a sorted binary tree the node with the highest
  // value is always the last node on the right site
  ELSE IF (tree^.right <> NIL) THEN
    GetHighestDataNode := GetHighestDataNode(tree^.right)
  // If the node has no right child, then we found it
  ELSE
    GetHighestDataNode := tree;
END;


// ################## Sum lowest and highest value ############################
FUNCTION SumLowestAndHighestValue(VAR tree: TreePtr): INTEGER;
  FUNCTION GetLastNode(VAR t: TreePtr; left: BOOLEAN): INTEGER;
  BEGIN
    // No nodes return 0
    IF (t = NIL) THEN 
      GetLastNode := 0;
    // IF left node is meant get the lowest value
    IF (left) THEN BEGIN
      // Until left node not reached go to it
      IF (t^.left <> NIL) THEN
        GetLastNode := GetLastNode(t^.left, left)
      // Get lowest value of last left node
      ELSE
        GetLastNode := t^.data;
    END 
    // Get highest value
    ELSE BEGIN
      IF (t^.right <> NIL) THEN
        GetLastNode := GetLastNode(t^.right, left)
      ELSE
        GetLastNode := t^.data;
    END
  END;
VAR
  t: TreePtr;
BEGIN
  t := tree;
  SumLowestAndHighestValue := GetLastNode(t, true) + GetLastNode(t, false);
END;


// ################## Counts all nodes in the tree ############################
FUNCTION countNodesOnLevel(t: TreePtr; level: INTEGER): INTEGER;
  FUNCTION count(t: TreePtr; level: INTEGER; currentLevel: INTEGER): INTEGER;
  BEGIN
    // No further nodes present
    IF (t = NIL) THEN BEGIN
      count := 0;
    END
    // level reached where nodes shall be count
    ELSE IF (level = currentLevel) THEN BEGIN 
      count := 1; 
    END
    // over steped intended level
    ELSE IF (currentLevel > level) THEN BEGIN 
      count := 0;
    END
    // If level not reached keep going
    ELSE BEGIN 
      Inc(currentLevel);
      count := count(t^.left, level, currentLevel) + count(t^.right, level, currentLevel);
    END;
  END;
  
VAR
  currentLevel: INTEGER;
BEGIN
  currentLevel := 0;
  countNodesOnLevel := count(t, level, currentLevel);
END;



// ################## Delete all leafs no nodes ############################
PROCEDURE DeleteAllLeafs(VAR tree: TreePtr);
BEGIN
  IF (tree <> NIL) THEN BEGIN
    // Check if left node has children, when yes delete it
    // and set references to the deleted nodes to NIL
    IF (tree^.left <> NIL) AND (tree^.left^.left = NIL) AND (tree^.left^.right = NIL) THEN BEGIN
      Dispose(tree^.left);
      tree^.left := NIL;
    END;
    // Check if right node has children, when yes delete it
    // and set references to the deleted nodes to NIL
    IF (tree^.right <> NIL) AND (tree^.right^.left = NIL) AND (tree^.right^.right = NIL) THEN BEGIN
      Dispose(tree^.right);
      tree^.right := NIL;
    END;
    DeleteAllLeafs(tree^.left);
    DeleteAllLeafs(tree^.right);
  END;
END;

// ################## Display in descending order ############################
PROCEDURE DisplayDescending(tr: TreePtr);
BEGIN
  IF (tr <> NIL) THEN BEGIN 
    DisplayDescending(tr^.right); 
    Write(tr^.data, ' ');
    DisplayDescending(tr^.left);
  END
END;

// ################## Find by value recursive ############################
FUNCTION FindByValueRecursive(VAR tree: TreePtr; value: INTEGER): TreeNodePtr;
BEGIN
  // Node not found by value return NIL
  IF (tree = NIL) THEN BEGIN
    FindByValueRecursive := NIL;
  END
  // If value is smaller then current node value go left
  ELSE IF (value < tree^.data) THEN BEGIN
    FindByValueRecursive := FindByValueRecursive(tree^.left, value);
  END
  // If value is greater as node value go right
  ELSE IF (value > tree^.data) THEN BEGIN
    FindByValueRecursive := FindByValueRecursive(tree^.right, value);
  END
  // Here we have found the node
  ELSE BEGIN
    FindByValueRecursive := tree;
  END;
END;

// ################## Find by value iterativ ############################
// Be aware only possible with linear recursive or end recursive algorithms.
// linear means we go a linear way to the to find node
// If no sorted binary treem we could not do that, because we would not know
// where to find the node and would have to visit all of the nodes
// which would be a non linear recursive algprotihm, here would need stacks
// ################## Find by value iterativ ############################
FUNCTION FindByValueIterative(tree: TreePtr; value: INTEGER): TreeNodePtr;
BEGIN
  // While loop contains recursive anchor and search condition as bool expression.
  // No need to care about the tree which gets set with its children during loop,
  // because it is no VAR parameter, means here we got a copy of the pointer
  // not the pointer which is used outside this function.
  WHILE (tree <> NIL) AND (tree^.data <> value) DO BEGIN
    // Decides to go left, same as in recursive implementation
    IF (value < tree^.data) THEN BEGIN
      tree := tree^.left;
    END
    // Else go right same as in recursive implementation
    ELSE BEGIN
     tree := tree^.right;
    END;
  END;
  
  // Here we got either NIL or the found node
  FindByValueIterative := tree;
END;

// ################## Calculate area recursive ############################
FUNCTION CalculateAreaRecursive(i:INTEGER; x:REAL): REAL;
BEGIN
  IF (i <= 0) THEN BEGIN
    CalculateAreaRecursive := 0;
  END;
  IF (i = 1) THEN BEGIN
    CalculateAreaRecursive := (x * x) / 2;
  END
  ELSE
    CalculateAreaRecursive := CalculateAreaRecursive(i - 1, 2 * x);
END;

// ################## Calculate area iterative ############################
FUNCTION CalculateAreaIterativ(i:INTEGER; x:REAL): REAL;
BEGIN
  
  // Need to check, otherwise Dec(i) would be always smaller than 1
  IF (i > 0) THEN BEGIN
    // Get trianlge site length for the intended iteration
    // Same as in former example, recursive anchor placed here
    WHILE (i <> 1) DO BEGIN
        Dec(i);
        x := 2 * x;
      END;
    // Claculate the area
    CalculateAreaIterativ := (x * x) / 2;
  END;
END;

// ################## lookup via morse code recursive ############################
FUNCTION LookUpRecursive(tree: TreePtr; code:STRING): INTEGER;
  FUNCTION look(VAR tree: TreePtr; idx: INTEGER; code: STRING): INTEGER;
  BEGIN
    // Pfad invalid or invalid character in string
    IF (tree = NIL) THEN
      look := -1
    // dot means go let
    ELSE IF (Length(code) = idx) THEN
      look := tree^.data
    // Here only - can occur, means go right
    ELSE IF (code[idx + 1] = '.') THEN
      look := look(tree^.left, idx + 1, code)
    // HEre we found it
    ELSE BEGIN
      look := look(tree^.right, idx + 1, code)
    END
  END;
VAR
  idx: INTEGER;
BEGIN
  // 0 because root needs to be ignored
  idx := 0;
  LookUpRecursive := look(tree, idx, code);
END;


// ################## lookup via morse code recursive ############################
FUNCTION LookUpIterative(tree: TreePtr; code: STRING): INTEGER;
VAR
  node: TreeNodePtr;
  i: INTEGER;
BEGIN
  node := tree;
  LookUpIterative := -1;
  i := 1;
  WHILE (node <> NIL) AND (i <= Length(code)) DO BEGIN
    IF (code[i] = '.') THEN
      node := node^.left
    ELSE
      node := node^.right;
    Inc(i);
  END;
  
  IF (node <> NIL) THEN
    LookUpIterative := node^.data;
END;


FUNCTION countValues(t: TreePtr): INTEGER;
  FUNCTION count(VAR t: TreePtr; VAR value: INTEGER): LONGINT;
  VAR l, r: INTEGER;
  BEGIN
    // No further nodes present
    IF (t = NIL) THEN BEGIN
      count := 0;
      Dec(value);
    END
    // If level not reached keep going
    ELSE BEGIN 
      Inc(value);
      l := count(t^.left, value);
      Inc(value);
      r := count(t^.right, value);
      count := t^.data + l + r;
    END;
  END;
  
VAR
  value, result: INTEGER;
BEGIN
  value := 1;
  Writeln(count(t, value));
  writeln('value: ', value);
  countValues := count(t, value)DIV value;
END;


VAR
  tree: TreePtr;
BEGIN
  tree := NIL;
  AddToTreeSorted(tree, CreateTreeNode(10));
  AddToTreeSorted(tree, CreateTreeNode(6));
  AddToTreeSorted(tree, CreateTreeNode(5));
  AddToTreeSorted(tree, CreateTreeNode(7));
  AddToTreeSorted(tree, CreateTreeNode(14));
  AddToTreeSorted(tree, CreateTreeNode(13));
  AddToTreeSorted(tree, CreateTreeNode(15));
  
  writeln('Descending order');
  DisplayDescending(tree);
  writeln;
  writeln;
  
  writeln('With leafs');
  DisplayTree(tree);
  DeleteAllLeafs(tree);
  writeln;
  writeln;
  writeln('Without leafs');
  DisplayTree(tree);
  writeln;
  
  writeln;
  DisposeTree(tree);
  tree := NIL;
  AddToTreeSorted(tree, CreateTreeNode(10));
  AddToTreeSorted(tree, CreateTreeNode(6));
  AddToTreeSorted(tree, CreateTreeNode(5));
  AddToTreeSorted(tree, CreateTreeNode(7));
  AddToTreeSorted(tree, CreateTreeNode(14));
  AddToTreeSorted(tree, CreateTreeNode(13));
  AddToTreeSorted(tree, CreateTreeNode(15));
  writeln('Tree to search');
  DisplayTree(tree);  
  writeln;
  writeln('Found node value: ', FindByValueRecursive(tree, 15)^.data);
  writeln('Found node value: ', FindByValueIterative(tree, 15)^.data);
  
  writeln;
  writeln;
  WriteLn('Area recursive: ', CalculateAreaRecursive(10, 1):5:5);
  WriteLn('Area iterativ: ', CalculateAreaIterativ(10, 1):5:5);


  writeln;
  DisposeTree(tree);
  tree := NIL;
  AddToTreeSorted(tree, CreateTreeNode(10));
  AddToTreeSorted(tree, CreateTreeNode(5));
  AddToTreeSorted(tree, CreateTreeNode(15));  
  writeln;
  writeln('found number in pfad recursive: ', LookUpRecursive(tree, '---.'));
  writeln('found number in pfad iterative: ', LookUpIterative(tree, '---.'));
  
  writeln(countValues(tree));
END.