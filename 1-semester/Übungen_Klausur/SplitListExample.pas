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
{
  Checks if value is a even one.
}
FUNCTION IsEven(val: INTEGER): BOOLEAN;
BEGIN
  IsEven := (val MOD 2) = 0;
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

VAR
  i: INTEGER;
  l, even, odd: List;
BEGIN
  // Init lists
  l := NIL;
  even := NIL;
  odd := NIL;
  
  // Create random nodes 
  FOR i := 1 TO 20 DO BEGIN
    AppendToList(l, CreateNode(Random(100) + 1));
  END;
  
  // Print original list before modification
  writeln;
  writeln('original list before ');
  DisplayList(l);
  Split(l, even, odd);
  
  // Print even list
  writeln;
  writeln('Even list');
  DisplayList(even);
  
  // Print odd list
  writeln;
  writeln('odd list');
  DisplayList(odd);
    
  // Print original list after modification
  writeln;
  writeln('original list');
  DisplayList(l);
END.