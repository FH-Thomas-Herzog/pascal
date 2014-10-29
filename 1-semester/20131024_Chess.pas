Program Chess;

Type
  ChessFigureShape = (None, Pawn, Bishop, Knight, Rook, Queen, King);
  ChessFigureColor = (Black, White);
  ChessFigure = Record
    shape: ChessFigureShape;
    color: ChessFigureColor;
  End;
  (* ChessBoard = Array['A'..'H'] of Array[1..8] of ChessFigure; *)
  ChessBoard = Array['A'..'H', 1..8] of ChessFigure;
  
Procedure createEmptyChessBoard(arr: ChessBoard);
Var
  i: Char;
  j: Integer;
Begin
  For i := Low(arr) To High(arr) Do
    For j := Low(arr[i]) To High(arr[i]) Do Begin
      arr[i, j].shape := None;
      arr[i, j].color := Black;
    End
End;

Var 
  board: ChessBoard;
Begin
  createEmptyChessBoard(board);
  board['D', 7].shape := Queen;
  board['D', 7].color := White;
  board['B', 4].shape := Pawn;
  board['B', 4].color := White;
End.