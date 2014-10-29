PROGRAM BinomialCoefficent;
 
  (*
    PROCEDURE Implementation !!!!!
    
    {
      Procedure which calculates the factorial over n.
    }
    PROCEDURE Factorial(n: INTEGER; VAR fac: INTEGER); 
      VAR 
        i: INTEGER;
      BEGIN
        fac := 1;
        IF n > 0 THEN
          FOR i := 2 TO n DO BEGIN
            fac := fac * i;
          END
    END;
    }
    
    {
      Procedure which calculates the binomial coeffient.
    }
    PROCEDURE BinCoeff(n,k: INTEGER; VAR bc: INTEGER);
    VAR
      nFac, kFac, nkFac: INTEGER;
    BEGIN
      {
        Default is 0, result when all if conditions do not fit.
      }
      bc := 0;
      {
        When k = 0 then result can only be 1, if n > 0
      }
      IF k = 0 THEN
        bc := 1
      {
        If k <= n then faculty can be calculated 
      }
      ELSE IF k <= n THEN BEGIN
        nFac := Factorial(n);
        kFac := Factorial(k);
        nkFac := Factorial((n - k));
        bc := nFac DIV (kFac * nkFac)
      END
    END;
  
  {
    Main program
  }
  VAR 
    result: INTEGER;

  BEGIN
    BinCoeff(4, 2, result);
    WriteLn(result);
    BinCoeff(7, 7, result);
    WriteLn(result);
    BinCoeff(2, 0, result);
    WriteLn(result);
    BinCoeff(4, 5, result);
    WriteLn(result)
  END. 
  *)

  {
    Function which calculates the factorial over n   
    @param n 
              the count of numbers to calculate factorial
    @return 
            the factorial over n
  } 
  FUNCTION Factorial(n: INTEGER): INTEGER;
  VAR 
    i, fac: INTEGER;
  BEGIN
    fac := 1;
    IF n > 0 THEN
      FOR i := 2 TO n DO
        fac := fac * i;
    Factorial := fac;
  END;
 
  {
    Function which calculates the binomial coeffient for n and k.
    @param 
          n
    @param
          k
    @return 
          the calculated binomial coefficant 
    @see
        Function Factorial(n)
    @Problems
        Document possible problems
  }
  FUNCTION BinCoeff(n,k: INTEGER): INTEGER;
  VAR
    nFac, kFac, nkFac: INTEGER;
  BEGIN
    {
      When k = 0 then result can only be 1, if n > 0
    }
    IF k = 0 THEN
      BinCoeff := 1
    {
      If k <= n then faculty can be calculated 
    }
    ELSE IF k <= n THEN
      BinCoeff := Factorial(n) DIV (Factorial(k) * Factorial((n - k)))
    {
      If k > n then faculty can only be 0
    }
    ELSE
      BinCoeff := 0
  END;
  
  PROCEDURE test(a,b:INTEGER; s,c:STRING);
  BEGIN END;
{
  Main program
}
VAR 
  result: INTEGER;
    
BEGIN
  WriteLn(BinCoeff(4, 2));
  WriteLn(BinCoeff(7, 7));
  WriteLn(BinCoeff(9, 0));
  WriteLn(BinCoeff(4, 5))
END. 