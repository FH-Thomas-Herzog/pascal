PROGRAM CountTreeLeafsExample;

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
  Counts the tree leafs which the tree hast.
  The leafs are the nodes wihtout any following nodes.
}
FUNCTION count(VAR tree: Tree): INTEGER;
BEGIN
  IF (tree = NIL) THEN BEGIN
    count := 0;
  END
  ELSE IF (tree^.left = NIL) AND (tree^.right = NIL) THEN BEGIN
    count := 1;
  END
  ELSE BEGIN
    count := count(tree^.left) + count(tree^.right);
  END;
END;

{
  Kann nicht ohne Stack in eine iterative Implementierung umgewandelt werden,
  da es sich hier um einen nicht linearen rekursiven Algorithmus handelt.
  Es müsen alle Knoten des Baumes besucht werden, um herauszufinden wie viele
  Blätter es in diesem Baum gibt.
}

{
  Um einen rekursiven Algorithmus iterativ ohne Stack implementieren zu können.
  Muss es sich um einen linearen (opt. endrekursiven) Algorithmus handeln.
  Bei nicht linearen rekursiven Algorithmen (im Baum jeder Knoten muss besucht werden),
  ist ein Stack notwendig, da hier ansonsten die Information des anderen weges verloren gehen würde. 
}
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
  WriteLn('Leafs: ', count(t));
END.