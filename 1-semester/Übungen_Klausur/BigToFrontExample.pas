PROGRAM SelectionSortListExample;


TYPE
  NodePtr = ^NodeRecord;
  NodeRecord = RECORD 
    value: INTEGER;
    next: NodePtr;
  END;
  ListPtr = NodePtr;

{
  Creates a new node via New operator.
}
FUNCTION createNode(value: INTEGER): NodePtr;
VAR
  node: NodePtr;
BEGIN
  New(node);
  node^.value := value;
  node^.next := NIL;
  createNode := node;
END;

{
  Appends an element to the given list.
  Creates the node out from the value
}
PROCEDURE appendNode(VAR list: ListPtr; value: INTEGER);
VAR
  node, element: NodePtr;
BEGIN
  node := createNode(value);
  IF (list = NIL) THEN BEGIN
    list := node;
  END
  ELSE BEGIN
    element := list;
    WHILE (element^.next <> NIL) DO BEGIN
      element := element^.next;
    END;
    element^.next := node;
  END;
END;

{
  ^Prints the list node values
}
PROCEDURE PrintList(list: ListPtr);
VAR
  node : NodePtr;
BEGIN
  IF (list <> NIL) THEN BEGIN
    node := list;
    WHILE (node <> NIL) DO BEGIN
      writeln(node^.value);
      node := node^.next;
    END;
  END;
END;

{ ########################## Implementation ############################# }
PROCEDURE BigToFront(VAR l: ListPtr; searchVal: INTEGER);
VAR
  prev, current: NodePtr;
BEGIN
  IF (l <> NIL) THEN BEGIN
    prev := NIL;
    current := l;
    WHILE (current <> NIL) AND (current^.value <> searchVal) DO BEGIN
      prev := current;
      current := current^.next;
    END;
    IF (current <> NIL) THEN BEGIN
      IF (prev <> NIL) THEN BEGIN
        prev^.next := current^.next;
      END;
      current^.next := l;
      l := current;
    END;
  END;
END;

VAR
  list: ListPtr;
BEGIN
  list := NIL;
  appendNode(list, 10);
  appendNode(list, 9);
  appendNode(list, 12);
  appendNode(list, 11);
  appendNode(list, 13);
  appendNode(list, 20);
  appendNode(list, 21);
  writeln;
  writeln('original');
  PrintList(list);
  
  writeln;
  writeln('Modified');
  BigToFront(list, 11);
  PrintList(list);
  
  writeln('sadf ', 2.12452145:2:2);
END.
