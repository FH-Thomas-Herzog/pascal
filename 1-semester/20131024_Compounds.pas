PROGRAM Compounds;

{
  Kein Speicher wird verbraucht, da keine Variablen 
  definiert wurde. 
  Hier wir lediglich eine Typdefinition vorgenommen.
}
TYPE
  MyArray = array[1..3] of string;
  MyArray2 = array[char] of string;
  MyArray3 = array [1..7] of string;
  MyArray4 = array [char] of integer;
  
PROCEDURE resetArray(VAR arr: array of string);
{
  Funktioniert, egal welcher index typ verwendet wird, da 
  Pascal hier vom ersten Element zum letzten geht und das mit Hilfe einer Integer.
  Der index muss ja ein ordinöer Datentyp sein.
  
  Open array: Ist ein array mit einem varibalen index.
}
VAR
  i: integer;
BEGIN
  for i := Low(arr) to High(arr) do
    arr[i] := '';
END;

VAR
  arr: MyArray;
  arr2: MyArray2;
  arr3: MyArray3;
BEGIN
  resetArray(arr);
  resetArray(arr2);
  resetArray(arr3);
END.

(*
{
  Nach möglichkeit sollte der Datantyp am Begin des Progamms sein.
  Hiermit vermeidet man Code Verdoppelung.
}
TYPE
  MyArray = array[1..7] of string;
  {
    Technisch denkbar, baer existierende Datentypen sollten
    nicht überschrieben werden.
  }
  SmallNumber = smallint;

PROCEDURE displayAllElements(arr: MyArray);
VAR
  i: integer;
BEGIN
  for i := Low(arr) to  high(arr) do
    WriteLn(arr[i])
END;

VAR
  a: MyArray;
  y: MyArray;
    z: SmallNumber;
    a: array[integer] of SmallNumber; 
BEGIN
  a[1] := 'a';
  a[2] := 'b';
  a[3] := 'c';
  a[4] := 'd';
  a[5] := 'e';
  a[6] := 'f';
  a[7] := 'g';
  displayAllElements(a)
END.
*)