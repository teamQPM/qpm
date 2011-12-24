;
; $Id$
;
;
;     QPM - QAC Based Project Manager
;
;     Copyright 2011 Fernando Yurisich <fernando.yurisich@gmail.com>
;     http://qpm.sourceforge.net
;
;     Based on QAC - Project Manager for (x)Harbour
;     Copyright 2006-2011 Carozo de Quilmes <CarozoDeQuilmes@gmail.com>
;     http://www.CarozoDeQuilmes.com.ar
;
;     This program is free software: you can redistribute it and/or modify
;     it under the terms of the GNU General Public License as published by
;     the Free Software Foundation, either version 3 of the License, or
;     (at your option) any later version.
;
;     This program is distributed in the hope that it will be useful,
;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;     GNU General Public License for more details.
;
;     You should have received a copy of the GNU General Public License
;     along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
AppName=QPM (QAC based Project Manager)
AppVerName=QPM v05.03 build 06
AppPublisher=fernando.yurisich
DefaultDirName=C:\QPM_05_03_06
UsePreviousAppDir=no
DefaultGroupName=QPM (QAC based Project Manager)
AllowNoIcons=yes
OutputDir=..\QPM Distribution
OutputBaseFilename=QPM_05_03_0006_Install
SetupIconFile=.\Resource\QPM_Install.ico
Compression=lzma
SolidCompression=yes
ChangesAssociations=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkablealone
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkablealone

[Files]
Source: "QPM.chm"; DestDir: "{app}"; Flags: ignoreversion
Source: "QPM.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_DbfView.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "DbfView.chm"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_dif.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_difwi.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_DllTool.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_dtree.css"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_dtree.im"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_dtree.js"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_hha.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_hhc.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_ImpDef.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_ImpLib.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_itcc.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_Make.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_Msg.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_ObjDump.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_PExports.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_PODump.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_POLib.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_R2H.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_Redir.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_Reimp.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_Res.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_Run.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_Shell.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_Slash.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_Tdump.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_TLib.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_Upx.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "US_windres.exe"; DestDir: "{app}"; Flags: ignoreversion
; Ejemplos
; Agenda
Source: ".\Samples\Agenda\*.*"; DestDir: "{app}\Samples\Agenda"; Flags: ignoreversion
Source: ".\Samples\Agenda\images\*.*"; DestDir: "{app}\Samples\Agenda\images"; Flags: ignoreversion
Source: ".\Samples\Agenda\base\*.*"; DestDir: "{app}\Samples\Agenda\base"; Flags: ignoreversion
; Console Mode
Source: ".\Samples\ConsoleMode\*.*"; DestDir: "{app}\Samples\ConsoleMode"; Flags: ignoreversion
; Contactos
Source: ".\Samples\Contactos\*.*"; DestDir: "{app}\Samples\Contactos"; Flags: ignoreversion
; Make Lib
Source: ".\Samples\MakeLib\*.*"; DestDir: "{app}\Samples\MakeLib"; Flags: ignoreversion
; Merge Console and Graphic Mode
Source: ".\Samples\MergeConsoleModeWithWindowsMode\*.*"; DestDir: "{app}\Samples\MergeConsoleModeWithWindowsMode"; Flags: ignoreversion
; Simple Help Generator (SHG)
Source: ".\Samples\SHG_SimpleHelpGenerator\*.*"; DestDir: "{app}\Samples\SHG_SimpleHelpGenerator"; Flags: ignoreversion
; TsBrowse
Source: ".\Samples\TsBrowse_(Extended_1_5_b54)\*.*"; DestDir: "{app}\Samples\TSBrowse_(Extended_1_3_b38)"; Flags: ignoreversion
Source: ".\Samples\TsBrowse_(Extended_1_5_b54)\BITMAPS\*.*"; DestDir: "{app}\Samples\TSBrowse_(Extended_1_3_b38)\BITMAPS"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\QPM (QAC based Project Manager)"; Filename: "{app}\QPM.exe"
Name: "{group}\{cm:UninstallProgram,QPM (QAC based Project Manager)}"; Filename: "{uninstallexe}"
Name: "{userdesktop}\QPM (QAC based Project Manager)"; Filename: "{app}\QPM.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\QPM (QAC based Project Manager)"; Filename: "{app}\QPM.exe"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\QPM.exe"; Description: "{cm:LaunchProgram,QPM (QAC based Project Manager)}"; Flags: nowait postinstall skipifsilent

[Registry]
Root: HKCR; Subkey: ".qpm"; ValueType: string; ValueName: ""; ValueData: "QPM"; Flags: uninsdeletekey
;".myp" is the extension we're associating. "QPM" is the internal name for the file type as stored in the registry. Make sure you use a unique name for this so you don't inadvertently overwrite another application's registry key.
Root: HKCR; Subkey: ".qpm\ShellNew"; ValueType: string; ValueName: "NullFile"; ValueData: ""
; Esto agrega un item al menu NEW file del explorador
Root: HKCR; Subkey: "QPM"; ValueType: string; ValueName: ""; ValueData: "QPM Project File"; Flags: uninsdeletekey
;"QPM" above is the name for the file type as shown in Explorer.
Root: HKCR; Subkey: "QPM\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\US_Run.EXE,1"
;Root: HKCR; Subkey: "QPM\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\QPM.EXE,1"
;"DefaultIcon" is the registry key that specifies the filename containing the icon to associate with the file type. ",0" tells Explorer to use the first icon from MYPROG.EXE. (",1" would mean the second icon.)
;Root: HKCR; Subkey: "QPM\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\QPM.EXE"" ""%1"""
Root: HKCR; Subkey: "QPM\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\QPM.EXE"" ""%1"" %*"
;"shell\open\command" is the registry key that specifies the program to execute when a file of the type is double-clicked in Explorer. The surrounding quotes are in the command line so it handles long filenames correctly.

; eof
