{
  This unit provides utility functions and procedure which allows
  printing formatted text to the console.
}
Unit PrintUtils;

interface 

Uses Crt, sysutils;

{
	Prints a string as a header with default background and text colour set.
	The header length is equal to the given string length
  
	@see
	rintHeader(message: String; backgroundColor, testColor: Byte)
	@see
	Const section for default colour
}
Procedure PrintHeader(message: String); overload;

{
	Prints a string as a header with default background and text colour set.

	@param
		message: the message to be printing
	@param
		length: the length of the header
	@see
		rintHeader(message: String; backgroundColor, testColor: Byte)
	@see
		Const section for default colour
}
Procedure PrintHeader(message: String; length: Integer); overload;

{
	Prints a string as a error with default background and text colour set.

	@see
		rintHeader(message: String; backgroundColor, testColor: Byte)
	@see
		Const section for default colour
}
Procedure PrintError(message: String); overload;

{
	Prints a string with the defined formatting settings.
	The length of the print text is qual to the message length

	@param
		background: the background colour
	@param
		text: the text colour to be set
}
Procedure Print(message: String; background, text: Byte); overload;

{
	Prints a string with the defined formatting settings.

	@param
		background: the background colour
	@param
		text: the text colour to be set
}
Procedure Print(message: String; background, text: Byte; length: Integer); overload;

implementation

Const
  DEFAULT_HEADER_BACKGROUN_COLOR: Byte = Blue;
  DEFAULT_HEADER_TEXT_COLOR: Byte = White;
  DEFAULT_ERROR_BACKGROUN_COLOR: Byte = Red;
  DEFAULT_ERROR_TEXT_COLOR: Byte = White;
  
Procedure PrintHeader(message: String);
Begin
  Print(message, DEFAULT_HEADER_BACKGROUN_COLOR, DEFAULT_HEADER_TEXT_COLOR);
End;
  
Procedure PrintHeader(message: String; length: Integer);
Begin
  Print(message, DEFAULT_HEADER_BACKGROUN_COLOR, DEFAULT_HEADER_TEXT_COLOR, length);
End;

Procedure PrintError(message: String);
Begin
  Print(message, DEFAULT_ERROR_BACKGROUN_COLOR, DEFAULT_ERROR_TEXT_COLOR);
End;

Procedure Print(message: String; background, text: Byte);
Begin
  TextColor(text);
  TextBackground(background);
  write(message);
  NormVideo();
  writeln;
End;

Procedure Print(message: String; background, text: Byte; length: Integer);
Begin
  TextColor(text);
  TextBackground(background);
  write(Format(('%-' + IntToStr(length) + 's'), [message]));
  NormVideo();
  writeln;
End;

Begin
End.