PROGRAM MemeoryUnitTest;
{
  Uses this module, all defined interface functions and porcedures are visible
  from this point on.
}
USES MemoryUnit;

BEGIN 
  WriteLn(MemoryUnit.Mean(2));
  WriteLn(Mean(4));
  WriteLn(Mean(2));
  WriteLn(Mean(2));
END.