{
  Progam which display the functionality of a memory based algortihm.
  
  1. Global varaibles are visible over whole program 
  2. Global variables are only visible in main program
  3. Global variables bound in a compound and visible in main program
}
PROGRAM Memory;

(* { ## Global variables are visible to whole program ## }
{ Keeps the state means is the memory }
VAR
  sum: REAL;
  count: INTEGER;

PROCEDURE Init;
BEGIN
  sum := 0;
  count := 0;
END;

{
  Calculates the mean with global variables.
}
FUNCTION Mean(next:REAL):REAL;

BEGIN
  sum := sum+next;
  Inc(count);
  Mean := sum / count;
END;

BEGIN
  { init global var is main programm }
  Init;
  
  WriteLn(Mean(2):4:2);
  WriteLn(Mean(4):4:2);
  WriteLn(Mean(2):4:2);
  WriteLn(Mean(2):4:2); 
  
  { New calculation with reseted memory }
  WriteLn('');
  Init;
    
  WriteLn(Mean(2):4:2);
  WriteLn(Mean(4):4:2);
  WriteLn(Mean(2):4:2);
  WriteLn(Mean(2):4:2);
END. *)

(* { ## Global variables are only visible to main program ## }
{
  Calculates the mean with actual parameters which are presenting the memeory of this algorithm.
}
FUNCTION Mean(VAR sum: REAL; VAR count: INTEGER; next:REAL):REAL;

BEGIN
  sum := sum+next;
  Inc(count);
  Mean := sum / count;
END; 

PROCEDURE Init(VAR sum: REAL; VAR count: INTEGER);
BEGIN
  sum := 0;
  count := 0;
END; 

VAR
  sum: REAL;
  count: INTEGER; 
BEGIN  
  {New calculation with actual parameters not working iwth global0
  WriteLn('');
  Init(sum, count);
    
  WriteLn(Mean(sum, count, 2):4:2);
  WriteLn(Mean(sum, count, 4):4:2);
  WriteLn(Mean(sum, count, 2):4:2);
  WriteLn(Mean(sum, count, 2):4:2);
END. 
*)

 { ## Memory represented by a compound ## }
TYPE
  State = RECORD
    sum: REAL;
    count: INTEGER
  END;
 
PROCEDURE Init(st: State);
BEGIN
  st.sum := 0;
  st.count := 0;
END;

{
  Calculates the mean with global variables.
}
FUNCTION Mean(VAR st:State; next:REAL):REAL;

BEGIN
  st.sum := st.sum+next;
  Inc(st.count);
  Mean := st.sum / st.count;
END;

VAR 
  st: STATE;
BEGIN
  Init(st);
    
  WriteLn(Mean(st, 2):4:2);
  WriteLn(Mean(st, 4):4:2);
  WriteLn(Mean(st, 2):4:2);
  WriteLn(Mean(st, 2):4:2);
END.