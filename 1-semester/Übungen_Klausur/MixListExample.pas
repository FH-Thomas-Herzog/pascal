PROGRAM MixListsExample;

TYPE
  ListNode = ^NodeRecord;
  NodeRecord =  RECORD
    next: ListNode;
    value: INTEGER;
  END;
  ListPtr = ListNode;

{
  Creates a new node via New operator.
}
FUNCTION createNode(value: INTEGER): ListNode;
VAR
  node: ListNode;
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
  node, element: ListNode;
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
  node : ListNode;
BEGIN
  IF (list <> NIL) THEN BEGIN
    node := list;
    WHILE (node <> NIL) DO BEGIN
      writeln(node^.value);
      node := node^.next;
    END;
  END;
END;

{
  Swaps the two given nodes of the list
}
PROCEDURE SwapNodes(VAR prevLeft, nodeLeft, prevRight, nodeRight: ListNode);
VAR
  temp: ListNode;
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

PROCEDURE SelectionSort(VAR list: ListPtr);
VAR
  prevL, nodeL, prevR, nodeR: ListNode;
  value: INTEGER;
  first: BOOLEAN;
BEGIN
  IF (list <> NIL) THEN BEGIN
    prevL := NIL;
    prevR := NIL;
    nodeR := NIL;
    nodeL := list;
    first:=true;
    
    WHILE (nodeL <> NIL) DO BEGIN
      prevR := NIL;
      nodeR := nodeL^.next;
      value := nodeL^.value;
      // Sort following
      WHILE (nodeR <> NIL) DO BEGIN
        IF (nodeR^.value <= value) THEN BEGIN
          SwapNodes(prevL, nodeL, prevR, nodeR);
          value := nodeL^.value;        
        END;
        prevR := nodeR;
        nodeR := nodeR^.next;
      END;
      IF (first) THEN BEGIN
        list := nodeL;
        first := false;
      END;
      prevL := nodeL;
      nodeL := nodeL^.next;
    END;
  END;
END;

PROCEDURE mergeListSorted(list1, list2: ListPtr; VAR merged: ListPtr);
VAR
  node1, node2: ListNode;
BEGIN
  merged := NIL;
  node1 := NIL;
  node2 := NIL;
  // Get last of first list
  IF (list1 <> NIL) THEN BEGIN
    node1 := list1;
    WHILE (node1^.next <> NIL) DO BEGIN
      node1 := node1^.next
    END;
  END;
  // Get last of second list
  IF (list2 <> NIL) THEN BEGIN
    node2 := list2;
    WHILE (node2^.next <> NIL) DO BEGIN
      node2 := node2^.next
    END;
  END;
  // Add second list to first list if first list is not nil
  IF (node1 <> NIL) THEN BEGIN
    merged := list1;
    node1^.next := list2;
  END
  // Add first list to second list if second list is not nil
  ELSE IF (node2 <> NIL) THEN BEGIN
    merged := list2;
    node2^.next := list1;
  END;
  
  SelectionSort(merged);
END;

VAR
  list1, list2, list3: ListPtr;
BEGIN
  list1 := NIL;
  list2 := NIL;
  list3 := NIL;
  
  appendNode(list1, 1);
  appendNode(list1, 8);
  appendNode(list1, 5);
  appendNode(list1, 4);
  appendNode(list1, 0);
  
  appendNode(list2, 22);
  appendNode(list2, 20);
  appendNode(list2, 10);
  appendNode(list2, 9);
  appendNode(list2, 11);
  writeln;
  writeln('sorted');
  mergeListSorted(list1, list2, list3);
  writeln('List 1: ');
  PrintList(list1);
  writeln;
  writeln('List 2: ');
  PrintList(list2);
  writeln;
  writeln('List 3: ');
  PrintList(list3);
END.