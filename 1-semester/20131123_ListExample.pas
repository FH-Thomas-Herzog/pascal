PROGRAM ListExample;

TYPE
  Node = ^NodeRecord;
  NodeRecord = RECORD
    value: INTEGER;
    next: Node;
  END;
  List = Node;


{ Creates a new Node with the New() operator }
FUNCTION NewNode(value:INTEGER): Node;
VAR
  n: Node;
BEGIN
  New(n);
  n^.value := value;
  n^.next :=  NIL;
  NewNode := n;
END; 

{ Add Node to the List }
PROCEDURE AddNode(VAR l: List; value: INTEGER);
VAR
  el, n: Node;
BEGIN
  n := NewNode(value);
  IF l = NIL THEN
    l := n
  ELSE BEGIN
    el := l;
    { !!! Listenüberlauf pattern !!! }
    WHILE (el^.next <> NIL) DO BEGIN
      el := el^.next;
    END;
    el^.next := n;
  END;
END;

{ Displays the value of all elements in the list }
PROCEDURE DisplayList(l:List);
VAR
  n: Node;
BEGIN
  n := l;
  WHILE (n <> NIL) DO BEGIN
    Write(n^.value, ' ');
    n := n^.next;
  END;
END;

{ Remoes all elements of the list }
PROCEDURE DisposeList(VAR l:List);
VAR
  pred, succ: Node;
BEGIN
  pred := l;
  WHILE (pred <> NIL) DO BEGIN
    succ := pred^.next;
    Dispose(pred);
    pred := succ;
  END;
  l := NIL;
END;

{ 
  Initializes the list and disposes all elements before initializing,
  because it could be already contain element.  
}
PROCEDURE InitList(VAR l: List);
BEGIN
  DisposeList(l);
  l := NIL;
END;

VAR
  l:List;
BEGIN
  InitList(l);
  AddNode(l, 5);
  AddNode(l, 3);
  AddNode(l, 4);
  DisplayList(l);
  DisposeList(l);
END.