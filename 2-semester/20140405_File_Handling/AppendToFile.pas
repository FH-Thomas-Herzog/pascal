Program AppendToFile;

Var
  f: Text;
Begin
  Assign(f, 'C:\Users\cchet\Documents\Google Drive\GitHub\uas-upper-austria-pascal\2-semester\20140405_File_Handling\appendToFile.txt');
  ReWrite(f);
  Writeln(f, 'I am added to newly created file');
  Close(f);
  Append(f);
  Writeln(f, 'Appended to the file after file was closed');
  Close(f);
End.