{
  Unit which provides utility methods for handling a Schierpinski triangle.
  It supports the calculation of the area left on the base triangle for a defined
  count of iterations.
  Also the calculation of the sum of dimension of all placed triangles in the base triangle 
  for the defined iteration count is provided.
}
UNIT SchierpinskiTriangleUnit;

INTERFACE

{
  Calculates the area of the Schierpinski triangle for the given iteration count
  via a recursive implementation
  
  @param
      i: the count of iterations
  @param
      dimension: the length of the triangle sides
  @return
      the area of the triangle after the iteration count, or the area of the triangle
      without iterations if i <= 0.
}
FUNCTION CalcAreaForItCount(i, dimension: INTEGER): REAL;

{
  Calculates the area of the Schierpinski triangle for the given iteration count 
  via a iterative implementation.
  
  @param
      i: the count of iterations
  @param
      dimension: the length of the triangle sides
  @return
      the area of the triangle after the iteration count, or the area of the triangle
      without iterations if i <= 0.
}
FUNCTION CalcAreaForItCountIt(i, dimension: INTEGER): REAL;

{
  Calculates the sum of the dimensions of all placed triangles in a Schierpinski triangle
  via a recursive implementation.
  
  @param
      i: the count of the iterations
  @param
      dimension: the dimension of the base triangle
  @return
      the sum of all dimensions of all placed triangles
}
FUNCTION CalcTriangleDimesnions(i, dimension: INTEGER): REAL;

{
  Calculates the sum of the dimensions of all placed triangles in a Schierpinski triangle
  via a iterative implementation.
  
  @param
      i: the count of the iterations
  @param
      dimension: the dimension of the base triangle
  @return
      the sum of all dimensions of all placed triangles
}
FUNCTION CalcTriangleDimesnionsIt(i, dimension: INTEGER): REAL;


IMPLEMENTATION
  
{ ######################## Private Function/Procedures ######################## }
{
  Calculates the area of a triangle for the given dimensions.
  The dimensions can be defined as decimal values.
  
  @param
      a: one side length of the triangle
  @param
      b: the second side of the triangle
  @return
      the calculated area represented by real or 0 if one/both of given dimensions 
      have negative values 
}
FUNCTION CalculateTriangleArea(a, b: REAL): REAL;
BEGIN
  CalculateTriangleArea := 0;
  
  IF ((a > 0) AND (b > 0)) THEN BEGIN
    CalculateTriangleArea := ((a * b) / 2); 
  END;
END;


{
  Calculates 'value powered by n'.
  
  @param value:
              the value to powered
  @param n:
          the count how often the given 'value' shall be powered
  @return the given 'value powered by n', where when 'n <= 0' then the neutral 
          element is returned, which is 1
}
FUNCTION Power(value, n: INTEGER): LONGINT;
VAR
  i: INTEGER;
  temp: LONGINT;
BEGIN

  temp := value;
  IF n > 0 THEN BEGIN
    FOR i := 1 TO n DO BEGIN
      temp := temp * value;
    END
  END;
  Power := temp DIV value;
END;

  
{ ######################## Public Function/Procedures ######################## }
{ Calculcate area for given iterations recursive }
FUNCTION CalcAreaForItCount(i, dimension: INTEGER): REAL;
  {
    Inner function which calculates the sum of the triangles which are placed 
    in the Shierpinski triangle at defined iterations.
    
    @param
        maxIt: the maximum iterations to handle
    @param
        it: the current iteration, used for the calculating the divisor for the length 
        of the new current placed triangles
    @param
        triangleCount: the count of the triangles to place on the current iteration
    @param
        dimension: the length of the original triangle
    @return
        the summary of the area of the placed triangles
  }
  FUNCTION SumPlacedTriangles(maxIt, it: INTEGER; triangleCount: LONGINT; dimension: REAL): REAL;
  VAR
    divisor, area: REAL;
  BEGIN   
  
    { Calculate the divisor for the dimension calculation }
    divisor := Power(2, it);
    { Calculate the area of the new placed triangles and multiply them with the new triangle count }
    area := CalculateTriangleArea((dimension / divisor), (dimension / divisor / 2)) * 2 * triangleCount;

    { Break after maximum iterations are reached }
    IF (it = maxIt) THEN BEGIN
      SumPlacedTriangles := area;
    END
    { Else calculate triangle are summary}
    ELSE BEGIN    
      SumPlacedTriangles := area + SumPlacedTriangles(maxIt, (it + 1), (triangleCount * 3), dimension);
    END;
  END;
  
BEGIN  
  { If iterations lower than one return area of basis triangle }
  IF (i < 1) THEN BEGIN
      CalcAreaForItCount := (CalculateTriangleArea(dimension, (dimension / 2)) * 2);
  END
  { If iteration greater than 0 then calculate the summary of the placed triangles and subtract from basis triangle }
  ELSE BEGIN
    CalcAreaForItCount := (CalculateTriangleArea(dimension, (dimension / 2)) * 2) - SumPlacedTriangles(i, 1, 1, dimension);
  END;
END;


{ Calculate area for given iterations iterative }
FUNCTION CalcAreaForItCountIt(i, dimension: INTEGER): REAL;
VAR
  baseArea, sum, divisor: REAL;  
  idx: INTEGER;
  triangleCount: LONGINT;
BEGIN
  baseArea := (CalculateTriangleArea(dimension, (dimension/2)) * 2);
  idx := 1;
  triangleCount := 1;
  sum := 0;
  divisor := 0;
  
  WHILE ((i > 0) AND (idx <= i)) DO BEGIN
    divisor := Power(2, idx);
    sum := sum + (CalculateTriangleArea((dimension / divisor), (dimension / divisor / 2)) * 2 * triangleCount);
    triangleCount := triangleCount * 3;
    Inc(idx);
  END;
  
  CalcAreaForItCountIt := baseArea - sum;
END;


{ Calculate the dimensions of the placed triangles for given iterations recursive }
FUNCTION CalcTriangleDimesnions(i, dimension: INTEGER): REAL;
  {
    Function which calculates the sum of the dimension of all placed triangles for the defined iterations.
    
    @param
        maxIt: the maximum iteration count
    @param
        it: the current iteration
    @param
        trianlgeCount: the count of the to place triangles
    @param  
        dimension: the length of the triangles
  }
  FUNCTION SumTriangleDimensions(maxIt, it: INTEGER; triangleCount: LONGINT; dimension: REAL): REAL;
  VAR
    dimensionSum, divisor: REAL;
  BEGIN
    divisor := Power(2, it);
    dimensionSum := ((dimension / divisor) * 3 * triangleCount);
    
    { If iterations lower than one return 0 length }
    IF (maxIt < 1) THEN BEGIN
        SumTriangleDimensions := 0;
    END
    { Break after maximum iterations are reached }
    ELSE IF (it = maxIt) THEN BEGIN
      SumTriangleDimensions := dimensionSum;
    END
    { Else calculate triangle are summary}
    ELSE BEGIN    
      SumTriangleDimensions := dimensionSum + SumTriangleDimensions(maxIt, (it + 1), (triangleCount * 3), dimension);
    END;
  END;
  
BEGIN
  CalcTriangleDimesnions := SumTriangleDimensions(i, 1, 1, dimension);
END;


{ Calculate the dimensions of the placed triangles for given iterations iterative }
FUNCTION CalcTriangleDimesnionsIt(i, dimension: INTEGER): REAL;
VAR
  sum, divisor: REAL;  
  idx: INTEGER;
  triangleCount: LONGINT;
BEGIN
  idx := 1;
  triangleCount := 1;
  sum := 0;
  divisor := 0;
  
  WHILE ((i > 0) AND (idx <= i)) DO BEGIN
    divisor := Power(2, idx);
    sum := sum + ((dimension / divisor) * 3 * triangleCount);
    triangleCount := triangleCount * 3;
    Inc(idx);
  END;
  
  CalcTriangleDimesnionsIt := sum;
END;

BEGIN
END.