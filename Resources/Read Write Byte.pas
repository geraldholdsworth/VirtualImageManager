program Project1;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
 cthreads,
 {$ENDIF}
 Classes,SysUtils
 { you can add units after this };

var
 F: TFileStream;

function ReadByte(Pos: QWord): Byte;
begin
 if Pos<F.Size then
 begin
  F.Position:=Pos;
  Result:=F.ReadByte;
 end else Result:=$FF;
end;

function Read16bit(Pos: QWord;BigEndian: Boolean=False): Word;
begin
 if Pos+1<F.Size then
 begin
  F.Position:=Pos;
  if BigEndian then
   Result:=F.ReadByte<<8 + F.ReadByte
  else
   Result:=F.ReadByte + F.ReadByte<<8;
 end;
end;

procedure WriteByte(Pos: QWord; Value: Byte);
begin
 if Pos>F.Size then F.Size:=Pos;
 F.Position:=Pos;
 F.WriteByte(Value);
end;

procedure Write16bit(Pos: QWord; Value: Word; BigEndian: Boolean=False);
begin
 if Pos+1>F.Size then F.Size:=Pos+1;
 F.Position:=Pos;
 if BigEndian then
 begin
  F.WriteByte(Value>>8);
  F.WriteByte(Value AND $FF);
 end
 else
 begin
  F.WriteByte(Value AND $FF);
  F.WriteByte(Value>>8);
 end;
end;

var
 I: Integer;

begin
 F:=TFileStream.Create('Downloads/Test.txt',fmOpenReadWrite);
 WriteLn('Before:');
 for i:=0 to F.Size-1 do
  WriteLn(i:2,' ',IntToHex(ReadByte(i),2));
 WriteByte( 5,ord('#'));
 WriteByte(25,ord('!'));
 WriteLn('After:');
 for i:=0 to F.Size-1 do
  WriteLn(i:2,' ',ReadByte(i):2);
 WriteLn(IntToHex(Read16bit(7),4));
 F.Free;
end.