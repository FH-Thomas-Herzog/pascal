PROGRAM Koch;

USES
	Windows, Strings, WinGraph;
	
VAR
	n: INTEGER;
	
PROCEDURE ReDraw(dc: HDC; wnd: HWnd; r: TRect);
VAR
	x, y: REAL;
	
	FUNCTION Rad(degrees: REAL): REAL;
	BEGIN
		Rad := degrees * (180 / PI);
	END;
	
	PROCEDURE Koch(n: INTEGER; len: REAL; alpha: INTEGER);
	BEGIN
		IF n = 1 THEN BEGIN
			x := x + len * Cos(Rad(alpha));
			y := y - len * Sin(Rad(alpha));
			LineTo(dc, Round(x), Round(y));
		END ELSE BEGIN
			Koch(n-1, len / 3, alpha);
			Koch(n-1, len / 3, alpha + 60);
			Koch(n-1, len / 3, alpha - 60);
			Koch(n-1, len / 3, alpha);
		END;
	END;
BEGIN
		x := 20.0;
		y := 440.0;
		MoveTo(dc, Round(x), Round(y));
		Koch(n, 750, 0);
END;

BEGIN
	Write('n: ');
	ReadLn(n);
	redrawProc := ReDraw;
	WGMain;
END.