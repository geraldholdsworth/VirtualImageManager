program Project1;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
 cthreads,
 {$ENDIF}
 Classes,SysUtils
 { you can add units after this };

type
 TDirEntry = record
  Directory: String;
  Depth    : Integer;
  Path     : String;
  Entries  : array of TDirEntry;
 end;
 TEntries = array of TDirEntry;

procedure UpdateEntries(var E: TEntries; P: String; D: Integer);
var
 I: Integer=0;
begin
 if Length(E)>0 then
  for I:=0 to Length(E)-1 do
  begin
   UpdateEntries(E[I].Entries,P+'.'+E[I].Directory,D+1);
   E[I].Path:=P;
   E[I].Depth:=D;
  end;
end;

procedure DisplayEntries(var E: TEntries);
var
 I: Integer=0;
begin
 if Length(E)>0 then
  for I:=0 to Length(E)-1 do
  begin
   WriteLn(E[I].Path,'.',E[I].Directory);
   DisplayEntries(E[I].Entries);
  end;
end;

function FindEntry(P: String;ThisDir: TEntries;var ResDir:TDirEntry): Boolean;
var
 path: array of String=nil;
 i: Integer=0;
 d: Integer=0;
 query: String='';
begin
 Result:=False;
 SetLength(path,0);
 path:=P.Split('.');
 if Length(path)>1 then
 begin
  i:=0;
  while(i<Length(ThisDir))and(not Result)do
  begin
   if ThisDir[i].Directory=path[0] then
   begin
    query:='';
    for d:=1 to Length(path)-1 do query:=query+'.'+path[d];
    query:=Copy(query,2);
    Result:=FindEntry(query,ThisDir[i].Entries,ResDir);
   end;
   inc(i);
  end;
 end
 else
  if Length(ThisDir)>0 then
   for i:=0 to Length(ThisDir)-1 do
    if ThisDir[i].Directory=path[0] then
    begin
     ResDir:=ThisDir[i];
     Result:=True;
    end;
end;

var
 Dir: TEntries=nil;
 Me: TDirEntry=();

begin
 SetLength(Dir,2);
 Dir[0].Directory:='First';
 SetLength(Dir[0].Entries,3);
 Dir[0].Entries[0].Directory:='First';
 Dir[0].Entries[1].Directory:='Second';
 Dir[0].Entries[2].Directory:='Third';
 SetLength(Dir[0].Entries[1].Entries,5);
 Dir[0].Entries[1].Entries[0].Directory:='First';
 Dir[0].Entries[1].Entries[1].Directory:='Second';
 Dir[0].Entries[1].Entries[2].Directory:='Third';
 Dir[0].Entries[1].Entries[3].Directory:='Fourth';
 Dir[0].Entries[1].Entries[4].Directory:='Fifth';
 Dir[1].Directory:='Second';
 SetLength(Dir[1].Entries,1);
 Dir[1].Entries[0].Directory:='First';
 UpdateEntries(Dir,'Root',0);
 //
 DisplayEntries(Dir);
 if FindEntry('First.Second',Dir,Me) then
  WriteLn('Found: ',Me.Path,' ',Me.Directory,' ',Me.Depth,' ',Length(Me.Entries))
 else
  WriteLn('Not found');
 if FindEntry('First.Second.Third',Dir,Me) then
  WriteLn('Found: ',Me.Path,' ',Me.Directory,' ',Me.Depth,' ',Length(Me.Entries))
 else
  WriteLn('Not found');
 if FindEntry('First.Second.Third.Sixth',Dir,Me) then
  WriteLn('Found: ',Me.Path,' ',Me.Directory,' ',Me.Depth,' ',Length(Me.Entries))
 else
  WriteLn('Not found');
 if FindEntry('First.Seventh',Dir,Me) then
  WriteLn('Found: ',Me.Path,' ',Me.Directory,' ',Me.Depth,' ',Length(Me.Entries))
 else
  WriteLn('Not found');
end.
