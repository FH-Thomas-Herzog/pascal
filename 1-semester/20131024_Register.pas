PROGRAM Register;

TYPE
  Person = RECORD
    firstName, lastName, street: STRING;
    age, zip: INTEGER;
  End;
  PersonArray = ARRAY[1..1000] OF Person;

PROCEDURE initPersonArray(arr: Array of Person);
VAR
  i: LONGINT;
BEGIN
  FOR i := Low(arr) TO High(arr) DO BEGIN
    arr[i].firstName := '';
    arr[i].lastName := '';
    arr[i].street := '';
    arr[i].age := 0;
    arr[i].zip := 0;
  END;
END;

VAR
  persons: PersonArray;
BEGIN
  initPersonArray(persons);
  persons[1].firstName := 'Thomas';
END.
