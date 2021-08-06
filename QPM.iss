;
;     QPM - QAC based Project Manager
;
;     Copyright 2011-2021 Fernando Yurisich <fernando.yurisich@gmail.com>
;     https://teamqpm.github.io/
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
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{97C57005-5ED6-4F8F-BF4B-6A4CBA41A342}
AppName=QPM (QAC based Project Manager)
AppVerName=QPM v05.05.0022
AppPublisher=Fernando Yurisich
AppCopyright=Copyright 2011-2021 QPM Development Team
AppPublisherURL=https://github.com/fyurisich/qpm
AppSupportURL=https://github.com/fyurisich/qpm
AppUpdatesURL=https://github.com/fyurisich/qpm
DefaultDirName=C:\QPM
UsePreviousAppDir=yes
DefaultGroupName=QPM (QAC based Project Manager)
AllowNoIcons=yes
OutputDir=OBJE1BH_32
OutputBaseFilename=QPM_05_05_0022_Install
SetupIconFile=.\Resource\QPM_Install.ico
Compression=lzma2
ChangesAssociations=yes
UninstallDisplayIcon={uninstallexe}
InfoBeforeFile=infobefore.txt

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkablealone

[Files]
Source: "QPM.chm"; DestDir: "{app}"; Flags: ignoreversion
Source: "QPM.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_dbfview.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "dbfview.chm"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_dif.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_difwi.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_dtree.css"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_dtree.im"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_dtree.js"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_hha.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_hhc.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_impdef.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_implib.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_itcc.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_make.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_msg.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_objdump.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_pexports.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_podump.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_polib.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_r2h.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_reimp.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_res.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_run.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_shell.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_slash.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_tdump.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_tlib.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "us_upx.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "PayPal Donate.url"; DestDir: "{app}"; Flags: ignoreversion
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
Name: "{group}\{cm:UninstallProgram,QPM (QAC based Project Manager)}"; Filename: "{uninstallexe}"; WorkingDir: "{app}"; IconFilename: "{app}\QPM.ico"
Name: "{autodesktop}\QPM (QAC based Project Manager)"; Filename: "{app}\QPM.exe"; Tasks: desktopicon

[Run]
Filename: "https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=VYXQYCKWXLWAG&currency_code=USD&source=url"; Flags: shellexec runasoriginaluser postinstall; Description: Make a donation via PayPal;

[Registry]
Root: HKCR; Subkey: ".qpm"; ValueType: string; ValueName: ""; ValueData: "QPM"; Flags: uninsdeletekey
;".qpm" is the extension we're associating. "QPM" is the internal name for the file type as stored in the registry. Make sure you use a unique name for this so you don't inadvertently overwrite another application's registry key.
Root: HKCR; Subkey: ".qpm\ShellNew"; ValueType: string; ValueName: "NullFile"; ValueData: ""
; Esto agrega un item al menu NEW file del explorador
Root: HKCR; Subkey: "QPM"; ValueType: string; ValueName: ""; ValueData: "QPM Project File"; Flags: uninsdeletekey
;"QPM" above is the name for the file type as shown in Explorer.
Root: HKCR; Subkey: "QPM\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\qpm.exe,1"
;Root: HKCR; Subkey: "QPM\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\QPM.exe,1"
;"DefaultIcon" is the registry key that specifies the filename containing the icon to associate with the file type. ",0" tells Explorer to use the first icon from QPM.exe. (",1" would mean the second icon.)
Root: HKCR; Subkey: "QPM\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\QPM.exe"" ""%1"" %*"
;"shell\open\command" is the registry key that specifies the program to execute when a file of the type is double-clicked in Explorer. The surrounding quotes are in the command line so it handles long filenames correctly.

[UninstallDelete]
Type: files; Name: "{app}\filler"
Type: files; Name: "{app}\hha.dll"
Type: files; Name: "{app}\QPM.exe.LOG"

[Messages]
BeveledLabel=QPM (QAC based Project Manager)

[Code]
var InfoBeforeCheck: TNewCheckBox;
  
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usDone then
  begin
    if DirExists(ExpandConstant('{app}')) then
    begin
      MsgBox(ExpandConstant('Installation folder {app} was not removed' + #13#10 + 'because it contains user created files!'), mbInformation, MB_OK);
    end; 
  end;
end;

procedure CheckInfoBeforeRead;
begin
  { Enable the NextButton only if InfoBeforeCheck is checked or }
  { installer is running in the silent mode }
  WizardForm.NextButton.Enabled := InfoBeforeCheck.Checked or WizardSilent;
end;

procedure InfoBeforeCheckClick(Sender: TObject);
begin
  { Update state of the Next button, whenever the InfoBeforeCheck is toggled }
  CheckInfoBeforeRead;
end;  

procedure InitializeWizard();
begin
  InfoBeforeCheck := TNewCheckBox.Create(WizardForm);
  InfoBeforeCheck.Parent := WizardForm.InfoBeforePage;
  { Follow the License page layout }
  InfoBeforeCheck.Top := WizardForm.LicenseNotAcceptedRadio.Top;
  InfoBeforeCheck.Left := WizardForm.LicenseNotAcceptedRadio.Left;
  InfoBeforeCheck.Width := WizardForm.LicenseNotAcceptedRadio.Width;
  InfoBeforeCheck.Height := WizardForm.LicenseNotAcceptedRadio.Height;
  InfoBeforeCheck.Caption := 'I swear I read this';
  InfoBeforeCheck.OnClick := @InfoBeforeCheckClick;

  { Make the gap between the InfoBeforeMemo and the InfoBeforeCheck the same }
  { as the gap between LicenseMemo and LicenseAcceptedRadio }
  WizardForm.InfoBeforeMemo.Height :=
    ((WizardForm.LicenseMemo.Top + WizardForm.LicenseMemo.Height) -
     WizardForm.InfoBeforeMemo.Top) +
    (InfoBeforeCheck.Top - WizardForm.LicenseAcceptedRadio.Top);
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpInfoBefore then
  begin
    { Initial state of the Next button }
    CheckInfoBeforeRead;
  end;
end;
