PROGRAM BinaryTreeExamples;

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

{
  Gets the node with the hghest value.
}
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

{
  Got no idea who do it different, means in one single function !!!!!!!!!!!
}
FUNCTION SumLowestAndHighestValue(VAR Tree: TreePtr): INTEGER;
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


VAR
  tree: TreePtr;
BEGIN
  tree := NIL;
  AddToTreeSorted(tree, CreateTreeNode(5));
  AddToTreeSorted(tree, CreateTreeNode(4));
  AddToTreeSorted(tree, CreateTreeNode(2));
  AddToTreeSorted(tree, CreateTreeNode(8));
  AddToTreeSorted(tree, CreateTreeNode(7));
  AddToTreeSorted(tree, CreateTreeNode(6));
  AddToTreeSorted(tree, CreateTreeNode(10));
  // All right then all left
  DisplayTree(tree);
  // Node with highest value
  writeln;
  Writeln('Node shall have data=10 and has data=', GetHighestDataNode(tree)^.data);
  
  // Sum lowest and highest value
  writeln;
  Writeln('Sum shall be 12 and is ', SumLowestAndHighestValue(tree));
END.