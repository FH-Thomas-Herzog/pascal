PROGRAM BinarySeachrTree;
TYPE
  TreeNode = ^NodeRec;
  NodeRec = RECORD
    value: INTEGER;
    left: TreeNode;
    right: TreeNode;
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
  Inits the given tree by setting the given Tree to NIL.
  
  @param
      tr: the Tree to be initialized
  @return
      the initialized Tree which will be NIL
}
PROCEDURE InitTree(VAR tr: Tree);
BEGIN
  tr := NIL;
END;

{
  Displays the TreeNodes.
  
  @param
      tr: the tree which Nodes shall be displayed
}
PROCEDURE DisplayTree(tr: Tree);
BEGIN
  IF (tr <> NIL) THEN BEGIN 
    { Pre-Order }
    (* 
    Write(tr^.value, ' ');
    DisplayTree(tr^.left);
    DisplayTree(tr^.right); 
    *)
    { In-Order }
    (* 
    DisplayTree(tr^.left);
    Write(tr^.value, ' ');
    DisplayTree(tr^.right); 
    *)
    
    { Post-Order }
     DisplayTree(tr^.left);
    DisplayTree(tr^.right);
    Write(tr^.value, ' '); 
    
    { REVERSE }
    { Pre-Order }
    (* 
    Write(tr^.value, ' ');
    DisplayTree(tr^.right); 
    DisplayTree(tr^.left);
    *)
    
    (*
    { In-Order }
    DisplayTree(tr^.right);
    Write(tr^.value, ' '); 
    DisplayTree(tr^.left);
    *)

    { Post-Order }
    (* 
    DisplayTree(tr^.right);
    DisplayTree(tr^.left);
    Write(tr^.value, ' '); 
    *)
  END
END;

{
  Disposes the given tree by deleting all TreeNodes.
  
  @param
      tr: the Tree to be disposed
}
PROCEDURE DisposeTree(VAR tr: Tree);
BEGIN
  { Tr is presetn}
  IF (tr <> NIL) THEN BEGIN
    { Dispose lef tree of given tree }
    DisposeTree(tr^.left);
    { Dispose right tree of given tree }
    DisposeTree(tr^.right);
    { Dispoes the given tree }
    Dispose(tr);
    { Set given Tree pointer to NIL }
    tr := NIL;
  END
END;

(*
{
  Adds a TreeNode to the Tree.
  The tree will be sorted afterwards.
  
  @param
      node: the node to be added to the Tree
}
PROCEDURE AddTreeNode(VAR tr: Tree; node: TreeNode);
BEGIN
  { Tree is empty }
  IF (tr = NIL) THEN BEGIN
    tr := node;
  END
  { If node value is greate than the current tr value go left }
  ELSE IF (node^.value < tr^.value) THEN BEGIN
    AddTreeNode(tr^.left, node);    
  END
  { If node value is greate than the current tr value go right }
  ELSE BEGIN
    AddTreeNode(tr^.right, node);
  END
END;
*)

{
  Adds a TreeNode to the Tree.
  The tree will be sorted afterwards.
  
  @param
      node: the node to be added to the Tree
}
PROCEDURE AddTreeNode(VAR tr: Tree; node: TreeNode);
VAR
  subtree, parent: TreeNode;
BEGIN
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

(*
{
  Searches for the value in TreeNode on the TreeNode.
  
  @param
      value: the value to search for
  @return
      true if the value could be found on a TreeNode, false otherwise
}
FUNCTION ContainsValue(tr: Tree; value: Integer): Boolean;
BEGIN
  { Tree is empty }
  IF (tr = NIL) THEN BEGIN
    ContainsValue := false;
  END
  { search in left tree }
  ELSE IF (value < tr^.value) THEN BEGIN
    ContainsValue := ContainsValue(tr^.left, value);
  END
  { search in right tree }
  ELSE IF (value >= tr^.value) THEN BEGIN
    ContainsValue := ContainsValue(tr^.left, value);
  END
  ELSE BEGIN
    ContainsValue := true;
  END;
END;
*)

{
  Searches for the value in TreeNode on the TreeNode.
  
  @param
      value: the value to search for
  @return
      true if the value could be found on a TreeNode, false otherwise
}
FUNCTION ContainsValue(tr: Tree; value: Integer): Boolean;
BEGIN
  WHILE (tr <> NIL) AND (value <> tr^.value) DO BEGIN
    { search in left tree }
    IF (value < tr^.value) THEN BEGIN
      tr := tr^.left;
    END
    { search in right tree }
    ELSE IF (value >= tr^.value) THEN BEGIN
      tr := tr^.right;
    END;
  END;
  ContainsValue := tr <> NIL;
END;

(* 
{ Not good enaough for binary search tree }
FUNCTION ContainsValue(tr: Tree; value: Integer): Boolean;
BEGIN
  { Tree is empty }
  IF (tr = NIL) THEN BEGIN
    ContainsValue := false;
  END
  ELSE BEGIN
    ContainsValue := (tr^.value = value) OR (ContainsValue(tr^.left, value)) OR (ContainsValue(tr^.right, value));
  END;
END;
*)

VAR
  t: Tree;
BEGIN
  InitTree(t);
 
  AddTreeNode(t, CreateTreeNode(1));
   AddTreeNode(t, CreateTreeNode(2));
   AddTreeNode(t, CreateTreeNode(3));
   AddTreeNode(t, CreateTreeNode(4));
   AddTreeNode(t, CreateTreeNode(5));
   AddTreeNode(t, CreateTreeNode(6));
   AddTreeNode(t, CreateTreeNode(7));
   AddTreeNode(t, CreateTreeNode(8));
   DisplayTree(t);
   DisposeTree(t);
   WriteLn;
   
END.