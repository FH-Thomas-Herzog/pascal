PROGRAM SortAlgorithms;

VAR
  countSwap, countCompare: LONGINT;

{
  Resets the counters which are used to count the swaps, and compare operations.
} 
PROCEDURE ResetCounters;
BEGIN
  countSwap := 0;
  countCompare := 0;
END;

{
  Prints the set counters.
}
PROCEDURE PrintCounters;
BEGIN
  WriteLn(countCompare, ' + ', countSwap, ' = ', countSwap + countCompare);
END;

{
  Swaps to integers.
}
PROCEDURE Swap(VAR a, b: INTEGER);
VAR
  temp: INTEGER;
BEGIN
  temp := a;
  a := b;
  b := temp;
  Inc(countSwap);
END;

{
  Checks if one value is lowert than the other
}
FUNCTION LowerThan(a, b: INTEGER): BOOLEAN;
BEGIN
  LowerThan := a < b;
  Inc(countCompare);
END;
PROCEDURE InitArray(VAR arr: ARRAY OF INTEGER);
VAR
  i: LONGINT;
BEGIN
  RandSeed := 1234;
  FOR i := Low(arr) TO High(arr) DO
    arr[i] := Random(10) + 1;
END;

{
  Displays the array via the console.
}
PROCEDURE DisplayArray(VAR arr: ARRAY OF INTEGER);
VAR
  i: LONGINT;
BEGIN
  FOR i := Low(arr) TO High(arr) DO
    Write(arr[i], ' ');
  WriteLn;
END;

(* ###################### SortAlgorithms ###################### *)
{
  Sorts an array via the selection sort algorithm.
}
PROCEDURE SelectionSort(VAR arr: ARRAY OF INTEGER);
VAR
  i, j, minPos, minVal: LONGINT;
BEGIN
  FOR i := Low(arr) TO High(Arr) - 1 DO BEGIN
    minPos := i;
    FOR j := i + 1 To High(arr) DO BEGIN
      // Check for element idx=j to swapped minPos
      IF LowerThan(arr[j], arr[minPos]) THEN BEGIN
       minPos := j;
      END;
      Swap(arr[i], arr[minPos]);
    END
  END;
END;

PROCEDURE InsertSort(VAR arr: ARRAY OF INTEGER);
VAR
  i, j: LONGINT;
  h: INTEGER;
BEGIN
  FOR i := Low(arr) TO High(Arr) - 1 DO BEGIN
   h := arr[i + 1];
   j := i;
   WHILE (j >= Low(Arr)) AND LowerThan(h, arr[j]) DO BEGIN
    Swap(Arr[j + 1],  arr[j]);
    Dec(j);
   END;
   Swap(Arr[j + 1],  h);
  END;
END;

{ Does not work !!!!!!! }
PROCEDURE BubbleSort(VAR a: ARRAY OF INTEGER);
VAR
  i: INTEGER;
  noSwaps: BOOLEAN;
BEGIN
  REPEAT
    noSwaps := TRUE;
    FOR i := Low(a) to High(a) - 1 DO BEGIN
      IF (LowerThan(a[i+1], a[i])) THEN BEGIN
        noSwaps := FALSE;
        Swap(a[i], a[i+1]);
      END;
    END;
  UNTIL (noSwaps);
END;

PROCEDURE QuickSort(VAR arr: ARRAY OF INTEGER);

  PROCEDURE SortPart(l, r: INTEGER);
  VAR
    i,j, m: LONGINT;
  BEGIN
    (* find split point *)
    i := l;
    j := r;
    m := arr[(l + r) DIV 2];
    REPEAT
      WHILE (LowerThan(arr[i], m)) DO 
        Inc(i);
      WHILE (LowerThan(m, arr[j])) DO BEGIN
        Dec(j);
      END;
      IF (i <= j) THEN BEGIN
        Swap(arr[i], arr[j]);
        Inc(i);
        Dec(j);
      END;
    UNTIL i > j;
    
    (* sort left and right part *)
    IF (l < j) THEN 
      SortPart(l, j);
    IF (i < r) THEN
      SortPart(i, r);
  END;
  
BEGIN
  SortPart(Low(arr), High(arr));
END; 

VAR
  intArray: ARRAY[1..100] OF INTEGER;

BEGIN  
  WriteLn('SelectionSort');
  ResetCounters;
  InitArray(intArray);
  WriteLn('Unsorted');
  DisplayArray(intArray);
  SelectionSort(intArray);
  WriteLn('Sorted');
  DisplayArray(intArray);
  PrintCounters;
  
  WriteLn;
  WriteLn('InsertSort');
  ResetCounters;
  InitArray(intArray);
  WriteLn('Unsorted');
  DisplayArray(intArray);
  InsertSort(intArray);
  WriteLn('Sorted');
  DisplayArray(intArray);
  PrintCounters;
  
  WriteLn;
  WriteLn('Quick');
  ResetCounters;
  InitArray(intArray);
  WriteLn('Unsorted');
  DisplayArray(intArray);
  QuickSort(intArray);
  WriteLn('Sorted');
  DisplayArray(intArray);
  PrintCounters;
  
  WriteLn;
  WriteLn('Bubble');
  ResetCounters;
  InitArray(intArray);
  WriteLn('Unsorted');
  DisplayArray(intArray);
  BubbleSort(intArray);
  WriteLn('Sorted');
  DisplayArray(intArray);
  PrintCounters;
END.