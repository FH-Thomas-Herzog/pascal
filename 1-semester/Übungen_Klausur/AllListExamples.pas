PROGRAM AllListExamples;

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

// ################## Delete Duplicates ############################
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

// ################## Split even and odd ############################
{
  Checks if value is a even one.
}
FUNCTION IsEven(val: INTEGER): BOOLEAN;
BEGIN
  IsEven := (val MOD 2) = 0;
END;

{
  Split list.
}
PROCEDURE Split(VAR l, even, odd: List);
VAR
  el, temp: Node;
BEGIN
  IF (l <> NIL) THEN BEGIN
    el := l;
    WHILE (el <> NIL) DO BEGIN
      // Hold next because gets set NIL during append
      temp := el^.next;
      // Append if even to even list
      IF (IsEven(el^.value)) THEN
        AppendToList(even, el)
      // Else append to odd list
      ELSE
        AppendToList(odd, el);
      // Set hold next 
      el := temp;
    END;
    // Set list nill here it is already empty, but would point either to even
    // or odd list, because is no anchor element.
    l := NIL;
  END;
END;

// ################## Merge List sorted, selectionSort ############################
{
  Swaps the two given nodes of the list
}
PROCEDURE SwapNodes(VAR prevLeft, nodeLeft, prevRight, nodeRight: Node);
VAR
  temp: Node;
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

PROCEDURE SelectionSort(VAR l: List);
VAR
  prevL, nodeL, prevR, nodeR: Node;
  value: INTEGER;
  first: BOOLEAN;
BEGIN
  IF (l <> NIL) THEN BEGIN
    prevL := NIL;
    prevR := NIL;
    nodeR := NIL;
    nodeL := l;
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
        l := nodeL;
        first := false;
      END;
      prevL := nodeL;
      nodeL := nodeL^.next;
    END;
  END;
END;

PROCEDURE mergeListSorted(list1, list2: List; VAR merged: List);
VAR
  node1, node2: Node;
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


// ################## Sum all List node values ############################
FUNCTION SumAllNodeValues(VAR l: List): Integer;
BEGIN
  IF (l = NIL) THEN
    SumAllNodeValues := 1
  ELSE 
    SumAllNodeValues := SumAllNodeValues(l^.next) * l^.value;
END;

// ################## BigToFront ############################
PROCEDURE BigToFront(VAR l: List; searchVal: INTEGER);
VAR
  prev, current: Node;
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
  l: List;
BEGIN
  AppendToList(l, CreateNode(1));
  AppendToList(l, CreateNode(2));
  AppendToList(l, CreateNode(3));
  AppendToList(l, CreateNode(4));
  DisplayList(l);
  WriteLn(SumAllNodeValues(l));
  
  writeln;
  BigToFront(l, 2);
  DisplayList(l);
  
END.