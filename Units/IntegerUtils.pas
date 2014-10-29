{
   This unit provides utility function and procedures for handling integer type.
}
Unit IntegerUtils;

Interface
  
{
   Validate the two given values if the represent a valid range.
   
   @param
      min: the minimum value of the range
   @param
	  max: the maximum value of the range
   @return
	  true if the two values represent a valid range or if they are equal,
	  false otherwise
   @see
	  IsValidRange(min, max: Integer; strict: Boolean): Boolean; overload;
}
Function IsValidRange(min, max: Integer): Boolean; overload;

{
   Validate the two given values if the represent a valid range.
   
   @param
      min: the minimum value of the range
   @param
	  max: the maximum value of the range
   @param
	  strict: true if the minimum must be smaller than the maximum
   @return
	  true if the two values represent a valid range,
	  false otherwise
}
Function IsValidRange(min, max: Integer; strict: Boolean): Boolean; overload;

Implementation

Function IsValidRange(min, max: Integer): Boolean;
Begin
  IsValidRange := IsValidRange(min, max, false);
End;

Function IsValidRange(min, max: Integer; strict: Boolean): Boolean;
Begin
  if (strict) then begin
    IsValidRange := min < max;
  end
  else begin
    IsValidRange := min <= max;
  end;
End;

Begin
End.