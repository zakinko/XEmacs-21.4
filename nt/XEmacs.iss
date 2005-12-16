; This script generates an installation kit for a Windows-native XEmacs, version 21.4.
; This script runs with Inno Setup version 5.1.6, see http://www.jrsoftware.org/ for more info.
; 2005-12-13  Vin Shelton <acs@xemacs.org>    Created.

[Setup]
AppName=XEmacs
AppVersion={code:XEmacsVersion}
AppVerName=XEmacs {code:XEmacsVersion}
AppPublisher=The XEmacs Development Team
AppPublisherURL=http://www.xemacs.org
AppSupportURL=http://www.xemacs.org
AppUpdatesURL=http://www.xemacs.org
DefaultDirName={sd}\XEmacs-{code:XEmacsVersion}
DefaultGroupName=XEmacs
AllowNoIcons=yes
OutputDir=.
OutputBaseFilename=XEmacs Setup 21.4.18
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\XEmacs-21.4.18\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[INI]
Filename: "{app}\xemacs.url"; Section: "InternetShortcut"; Key: "URL"; String: "http://www.xemacs.org"

[Icons]
Name: "{group}\XEmacs"; Filename: "{app}\i586-pc-win32\xemacs.exe"
Name: "{group}\{cm:ProgramOnTheWeb,XEmacs}"; Filename: "{app}\xemacs.url"
Name: "{group}\{cm:UninstallProgram,XEmacs}"; Filename: "{uninstallexe}"
Name: "{userdesktop}\XEmacs"; Filename: "{app}\i586-pc-win32\xemacs.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\XEmacs"; Filename: "{app}\i586-pc-win32\xemacs.exe"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\i586-pc-win32\xemacs.exe"; Description: "{cm:LaunchProgram,XEmacs}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: files; Name: "{app}\xemacs.url"

[Code]
var
  FinishedInstall: Boolean;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
    FinishedInstall := True;
end;

procedure DeinitializeSetup();
var
  EtcDir: String;
  SiteStart: String;
begin
  // Create a site-start.el file to allow easy package downloading in the future.
  // E.g, here's what we're going to add to lisp\site-start.el:
  //   (setq package-get-package-index-file-location "C:\\XEmacs-21.4.18\\etc")
  //   ; Uncomment the next line to select the primary XEmacs package download site
  //   ;(setq package-get-remote '("ftp.xemacs.org" "pub/xemacs/packages"))
  if FinishedInstall = True then begin

    // Convert etc directory name to lisp format by doubling each backslash
    EtcDir := WizardDirValue + '\etc';
    StringChange(EtcDir, '\', '\\');

    SiteStart := WizardDirValue + '\lisp\site-start.el';
    SaveStringToFile(SiteStart, #13#10 + '(setq package-get-package-index-file-location "' + EtcDir + '")' + #13#10, True);
    SaveStringToFile(SiteStart, '; Uncomment the next line to select the primary XEmacs package download site' + #13#10, True);
    SaveStringToFile(SiteStart, ';(setq package-get-remote ' + Chr(39) + '("ftp.xemacs.org" "pub/xemacs/packages"))' + #13#10, True);
  end;
end;

function XEmacsVersion(Param: String): String;
begin
  Result := '21.4.18';
end;

