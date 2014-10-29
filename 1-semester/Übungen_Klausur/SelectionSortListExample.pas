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

{ ########################## Implementation for selectoi sort ############################# }
{
  Swaps the two given nodes of the list
}
PROCEDURE SwapNodes(VAR prevLeft, nodeLeft, prevRight, nodeRight: NodePtr);
VAR
  temp: NodePtr;
BEGIN      
  // Hold this pointer, will get lost in next operation
  temp := nodeLeft^.next;
  nodeLeft^.next := nodeRight^.next;
  // Just if left node has a previous
  IF(prevLeft <> NIL) THEN BEGIN
    prevLeft^.next := nodeRight;
  END;
  // If nuil the nodeLeft and prevRight are the same node
  // Otherwise cirlce would be made
  IF (prevRight <> NIL) THEN BEGIN
    nodeRight^.next := temp;
    prevRight^.next := nodeLeft;
  END
  // If they are the same node, link nodeRight to nodeLeft
  ELSE BEGIN
    nodeRight^.next := nodeLeft;
  END;
  
  // Swap reference of the two nodes, so that left and right will
  // point to the swapped nodes otherwise the two pointer would 
  // point to the same node they were before the swapping
  temp := nodeLeft;
  nodeLeft := nodeRight;
  nodeRight := temp;
END;

{
  Sorts the list via selection sort 
}
PROCEDURE selectionSort(VAR list: ListPtr);
VAR 
  prevLeft, nodeLeft, prevRight, nodeRight: NodePtr;
  value: INTEGER;
  first: Boolean;
BEGIN
  IF (list <> NIL) THEN BEGIN
    // Init the pointers
    prevLeft := NIL;
    prevRight := NIL;
    nodeRight := NIL;
    nodeLeft := list;
    // Go over all list elements
    WHILE (nodeLeft <> NIL) DO BEGIN
      // Init pointer for inner loop
      // preRight nil means preRight and nodeLeft are the same
      prevRight := NIL;
      nodeRight := nodeLeft^.next;
      value := nodeLeft^.value;
      // Go over all following list elements
      WHILE (nodeRight <> NIL) DO BEGIN  
        // Swap and set swaped value
        IF (nodeRight^.value <= value) THEN BEGIN
          SwapNodes(prevLeft, nodeLeft, prevRight, nodeRight);
          value := nodeLeft^.value;
        END;
        prevRight := nodeRight; 
        nodeRight := nodeRight^.next;
      END;
      // If first node has been swapped
      // list pointer needs to point to this node
      IF (first) THEN BEGIN
        list := nodeLeft;
        first := false;
      END;
      prevLeft := nodeLeft; 
      nodeLeft := nodeLeft^.next;
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
  appendNode(list, 12);
  appendNode(list, 11);
  appendNode(list, 11);
  appendNode(list, 1);
  writeln;
  writeln('Unsorted');
  PrintList(list);
  
  writeln;
  writeln('Sorted');
  selectionSort(list);
  PrintList(list);
END.
