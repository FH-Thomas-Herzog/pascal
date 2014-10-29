Program UntypedFileTest;
Const max = 10;
VAR
  myFile : File;
  data : Array[1..max] of Byte; 
  i: Integer;
Begin
  Assign(myFile, 'C:\Users\cchet\Documents\Google Drive\GitHub\uas-upper-austria-pascal\2-semester\20140405_File_Handling\untypedFile.txt');
  Reset(myFile, 1);
  writeln('Read in data');
  while (not eof(myFile)) do begin
    Blockread(myFile, data, SizeOf(Data));
  end;
  writeLn('Read data:');
  for i := 1 to max do begin
    writeln('Data on pos #', i, ': ', Chr(data[i]));
  end;
End.