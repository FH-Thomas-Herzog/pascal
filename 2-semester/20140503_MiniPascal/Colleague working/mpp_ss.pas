UNIT MPP_SS;

INTERFACE

VAR
	success: BOOLEAN;
	
PROCEDURE S; (* ="Parse", parses whole MiniPascal program *)

IMPLEMENTATION

USES MP_Lex, SymTab;

FUNCTION SyIsNot(expectedSymbol: Symbol): BOOLEAN;
BEGIN
	success := success AND (sy = expectedSymbol);
	SyIsNot := (NOT success);
END;

PROCEDURE SemErr(msg: STRING);
BEGIN
	WriteLn('*** SEMANTIC ERROR in line ', syLnr:0, ', column ', syCnr:0, ':');
	WriteLn('      ', msg);
END;

PROCEDURE MP; FORWARD;
PROCEDURE VarDecl; FORWARD;
PROCEDURE StatSeq; FORWARD;
PROCEDURE Stat; FORWARD;
PROCEDURE Expr(VAR e: INTEGER); FORWARD;
PROCEDURE Term(VAR t: INTEGER); FORWARD;
PROCEDURE Fact(VAR f: INTEGER); FORWARD;

PROCEDURE S;
BEGIN
	WriteLn('interpretation started ...');
	success := TRUE;
	MP;
	IF NOT success OR SyIsNot(eofSy) THEN
		WriteLn('*** ERROR in line ', syLnr: 0, ', column ', syCnr:0)
	ELSE
		WriteLn('... interpretation ended successfully.');
END;

PROCEDURE MP;
BEGIN
	(*SEM*) 
	InitSymbolTable; 
	(*ENDSEM*)
	IF SyIsNot(programSy) THEN EXIT;
	NewSy;
	IF SyIsNot(identSy) THEN EXIT;
	NewSy;
	IF SyIsNot(semicolonSy) THEN EXIT;
	NewSy;
	
	IF sy = varSy THEN BEGIN
		VarDecl;
		IF NOT success THEN EXIT;
	END;
	
	IF SyIsNot(beginSy) THEN EXIT;
	NewSy;
	StatSeq;
	IF NOT success THEN EXIT;
	IF SyIsNot(endSy) THEN EXIT;
	NewSy;
	IF SyIsNot(periodSy) THEN EXIT;
	NewSy;
END;

PROCEDURE VarDecl;
(*LOCAL*)
VAR
	ok: BOOLEAN;
(*ENDLOCAL*)
BEGIN
	IF SyIsNot(varSy) THEN EXIT;
	NewSy;
	IF SyIsNot(identSy) THEN EXIT;
	(*SEM*) 
	DeclVar(identStr, ok); 
	(*ENDSEM*)
	NewSy;
	WHILE sy = commaSy DO BEGIN
		NewSy;
		IF SyIsNot(identSy) THEN EXIT;
		(*SEM*) 
		DeclVar(identStr, ok); 
		IF NOT ok THEN
			SemErr('multiple declaration');
		(*ENDSEM*)
		NewSy;
	END;
	IF SyIsNot(colonSy) THEN EXIT;
	NewSy;
	IF SyIsNot(integerSy) THEN EXIT;
	NewSy;
	IF SyIsNot(semicolonSy) THEN EXIT;
	NewSy;
END;

PROCEDURE StatSeq;
BEGIN
	Stat;
	IF NOT success THEN EXIT;
	WHILE sy = semicolonSy DO BEGIN
		NewSy;
		Stat;
		IF NOT success THEN EXIT;
	END;
END;

PROCEDURE Stat;
(*LOCAL*)
VAR
	destId: STRING;
	e: INTEGER;
(*ENDLOCAL*)
BEGIN
	CASE sy OF
		identSy: BEGIN
			(*SEM*)
			destId := identStr;
			IF NOT IsDecl(destId) THEN
				SemErr('variable not declared!');
			(*ENDSEM*)
			NewSy;
			IF SyIsNot(assignSy) THEN EXIT;
			NewSy;
			Expr(e);
			(*SEM*)
			IF IsDecl(destId) THEN
				SetVal(destId, e);
			(*ENDSEM*)
			IF NOT success THEN EXIT;
		END;
		readSy: BEGIN
			NewSy;
			IF SyIsNot(leftParSy) THEN EXIT;
			NewSy;
			IF SyIsNot(identSy) THEN EXIT;
			(*SEM*)
			IF NOT IsDecl(identStr) THEN
				SemErr('variable not declared!')
			ELSE BEGIN
				Write(identStr, ' > ');
				ReadLn(e);
				SetVal(identStr, e);
			END;
			(*ENDSEM*)
			NewSy;
			IF SyIsNot(rightParSy) THEN EXIT;
			NewSy;
		END;
		writeSy: BEGIN
			NewSy;
			IF SyIsNot(leftParSy) THEN EXIT;
			NewSy;
			Expr(e);
			IF NOT success THEN EXIT;
			(*SEM*)
			WriteLn(e);
			(*ENDSEM*)
			IF SyIsNot(rightParSy) THEN EXIT;
			NewSy;
		END;
		ELSE
			;
	END;
END;

PROCEDURE Expr(VAR e: INTEGER);
VAR
	t: INTEGER;
BEGIN
	Term(e);
	IF NOT success THEN EXIT;
	WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
		CASE sy OF
			plusSy: BEGIN
				NewSy;
				Term(t);
				IF NOT success THEN EXIT;
				(*SEM*)
				e := e + t;
				(*ENDSEM*)
			END;
			minusSy: BEGIN
				NewSy;
				Term(t);
				IF NOT success THEN EXIT;
				(*SEM*)
				e := e - t;
				(*ENDSEM*)
			END;
		END;
	END;
END;

PROCEDURE Term(VAR t: INTEGER);
VAR
	f: INTEGER;
BEGIN
	Fact(t); 
	IF NOT success THEN EXIT;
	WHILE (sy = timesSy) OR (sy = divSy) DO BEGIN
		CASE sy OF
			timesSy: BEGIN
				NewSy;
				Fact(f);
				IF NOT success THEN EXIT;
				(*SEM*)
				t := t * f;
				(*ENDSEM*)
			END;
			divSy: BEGIN
				NewSy;
				Fact(f);
				IF NOT success THEN EXIT;
				(*SEM*)
				IF f = 0 THEN
					SemErr('zero division!')
				ELSE
					t := t DIV f;
				(*ENDSEM*)
			END;
		END;
	END;
END;

PROCEDURE Fact(VAR f: INTEGER);
BEGIN
	CASE sy OF
		identSy: BEGIN
			(*SEM*)
			IF NOT IsDecl(identStr) THEN
				SemErr('variable not declared!')
			ELSE
				GetVal(identStr, f);
			(*ENDSEM*)
			NewSy;
		END;
		numberSy: BEGIN 
			(*SEM*)
			f := numberVal;
			(*ENDSEM*)
			NewSy;
		END;
		leftParSy: BEGIN
			NewSy;
			Expr(f); 
			IF NOT success THEN EXIT;
			IF SyIsNot(rightParSy) THEN EXIT;
			NewSy;
		END;
		ELSE BEGIN
			success := FALSE;
			EXIT;
		END;
	END;
END;

BEGIN
	success := TRUE;
END.