; This script generates an installation kit for a Windows-native XEmacs, version 21.4.
; This script runs with Inno Setup version 5.1.6, see http://www.jrsoftware.org/ for more info.
;
; Version History
; 2005-12-17  Vin Shelton <acs@xemacs.org>    Move packages out of the version-specific tree
; 2005-12-13  Vin Shelton <acs@xemacs.org>    Created.

[Setup]
AppName=XEmacs
AppVersion={code:XEmacsVersion}
AppVerName=XEmacs {code:XEmacsVersion}
AppPublisher=The XEmacs Development Team
AppPublisherURL=http://www.xemacs.org
AppSupportURL=http://www.xemacs.org
AppUpdatesURL=http://www.xemacs.org
DefaultDirName={sd}\XEmacs
DefaultGroupName=XEmacs
AllowNoIcons=yes
OutputDir=.
OutputBaseFilename=XEmacs Setup 21.4.18-1
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Before you run this script, XEmacs-21.4 must be installed in c:\XEmacs\XEmacs-21.4.xx
; and any packages you want to include must be installed in c:\XEmacs\Packages
Source: "C:\XEmacs\XEmacs-21.4.18\*"; DestDir: "{app}\XEmacs-{code:XEmacsVersion}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\XEmacs\Packages\*"; DestDir: "{app}\Packages"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[INI]
Filename: "{app}\xemacs.url"; Section: "InternetShortcut"; Key: "URL"; String: "http://www.xemacs.org"

[Icons]
Name: "{group}\XEmacs"; Filename: "{app}\XEmacs-{code:XEmacsVersion}\i586-pc-win32\xemacs.exe"
Name: "{group}\{cm:ProgramOnTheWeb,XEmacs}"; Filename: "{app}\xemacs.url"
Name: "{group}\{cm:UninstallProgram,XEmacs}"; Filename: "{uninstallexe}"
Name: "{userdesktop}\XEmacs"; Filename: "{app}\XEmacs-{code:XEmacsVersion}\i586-pc-win32\xemacs.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\XEmacs"; Filename: "{app}\XEmacs-{code:XEmacsVersion}\i586-pc-win32\xemacs.exe"; Tasks: quicklaunchicon

[Registry]
; Set a registry key to point to the packages so they can be shared between multiple installed versions of XEmacs
Root: HKLM; Subkey: "Software\XEmacs\XEmacs"; ValueType: string; ValueName: "EMACSPACKAGEPATH"; ValueData: "{app}\Packages"; Flags: uninsdeletekey

[Run]
Filename: "{app}\XEmacs-{code:XEmacsVersion}\i586-pc-win32\xemacs.exe"; Description: "{cm:LaunchProgram,XEmacs}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: files; Name: "{app}\xemacs.url"

[Code]
function XEmacsVersion(Param: String): String;
begin
  Result := '21.4.18';
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  EtcDir: String;
  SiteStart: String;
begin

  // Create a site-start.el file to allow easy package downloading in the future.
  // E.g, here's what we're going to add to lisp\site-start.el:
  //   (setq package-get-package-index-file-location "C:\\XEmacs\\XEmacs-21.4.18\\etc")
  //   ; Uncomment the next line to select the primary XEmacs package download site
  //   ;(setq package-get-remote '("ftp.xemacs.org" "pub/xemacs/packages"))
  if CurStep = ssPostInstall then begin

    // Convert etc directory name to lisp format by doubling each backslash
    EtcDir := WizardDirValue + '\XEmacs-' + XEmacsVersion('') + '\etc';
    StringChange(EtcDir, '\', '\\');

    SiteStart := WizardDirValue + '\Packages\site-packages\lisp';
    CreateDir(SiteStart);
    SiteStart := SiteStart + '\site-start.el';
    SaveStringToFile(SiteStart, #13#10 + '(setq package-get-package-index-file-location "' + EtcDir + '")' + #13#10, True);
    SaveStringToFile(SiteStart, '; Uncomment the next line to select the primary XEmacs package download site' + #13#10, True);
    SaveStringToFile(SiteStart, ';(setq package-get-remote ' + Chr(39) + '("ftp.xemacs.org" "pub/xemacs/packages"))' + #13#10, True);
  end;
end;


