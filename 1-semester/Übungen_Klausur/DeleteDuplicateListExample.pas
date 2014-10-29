PROGRAM SplitListExample;
TYPE
  Node = ^NodeRec;
  NodeRec = RECORD
    value: INTEGER;
    next: Node;
  END;
  List = Node;

{
  Helper for creating a node.
}
FUNCTION CreateNode(value: INTEGER): Node;
VAR
  n: Node;
BEGIN
  New(n);
  n^.value := value;
  n^.next := NIL;
  CreateNode := n;

END;

{
  Appends the given node to the given list
}
PROCEDURE AppendToList(VAR l: List; n: Node);
VAR
  el: Node;
BEGIN
  IF (n <> NIL) THEN BEGIN
    // Next must be set to NIL would otherwise add all elements following
    n^.next := NIL;
    // If list is NIL this is the first element
    IF (l = NIL) THEN
      l := n
    // Otherwise go to last element
    // Could be inserted at the beginning as well
    ELSE BEGIN
      el := l;
      WHILE (el^.next <> NIL) DO BEGIN
        el := el^.next;
      END;
      // Append at the end
      el^.next := n;
    END;
  END;
END;

{
  Helper for printing the list
}
PROCEDURE DisplayList(l: List);
BEGIN
  WHILE l <> NIL DO BEGIN
    Write(l^.value, ' ');
    l := l^.next;
  END;
  WriteLn;
END;

// ################## Here are the procedures and function for the test ############################
PROCEDURE DeleteDuplicates(VAR l: List);
VAR
  prev, n: Node;
BEGIN
  IF (l <> NIL) THEN BEGIN
    prev := NIL;
    n := l;
    WHILE (n <> NIL) DO BEGIN
      IF (prev <> NIL) AND (prev^.value = n^.value) THEN BEGIN
        prev^.next := n^.next;
        Dispose(n);
        n := prev^.next;
      END
      ELSE BEGIN
        prev := n;
        n := n^.next;
      END;
    END;
  END;
END;


VAR
  i: INTEGER;
  l: List;
BEGIN
  // Init lists
  l := NIL;
  FOR i := 1 TO 10 DO BEGIN
    AppendToList(l, CreateNode(i));
    AppendToList(l, CreateNode(i));
    AppendToList(l, CreateNode(i));
    AppendToList(l, CreateNode(i));
  END;
    
  // Print original list after modification
  writeln;
  writeln('original list');
  DisplayList(l);
  DeleteDuplicates(l);
  DisplayList(l);
  
END.