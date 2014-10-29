Program CaesarUnitTest;

Uses
  CaesarUnit;
  
Procedure TestEncryptText;
Var
  t: String;
Begin
  t := 'Ich bin ein Text zum Verschluesseln';
  writeln('original:  ', t);
  t := CaesarUnit.encryptText(t, 10);
  writeln('encrypted: ', t);
  t := CaesarUnit.decryptText(t, 10);
  writeln('decrypted: ', t);
End;

Procedure TestEncrypt;
Var
  inFile, outFile: Text;
Begin
  Assign(inFile, 'C:\Users\cchet\Documents\Google Drive\GitHub\uas-upper-austria-pascal\2-semester\20140405_Übung_3\testdata.txt');
  Assign(outFile, 'C:\Users\cchet\Documents\Google Drive\GitHub\uas-upper-austria-pascal\2-semester\20140405_Übung_3\encrypteddata.txt');
  CaesarUnit.Encrypt(inFile, outFile, 10);
End;

Procedure TestDecrypt;
Var
  inFile, outFile: Text;
Begin
  Assign(inFile, 'C:\Users\cchet\Documents\Google Drive\GitHub\uas-upper-austria-pascal\2-semester\20140405_Übung_3\encrypteddata.txt');
  Assign(outFile, 'C:\Users\cchet\Documents\Google Drive\GitHub\uas-upper-austria-pascal\2-semester\20140405_Übung_3\decrypteddata.txt');
  CaesarUnit.Decrypt(inFile, outFile, 10);
End;

Begin
  TestEncryptText;
  TestEncrypt;
  TestDecrypt;
End.