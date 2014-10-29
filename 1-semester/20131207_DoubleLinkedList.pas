{
  Examle for double linked linear list
}
PROGRAM DoubleLinkedList;

TYPE
  { Pointer to the list node }
  Node = ^NodeRecord;
  { The combound which is represnting the saved instanz in the list }
  NodeRecord = RECORD
    value: INTEGER;
    prev, next: Node;
  END;
  { Pointer to the list (to differentiate between node and list )}
  List = RECORD
    first, last: NODE;
  END;


{ Creates a new Node with the New() operator }
FUNCTION NewNode(value:INTEGER): Node;
VAR
  n: Node;
BEGIN
  New(n);
  n^.value := value;
  n^.next :=  NIL;
  n^.prev := NIL;
  NewNode := n;
END; 

{ 
  Initializes the list and disposes all elements before initializing,
  because it could be already contain element.  
}
PROCEDURE InitList(VAR l: List);
BEGIN
  l.first := NIL;
  l.last:= NIL;
END;

{ Displays the value of all elements in the list }
PROCEDURE DisplayList(l:List);
VAR
  n: Node;
BEGIN
  n := l.first;
  WHILE (n <> NIL) DO BEGIN
    Write(n^.value, ' ');
    n := n^.next;
  END;
  WriteLn;
END;

{ Displays the value of all elements in the list }
PROCEDURE DisplayInvertedList(l:List);
VAR
  n: Node;
BEGIN
  n := l.last;
  WHILE (n <> NIL) DO BEGIN
    Write(n^.value, ' ');
    n := n^.prev;
  END;
  WriteLn;
END;

{ Removes all elements of the list }
PROCEDURE DisposeList(VAR l:List);
VAR
  n, next: Node;
BEGIN
  n := l.first;
  WHILE (n <> NIL) DO BEGIN
    next := n^.next;
    Dispose(n);
    n := next;
  END;
  InitList(l);
END;

{ Add Node to the List at the end of the list }
PROCEDURE AppendNode(VAR l: List; value: INTEGER);
VAR
  n: Node;
BEGIN
  n := NewNode(value);
  IF (l.first = NIL) THEN BEGIN
    l.first := n;
    l.last := n;
  END 
  ELSE BEGIN
    l.last^.next := n;
    n^.prev := l.last;
    l.last := n;
  END;
END;

{ Add Node to the List at the beginning of the list }
PROCEDURE PrependNode(VAR l: List; value: INTEGER);
VAR
  n: Node;
BEGIN
  n := NewNode(value);
  IF (l.first = NIL) THEN BEGIN
    l.first := n;
    l.last := n;
  END
  ELSE BEGIN
    l.first^.prev := n;
    n^.next := l.first;
    l.first := n;
  END;
END;

{ Searches for a value on the list nodes }
FUNCTION ContainsValue(l: List; value: INTEGER): BOOLEAN;
VAR
  n: NODE;
BEGIN
  ContainsValue := false;
  n := l.first;
  WHILE ((n <> NIL) AND (n^.value <> value)) DO BEGIN
    n := n^.next;
  END;
  ContainsValue := n <> NIL;
END;

VAR
  l:List;
  i: INTEGER;
BEGIN
  InitList(l);
  FOR i := 1 TO 100 DO BEGIN
    (*AppendNode(l, i);*)
    PrependNode(l, i);
  END;
  DisplayList(l);
  WriteLn;
  DisplayInvertedList(l);
  WriteLn;
  WriteLn(ContainsValue(l, 3));
  WriteLn(ContainsValue(l, 101));
  DisposeList(l);
END.