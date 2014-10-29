{
  Examle for double linked linear list
}
PROGRAM DoubleLinkedListCyclicWithAnchor;

TYPE
  { Pointer to the list node }
  Node = ^NodeRecord;
  { The combound which is represnting the saved instanz in the list }
  NodeRecord = RECORD
    value: INTEGER;
    prev, next: Node;
  END;
  { Pointer to the list (to differentiate between node and list )}
  List = Node;


{ Creates a new Node with the New() operator }
FUNCTION NewNode(value:INTEGER): Node;
VAR
  n: Node;
BEGIN
  New(n);
  n^.value := value;
  n^.next :=  n;
  n^.prev := n;
  NewNode := n;
END; 

{ 
  Initializes the list and disposes all elements before initializing,
  because it could be already contain element.  
}
PROCEDURE InitList(VAR l: List);
BEGIN
  l := NewNode(0);
END;

{ Displays the value of all elements in the list }
PROCEDURE DisplayList(l:List);
VAR
  n: Node;
BEGIN
  n := l^.next;
  WHILE (n <> l) DO BEGIN
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
  n := l^.prev;
  WHILE (n <> l) DO BEGIN
    Write(n^.value, ' ');
    n := n^.prev;
  END;
  WriteLn;
END;

{ Removes all elements of the list }
PROCEDURE DisposeList(l:List);
VAR
  n, next: Node;
BEGIN
  n := l^.next;
  WHILE (n <> l) DO BEGIN
    next := n^.next;
    Dispose(n);
    n := next;
  END;
  l^.prev := l;
  l^.next := l;
END;

{ Add Node to the List at the end of the list }
PROCEDURE AppendNode(l: List; value: INTEGER);
VAR
  n: Node;
BEGIN
  n := NewNode(value);
  n^.next := l;
  n^.prev := l^.prev;
  l^.prev^.next := n;
  l^.prev := n;
END;

{ Add Node to the List at the beginning of the list }
PROCEDURE PrependNode(l: List; value: INTEGER);
VAR
  n: Node;
BEGIN
  n := NewNode(value);
  n^.prev := l;
  n^.next := l^.next;
  l^.next^.prev := n;
  l^.next := n;
END;

{ Searches for a value on the list nodes }
FUNCTION ContainsValue(l: List; value: INTEGER): BOOLEAN;
VAR
  n: NODE;
BEGIN
  n := l^.next;
  WHILE ((n <> l) AND (n^.value <> value)) DO BEGIN
    n := n^.next;
  END;
  ContainsValue := n <> l;
END;

VAR
  l:List;
  i: INTEGER;
BEGIN
  InitList(l);
  FOR i := 1 TO 100 DO BEGIN
    AppendNode(l, i);
    (*PrependNode(l, i);*)
  END;
  DisplayList(l);
  WriteLn;
  DisplayInvertedList(l);
  WriteLn;
  WriteLn(ContainsValue(l, 3));
  WriteLn(ContainsValue(l, 101));
  DisposeList(l);
END.