{
  Unit for memeory based algorithm
}
UNIT MemoryUnit;

{
  ################################################################
  Interface part ot he unit.
  Procedures, Function or Type declaratrion, but no varaibles ever
  ################################################################
}
INTERFACE 

TYPE
  State = RECORD
    sum:REAL;
    count: INTEGER;
  END;
  
PROCEDURE Init;

FUNCTION Mean(next: REAL): REAL;

{
  ################################################################
  Implementation part of the unit.
  Her are varaibles allowed
  ################################################################
}
IMPLEMENTATION

{
  Could use another module.
  E.g.: USE AnoterhModule
}
 
VAR
  sum: REAL;
  count: INTEGER;
  
PROCEDURE Init;
BEGIN
  sum := 0;
  count :=0;
END;

FUNCTION Mean(next: REAL): REAL;
BEGIN
  sum := sum + next;
  Inc(count);
  Mean := sum / count;
END;

{
  Inilizes this Unit.
  Is called only once !!!
}
BEGIN
  Init;
END.