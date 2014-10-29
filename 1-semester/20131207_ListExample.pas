PROGRAM ListExample;

TYPE
  { Pointer to the list node }
  Node = ^NodeRecord;
  { The combound which is represnting the saved instanz in the list }
  NodeRecord = RECORD
    value: INTEGER;
    next: Node;
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
  n^.next :=  NIL;
  NewNode := n;
END; 

{ Add Node to the List at the beginning of the list }
PROCEDURE PrependNode(VAR l: List; value: INTEGER);
VAR
  n: Node;
BEGIN
  n := NewNode(value);
  IF l = NIL THEN
    l := n
  ELSE BEGIN
    n^.next := l;
    l := n;
  END;
END;

{ Add Node to the List at the end of the list }
PROCEDURE AppendNode(VAR l: List; value: INTEGER);
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
{ 
  Displays the value of all elements in the list. 
  Can use given l param because l is no VAR param,
  The pointer will be copied.
}
PROCEDURE DisplayList(l:List);
(* VAR
  n: Node; *)
BEGIN
  (* n := l; *)
  WHILE (l <> NIL) DO BEGIN
    Write(l^.value, ' ');
    l := l^.next;
  END;
  WriteLn;
END;

{ 
  Removes all elements of the list 
  CAn us l here no matter that it is a VAR param, because
  here the list is supposed to be deleted, so no matter if list
  head gets lost, because list shall be null after the algorithm
  has been finished.
}
PROCEDURE DisposeList(VAR l:List);
VAR
  next: Node;
BEGIN
  WHILE (l <> NIL) DO BEGIN
    next := l^.next;
    Dispose(l);
    l := next;
  END;
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

{ Searches for a value on the list nodes }
FUNCTION ContainsValue(l: List; value: INTEGER): BOOLEAN;
VAR
  n: NODE;
BEGIN
  ContainsValue := false;
  n := l;
  WHILE ((n <> NIL) AND (n^.value <> value)) DO BEGIN
    n := n^.next;
  END;
  ContainsValue := n <> NIL;
END;

{ Inverts the given list }
PROCEDURE InvertList(VAR l: List);
VAR
  prev:List;
  succ: Node;
BEGIN
  IF ((l <> NIL) AND (l^.next <> NIL)) THEN BEGIN
    prev := l;
    l := l^.next;
    prev^.next := NIL;
    WHILE (l <> NIL) DO BEGIN
      succ := l^.next;
      l^.next := prev;
      prev := l;      
      l := succ;
    END;
    l := prev;
  END;
END;

VAR
  l:List;
  i: INTEGER;
BEGIN
  InitList(l);
  FOR i := 1 TO 100 DO BEGIN
    (* AppendNode(l, i); *)
    PrependNode(l, i);
  END;
  writeln;
  DisplayList(l);
  InvertList(l);
  writeln;
  DisplayList(l);
  writeln;
  WriteLn(ContainsValue(l, 3));
  writeln;
  WriteLn(ContainsValue(l, 101));
  DisposeList(l);
END.