Unit HashUtils;
  
Interface

Uses
  IntegerUtils;

Type
  HashState = (NONE, OK, INVALID_RANGE, EMPTY_STRING);
  StringRange = 1..255;
{
  Computes a has value which is the key for the given string value.
  The hash key will be calculated via the ordinal value of the given string value.
  Be aware that this algorithm causes multiple hash values for different string values
  which is caused by the usage of the the ordinal value of the char without the index
  in the character sequence.
  
  In case of an error the returned hash will be an undefined index and is not supposed to be used.
  
  @param
    value: the string value to be hashed
  @param
    minIndex: the minimum index of the index range
  @param
    maxIndex: the maximum index of the index range
  @return
    the computed hash
    the current word state, 
    INVALID_RANGE if minIndex overflows maxIndex
    OK if hash could be computed without error  
}
Function ComputeHashOrdinalOnly(value: String; minIndex, maxIndex: LongInt; VAR state: HashState): Longint;

Implementation

Function ComputeHashOrdinalOnly(value: String; minIndex, maxIndex: LongInt; VAR state: HashState): Longint;
Var
  hash, range: LongInt;
  i: StringRange;
Begin
  state := HashState.OK;
  hash := minIndex - 1;
  // Invalid range of index
  if (not IntegerUtils.IsValidRange(minIndex, maxIndex, true)) then begin
    state := HashState.INVALID_RANGE;
    writeln('range error');
  end
  // EMpty String
  else if (Length(value) = 0) then begin
    state := HashState.EMPTY_STRING;
  end
  else begin
    hash := 0;
    range := maxIndex - minIndex + 1;
    for i := Low(StringRange) to Length(value) do begin
      hash := (hash + ORD(value[i])) MOD range;
    end;
    { Avoids zweo has index }
    ComputeHashOrdinalOnly := hash + minIndex;
  end;
End;

Begin
End.