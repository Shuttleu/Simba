{
	This file is part of the Mufasa Macro Library (MML)
	Copyright (c) 2009 by Raymond van Venetië and Merlijn Wajer

    MML is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    MML is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with MML.  If not, see <http://www.gnu.org/licenses/>.

	See the file COPYING, included in this distribution,
	for details about the copyright.

    Client class for the Mufasa Macro Library
}


unit Client;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MufasaTypes,MufasaBase,
  IOManager, Files, Finder, Bitmaps, dtm, ocr,
  {$IFDEF MSWINDOWS} os_windows {$ENDIF}
  {$IFDEF LINUX} os_linux {$ENDIF};

{
TClient is a full-blown instance of the MML.
It binds all the components together.
}

type

  TClient = class(TObject)
  private
    FOwnIOManager : boolean;
  public
    IOManager: TIOManager;
    MFiles: TMFiles;
    MFinder: TMFinder;
    MBitmaps : TMBitmaps;
    MDTMs: TMDTMS;
    MOCR: TMOCR;
    WritelnProc : TWritelnProc;
    procedure WriteLn(s : string);
    constructor Create(const plugin_dir: string = ''; const UseIOManager : TIOManager = nil);
    destructor Destroy; override;
  end;

implementation



procedure TClient.WriteLn(s: string);
begin
  if (self <> nil) and Assigned(WritelnProc) then
    WritelnProc(s)
  else
    mDebugLn(s);
end;

// Possibly pass arguments to a default window.
constructor TClient.Create(const plugin_dir: string = ''; const UseIOManager : TIOManager = nil);
begin
  inherited Create;
  WritelnProc:= nil;
  if UseIOManager = nil then
    IOManager := TIOManager.Create(plugin_dir)
  else
    IOManager := UseIOManager;
  FOwnIOManager := (UseIOManager = nil);
  MFiles := TMFiles.Create(self);
  MFinder := TMFinder.Create(Self);
  MBitmaps := TMBitmaps.Create(self);
  MDTMs := TMDTMS.Create(self);
  MOCR := TMOCR.Create(self);
end;

destructor TClient.Destroy;
begin
  if FOwnIOManager then
    IOManager.SetState(True);

  MOCR.Free;
  MDTMs.Free;
  MBitmaps.Free;
  MFinder.Free;
  MFiles.Free;
  if FOwnIOManager then
    IOManager.Free;

  inherited;
end;

end.

