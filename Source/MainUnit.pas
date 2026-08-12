unit MainUnit;
{
Copyright (C) 2018-2026 Gerald Holdsworth gerald@hollypops.co.uk

This source is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public Licence as published by the Free
Software Foundation; either version 3 of the Licence, or (at your option)
any later version.

This code is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public Licence for more
details.

A copy of the GNU General Public Licence is available on the World Wide Web
at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
to the Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
Boston, MA 02110-1335, USA.
}
{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
 VirtualImage;

type
 TMainForm = class(TForm)
  TitlePanel: TPanel;
  ImageDetailPanel: TPanel;
  InsertedImages: TListView;
  ImageIcons: TImageList;
 private

 public

 end;
{
 Image List:
  0 ADFS Floppy S/M/L
  1 ADFS Floppy D
  2 ADFS Floppy E,E+,F,F+
  3 DFS Floppy           (maybe change to 5.25" floppy)
  4 Commodore 64 Floppy  (maybe change to 5.25" floppy)
  5 Commodore Amiga Floppy
  6 DOS Floppy
  7 Sinclair/Amstrad Floppy
  8 ADFS Hard Drive Old Map
  9 ADFS Hard Drive New Map Old Dirs
 10 ADFS Hard Drive New Map New/Big Dirs
 11 Commodore Amiga Hard Drive
 12 DOS Hard Drive
 13 Cassette (UEF)
 14 ISO (CD)
 15 ROMFS
 To add:
    Watford DFS
    Acorn File Server
    SparkFS/ZIP/Pack
}

var
 MainForm: TMainForm;

implementation

{$R *.lfm}

end.

