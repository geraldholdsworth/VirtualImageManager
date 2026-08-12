unit VirtualImage;
{
TVirtualImage class V2.00 and TSpark class V1.06
Manages retro disc images, presenting a list of files and directories to the
parent application. Will also extract files and write new files. Almost a complete
filing system in itself. Compatible with Acorn DFS, Acorn ADFS, UEF, Commodore
1541, Commodore 1571, Commodore 1581, Commodore AmigaDOS, Acorn File Server,
SparkFS, PackDir, MS-DOS, Acorn DOS Plus, Spectrum DSK, and ISO 9660/Joilet.

Copyright ©2018-2026 Gerald Holdsworth gerald@hollypops.co.uk

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
{$mode ObjFPC}{$H+}

interface

uses
 Classes, SysUtils;

type
 TVirtualImage = class
  private
   //System classes
   type
    TADFSImage = record  //Acorn ADFS
   end;
   type
    TDFSImage = record   //Acorn DFS
   end;
   type
    TAFSImage = record   //Acorn File Store
   end;
   type
    TUEFImage = record   //Unified Emulator Format (cassette)
   end;
   type
    TRFSImage = record   //Acorn ROM Filing System (RFS)
   end;
   type
    TC64Image = record   //Commodore 64
   end;
   type
    TAmigaImage = record //Commodore Amiga
   end;
   type
    TSparkImage = record //Spark/ZIP/Pack
   end;
   type
    TDOSImage = record   //DOS and DOS+
   end;
   type
    TISOImage = record   //ISO
   end;
   type
    TDSKImage = record   //Amstrad CPC and Sinclair +3
   end;
 end;

implementation

end.

