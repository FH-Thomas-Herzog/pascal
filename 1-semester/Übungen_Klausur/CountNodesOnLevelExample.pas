PROGRAM CountNodesOnLevelExample;

TYPE
  TreeNode = ^TreeNodeRecord;
  TreeNodeRecord = RECORD
    left, right: TreeNode;
    value: INTEGER;
  END;
  Tree = TreeNode;
{
  Creates a new TreeNode isntance.
  
  @param
      value: the value to be set on the treeNoe instance
  @return
      the TreeNode instance
}
FUNCTION CreateTreeNode(value: INTEGER): TreeNode;
VAR
  node: TreeNode;
BEGIN
  New(node);
  node^.value := value;
  node^.left := NIL;
  node^.right := NIL;
  CreateTreeNode := node;
END;

{
  Adds a TreeNode to the Tree.
  The tree will be sorted afterwards.
  
  @param
      node: the node to be added to the Tree
}
PROCEDURE AddTreeNode(VAR tr: Tree; value: INTEGER);
VAR
  node, subtree, parent: TreeNode;
BEGIN
  node := CreateTreeNode(value);
  IF (tr = NIL) THEN BEGIN
    tr := node;
  END
  ELSE BEGIN
    parent := NIL;
    subtree := tr;
    WHILE (subtree <> NIL) DO BEGIN
      parent := subtree;
      IF (node^.value < subtree^.value) THEN BEGIN
        subtree := subtree^.left;
      END
      ELSE BEGIN
        subtree := subtree^.right;
      END;
    END;
    IF (node^.value < parent^.value) THEN BEGIN
      parent^.left := node;
    END
    ELSE BEGIN
      parent^.right := node;
    END;
  END;
END;

{
  Counts the nodes on a particular level of the given tree 
}
FUNCTION countNodesOnLevel(t: Tree; level: INTEGER): INTEGER;
  FUNCTION count(t: Tree; level: INTEGER; currentLevel: INTEGER): INTEGER;
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

VAR
  t: Tree;
BEGIN
  t := NIL;
  AddTreeNode(t, 5);
  AddTreeNode(t, 4);
  AddTreeNode(t, 3);
  AddTreeNode(t, 6);
  AddTreeNode(t, 5);
  AddTreeNode(t, 7);
  AddTreeNode(t, 8);
  AddTreeNode(t, 7);
  AddTreeNode(t, 9);
  WriteLn('nodes on level: ', countNodesOnLevel(t, 0));
END.