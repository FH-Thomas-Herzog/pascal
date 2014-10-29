{
  This programs implements a hash algorithm which handles collisions with
  chained addressing.
  Here the nodes are added to the existing node as child elements.
}
Program HashFunctionChained;

{
  Type definition for hash table and óbject to be searched
}
Type
  NodePtr = ^NodeRecord;
  NodeRecord = record
    data: String;
    next: NodePtr;
  end;
  THashTableIndex = 1..10;
  THashTable = Array[THashTableIndex] of NodePtr;

{
  Computes the hash value for the given character sequence.
  The hash value will contain the ordinal value of the character.
  
  @param 
    the value to be hashed
  @return
    the computed hash value
}
Function ComputeHash(data: String): THashTableIndex;
Var
  hash: Longint;
  i: Byte;
Begin
  hash :=0;
  { 
    Bad but works. Is bad because the algorithm iterates over each character, 
    therefore no constant runtime behavior
  }
  for i := 1 to Length(data) do begin
    hash := (hash + ORD(data[i])) MOD (High(THashTableIndex) - Low(THashTableIndex) + 1);
  end;
  { Avoids zweo has index }
  ComputeHash := hash + Low(THashTableIndex);
End;

{
  Creates a nodes instance which cotnains the key for the hashing.
  
  @param
    the value for the created node
  @return 
    the created instance
}
Function CreateNode(value: String): NodePtr;
Var   
  node: NodePtr;
Begin
  node := New(NodePtr);
  node^.data := value;
  node^.next := nil;
  CreateNode := node;
End;

{
  Adds a node to the hash table.
  If the hash value has already a mapped node to the key,
  the actual node will prepeend the contained node.
  
  @param
    ht: the hash table
  @param
    node: the node to be added to the hash table 
}
Procedure AddNode(Var ht: THashTable; node: NodePtr);
Var
  hash: THashTableIndex;
Begin
  if node <> nil then begin
    hash := ComputeHash(node^.data);
    if ht[hash] = nil then begin
      ht[hash] := node;
    end
    else begin
      node^.next := ht[hash];
      ht[hash] := node;
    end;
  end;
End;

{
  Disposes all elements of the hash table and children of the node 
  if ppresent and set nil on each index.
  
  @param
    ht: tha hash table to be disposed
}
Procedure DisposeHashTable(VAR ht: THashTable);
Var
  i: THashTableIndex;
  node, next: NodePtr;
Begin
  for i := Low(THashTableIndex) to High(THashTableIndex) do begin
    if (ht[i] <> nil) then begin
      node := ht[i];
      next := nil;
      while (node <> nil) do begin
        next := node^.next;
        Dispose(node);
        node := next;
      end;
    end;
      ht[i] := nil;
  end;
End;

{
  Finds the node which data field is equal to given value.
  
  @param
    value: the value to be searched on the hash table 
  @param
    ht: the hash table to search on.
  @return 
    tru if the element could be found, false otherwise
}
Function FindValue(value: String; VAR ht: THashTable): Boolean;
Var 
  hash: THashTableIndex;
  node : NodePtr;
Begin
  hash := ComputeHash(value);
  node := ht[hash];
  while (node <> nil) and (node^.data <> value) do begin
    node := node^.next;
  end;
  FindValue := (node <> nil) and (node^.data = value);
End;

{
  Prints the contained hash table elements values to the console.
  
  @param
    ht: the has table to be print to the console
}
Procedure DisplayHashTable(VAR ht: THashTable);
Var
  i: THashTableIndex;
  node: NodePtr;
Begin
  writeln;
  writeln('Hash table content ');
  for i := low(THashTableIndex) to high(THashTableIndex) do begin
      node := ht[i];
      write(i, ':':3);
      while (node <> nil) do begin
        write(node^.data, ', ');
        node := node^.next;
      end;
      writeln;
  end;
End;

{
  Init the given hash table by setting nil values on each index.
  
  @param
    ht: the hash table to be initiialized
}
Procedure InitHashTable(Var ht: THashTable);
Var
  i: THashTableIndex;
Begin
  for i := low(THashTableIndex) to high(THashtableIndex) do begin
    ht[i] := nil;
  end;
End;

{
  variables for the tests of this program
}
Var
  node: NodePtr;
  ht: THashTable;
  data: String;
Begin

  { Init sht ehash table }
  InitHashTable(ht);
  
  { read value from console for adding }
  write('Add: ');
  readln(data);
  { read values as long no empty string is entered }
  while data <> '' do begin
    node := CreateNode(data);
    AddNode(ht, node);
    write('Add: ');
    readln(data);
  end;
  
  { read values from console for search }
  writeln;
  write('Search: ');
  readln(data);
  while data <> '' do begin
    writeln('Found: ', data, ' - ', FindValue(data, ht));
    write('Search: ');
    readln(data);
  end;
  
  { Displays the table }
  DisplayHashTable(ht);
  { Disposes the table }
  DisposeHashTable(ht);
End.