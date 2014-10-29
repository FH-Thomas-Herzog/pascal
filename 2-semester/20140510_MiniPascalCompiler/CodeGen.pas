(* CodeGen:                                         HDO, 2004-02-06
   -------
   Byte code generator for the MiniPascal compiler.
===================================================================*)
UNIT CodeGen;

INTERFACE

  USES
    CodeDef;

  PROCEDURE InitCodeGenerator;

  PROCEDURE Emit1(opc: OpCode);
  PROCEDURE Emit2(opc: OpCode; opd: INTEGER);

  PROCEDURE GetCode(VAR ca: CodeArray);


IMPLEMENTATION

  VAR
    ca: CodeArray; (*array of opCodes and opderands*)
    n: INTEGER;    (*index of next free byte in c*)


  PROCEDURE InitCodeGenerator;
(*-----------------------------------------------------------------*)
    VAR
      i: INTEGER;
  BEGIN
    n := 1;
    FOR i := 1 TO maxCodeLen DO BEGIN
      ca[i] := 0;
    END; (*FOR*)
  END; (*InitCodeGenerator*)


  PROCEDURE EmitByte(b: BYTE);
  BEGIN
    IF n = maxCodeLen THEN BEGIN
      WriteLn('*** Error: overflow in code array');
      HALT;
    END; (*IF*)
    ca[n] := b;
    n := n + 1;
  END; (*EmitByte*)

  PROCEDURE EmitInt(w: INTEGER);
    VAR
      conv: RECORD  (*for conversion of an integer to two bytes*)
        CASE BOOLEAN OF
            FALSE: (i:  INTEGER);
            TRUE:  (ba: PACKED ARRAY [1..2] OF BYTE);
      END; (*RECORD*)
  BEGIN
    conv.i := w;
    EmitByte(conv.ba[1]);
    EmitByte(conv.ba[2]);
  END; (*EmitInt*)


  PROCEDURE Emit1(opc: OpCode);
(*-----------------------------------------------------------------*)
  BEGIN
    EmitByte(Ord(opc));
  END; (*Emit1*)

  PROCEDURE Emit2(opc: OpCode; opd: INTEGER);
(*-----------------------------------------------------------------*)
  BEGIN
    EmitByte(Ord(opc));
    EmitInt(opd);
  END; (*Emit1*)


  PROCEDURE GetCode(VAR ca: CodeArray);
(*-----------------------------------------------------------------*)
  BEGIN
    ca := CodeGen.ca;
  END; (*GetCode*)


END. (*CodeGen*)