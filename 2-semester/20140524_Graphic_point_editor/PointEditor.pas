Program PointEditor;

Uses
  Windows, WinGraph;
  
Var
  xCoord, yCoord: Integer;
  
Procedure DrawPoint(dc: HDC; wnd: HWnd; x,y: Integer);
Begin
	Ellipse(dc, xCoord-10, yCoord-10, xCoord+10, yCoord+10);
End;

Procedure Redraw(dc: HDC; wnd: HWnd; r: TRect);
Begin
	Writeln('Redraw called: x: ', xCoord, ' | y: ', yCoord);
	DrawPoint(dc, wnd, xCoord, yCoord);
End;

Procedure MousePressend(dc: HDC; wnd: HWnd; x,y: Integer);
Begin
	InvalidateREct(wnd, Nil, true);
	xCoord := x;
	yCoord := y;
	DrawPoint(dc, wnd, xCoord, yCoord);
End;

Begin
	redrawProc := Redraw;
	mousePressedProc := MousePressend;
	WGMain;
End.