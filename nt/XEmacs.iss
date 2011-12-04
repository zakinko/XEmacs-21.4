; This script generates an installation kit for a Windows-native XEmacs, 21.4 and 21.5.
; This script runs with Inno Setup version 5.1.6, see http://www.jrsoftware.org/ for more info.
; This script requires the Inno Setup pre-processor.
;
; Version History
; 2011-12-01  Vin Shelton <acs@xemacs.org>    Add all packages to the kit.
; 2009-01-29  Vin Shelton <acs@xemacs.org>    Add MSVCR80.dll, which is required by VS 2005 and needed at
;                                             installation time by minitar.
; 2009-01-06  Vin Shelton <acs@xemacs.org>    Remove {#KitName} and {#XEmacs_Branch} and force the caller
;                                             to define the ReadMe file name and Setup file name directly.
; 2009-01-03  Vin Shelton <acs@xemacs.org>    Bump default version to 21.4.22.
; 2008-01-24  Vin Shelton <acs@xemacs.org>    Implement the concept of release kits, like "XEmacs_Setup_21.4.21.exe"
;                                             and replace the version info with a date string in non-release kits, so
;                                             experimental kits are named something like "XEmacs_Setup_21.4-2008-01-24.exe".
;                                             This feature was implemented at the request of Adrian Aichner, who
;                                             found the string "21.4.21-2008-01-24" misleading, because the kit is built
;                                             based on current CVS or mercurial sources, not from the release sources.
; 2007-09-26  Vin Shelton <acs@xemacs.org>    Remove setting of package-get-always-update and miscellaneous cleanup.
; 2007-09-25  Vin Shelton <acs@xemacs.org>    Put comment wrapper around site-start.el changes and remove them on uninstall.
;                                             Enable ftp.xemacs.org for packages and set path to ftp.exe in site-start.el.
; 2007-09-06  Vin Shelton <acs@xemacs.org>    Added easypg.
; 2006-04-06  Vin Shelton <acs@xemacs.org>    Changed defaults for ExecSrc and PkgSrc.
;                                             Don't set 'Start in' property.
; 2006-04-02  Vin Shelton <acs@xemacs.org>    Set 'Start in' property for shortcuts to 'My Documents' directory.
; 2006-03-03  Vin Shelton <acs@xemacs.org>    Support for 21.5.  Added packages as separate components.
; 2006-01-28  Vin Shelton <acs@xemacs.org>    Erase unused registry code.
; 2006-01-26  Vin Shelton <acs@xemacs.org>    Don't append XEmacs binary directory to system path.
; 2006-01-21  Vin Shelton <acs@xemacs.org>    Append XEmacs binary directory to system path; this is not currently
;                                             deleted on uninstall.
;                                             Get built kit from C:\XEmacs-built.
; 2005-12-26  Vin Shelton <acs@xemacs.org>    Packages are now installed directly into {app}\xemacs-packages, etc.
;                                             As of 21.4.19, the package root is found automatically,
;                                             so EMACSPACKAGEPATH is no longer necessary.
; 2005-12-17  Vin Shelton <acs@xemacs.org>    Move packages out of the version-specific tree.
; 2005-12-13  Vin Shelton <acs@xemacs.org>    Created.

; Allow undefined identifiers
#pragma parseroption -u+

;#define QUICKIE_TEST

#ifndef XEmacsVersion
  #define XEmacsVersion "21.4.22"
#endif
#ifndef ExecSrc
  #define ExecSrc     "installed"
#endif
#ifndef PkgSrc
  #define PkgSrc      "packages"
#endif
#ifndef ReadMe
  #define ReadMe      "ReadMe"
#endif
#ifndef KitFile
  #define KitFile     "XEmacs_Setup"
#endif

[Setup]
AllowNoIcons=yes
AppName=XEmacs
AppVerName=XEmacs {#XEmacsVersion}
AppPublisher=XEmacs Development Team
AppPublisherURL=http://www.xemacs.org
AppSupportURL=http://www.xemacs.org
AppUpdatesURL=http://www.xemacs.org
Compression=lzma
DefaultDirName={pf}\XEmacs
DefaultGroupName=XEmacs
InfoBeforeFile={#ReadMe}
OutputBaseFilename={#KitFile}
OutputDir=.
SolidCompression=yes
UninstallFilesDir={app}/XEmacs-{#XEmacsVersion}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
StatusRunProgram=Unpacking selected packages...

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Always installed
Source: "{#ExecSrc}\XEmacs-{#XEmacsVersion}\*"; DestDir: "{app}\XEmacs-{#XEmacsVersion}"; Flags: ignoreversion recursesubdirs
Source: "{#PkgSrc}\efs-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Flags: ignoreversion
Source: "{#PkgSrc}\xemacs-base-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Flags: ignoreversion
; minitar.exe and unpack.cmd are used to unpack the packages
Source: "{#ExecSrc}\XEmacs-{#XEmacsVersion}\i586-pc-win32\minitar.exe"; DestDir: "{app}\xemacs-packages"; Flags: ignoreversion
Source: "{#ExecSrc}\XEmacs-{#XEmacsVersion}\i586-pc-win32\MSVCR80.dll"; DestDir: "{app}\xemacs-packages"; Flags: ignoreversion
Source: "unpack.cmd"; DestDir: "{app}\xemacs-packages"; Flags: ignoreversion
Source: "{#PkgSrc}\package-index.LATEST.gpg"; DestDir: "{app}";
#ifndef QUICKIE_TEST
Source: "{#PkgSrc}\Sun-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: Sun; Flags: ignoreversion
Source: "{#PkgSrc}\ada-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: ada; Flags: ignoreversion
Source: "{#PkgSrc}\apel-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: apel; Flags: ignoreversion
Source: "{#PkgSrc}\auctex-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: auctex; Flags: ignoreversion
Source: "{#PkgSrc}\bbdb-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: bbdb; Flags: ignoreversion
Source: "{#PkgSrc}\build-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: build; Flags: ignoreversion
Source: "{#PkgSrc}\c-support-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: c_support; Flags: ignoreversion
Source: "{#PkgSrc}\calc-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: calc; Flags: ignoreversion
Source: "{#PkgSrc}\calendar-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: calendar; Flags: ignoreversion
Source: "{#PkgSrc}\cc-mode-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: cc_mode; Flags: ignoreversion
Source: "{#PkgSrc}\cedet-common-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: cedet_common; Flags: ignoreversion
Source: "{#PkgSrc}\clearcase-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: clearcase; Flags: ignoreversion
Source: "{#PkgSrc}\cogre-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: cogre; Flags: ignoreversion
Source: "{#PkgSrc}\cookie-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: cookie; Flags: ignoreversion
Source: "{#PkgSrc}\crisp-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: crisp; Flags: ignoreversion
Source: "{#PkgSrc}\debug-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: debug; Flags: ignoreversion
Source: "{#PkgSrc}\dictionary-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: dictionary; Flags: ignoreversion
Source: "{#PkgSrc}\dired-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: dired; Flags: ignoreversion
Source: "{#PkgSrc}\docbookide-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: docbookide; Flags: ignoreversion
Source: "{#PkgSrc}\easypg-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: easypg; Flags: ignoreversion
Source: "{#PkgSrc}\ecb-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: ecb; Flags: ignoreversion
Source: "{#PkgSrc}\ecrypto-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: ecrypto; Flags: ignoreversion
Source: "{#PkgSrc}\ede-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: ede; Flags: ignoreversion
Source: "{#PkgSrc}\edebug-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: edebug; Flags: ignoreversion
#ifdef MULE
Source: "{#PkgSrc}\edict-*-pkg.tar"; DestDir: "{app}\mule-packages"; Components: edict; Flags: ignoreversion
#endif
Source: "{#PkgSrc}\ediff-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: ediff; Flags: ignoreversion
Source: "{#PkgSrc}\edit-utils-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: edit_utils; Flags: ignoreversion
Source: "{#PkgSrc}\edt-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: edt; Flags: ignoreversion
Source: "{#PkgSrc}\efs-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: efs; Flags: ignoreversion
#ifdef MULE
Source: "{#PkgSrc}\egg-its-*-pkg.tar"; DestDir: "{app}\mule-packages"; Components: egg_its; Flags: ignoreversion
#endif
Source: "{#PkgSrc}\eieio-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: eieio; Flags: ignoreversion
Source: "{#PkgSrc}\elib-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: elib; Flags: ignoreversion
Source: "{#PkgSrc}\emerge-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: emerge; Flags: ignoreversion
Source: "{#PkgSrc}\erc-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: erc; Flags: ignoreversion
Source: "{#PkgSrc}\escreen-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: escreen; Flags: ignoreversion
Source: "{#PkgSrc}\eshell-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: eshell; Flags: ignoreversion
Source: "{#PkgSrc}\eterm-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: eterm; Flags: ignoreversion
Source: "{#PkgSrc}\eudc-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: eudc; Flags: ignoreversion
Source: "{#PkgSrc}\footnote-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: footnote; Flags: ignoreversion
Source: "{#PkgSrc}\forms-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: forms; Flags: ignoreversion
Source: "{#PkgSrc}\fortran-modes-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: fortran_modes; Flags: ignoreversion
Source: "{#PkgSrc}\frame-icon-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: frame_icon; Flags: ignoreversion
Source: "{#PkgSrc}\fsf-compat-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: fsf_compat; Flags: ignoreversion
Source: "{#PkgSrc}\games-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: games; Flags: ignoreversion
Source: "{#PkgSrc}\general-docs-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: general_docs; Flags: ignoreversion
Source: "{#PkgSrc}\gnats-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: gnats; Flags: ignoreversion
Source: "{#PkgSrc}\gnus-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: gnus; Flags: ignoreversion
Source: "{#PkgSrc}\guided-tour-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: guided_tour; Flags: ignoreversion
Source: "{#PkgSrc}\haskell-mode-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: haskell_mode; Flags: ignoreversion
Source: "{#PkgSrc}\hm--html-menus-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: hm__html_menus; Flags: ignoreversion
Source: "{#PkgSrc}\hyperbole-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: hyperbole; Flags: ignoreversion
Source: "{#PkgSrc}\ibuffer-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: ibuffer; Flags: ignoreversion
Source: "{#PkgSrc}\idlwave-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: idlwave; Flags: ignoreversion
Source: "{#PkgSrc}\igrep-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: igrep; Flags: ignoreversion
Source: "{#PkgSrc}\ilisp-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: ilisp; Flags: ignoreversion
Source: "{#PkgSrc}\ispell-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: ispell; Flags: ignoreversion
Source: "{#PkgSrc}\jde-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: jde; Flags: ignoreversion
#ifdef MULE
Source: "{#PkgSrc}\latin-euro-standards-*-pkg.tar"; DestDir: "{app}\mule-packages"; Components: latin_euro_standards; Flags: ignoreversion
Source: "{#PkgSrc}\latin-unity-*-pkg.tar"; DestDir: "{app}\mule-packages"; Components: latin_unity; Flags: ignoreversion
Source: "{#PkgSrc}\leim-*-pkg.tar"; DestDir: "{app}\mule-packages"; Components: leim; Flags: ignoreversion
Source: "{#PkgSrc}\locale-*-pkg.tar"; DestDir: "{app}\mule-packages"; Components: locale; Flags: ignoreversion
Source: "{#PkgSrc}\lookup-*-pkg.tar"; DestDir: "{app}\mule-packages"; Components: lookup; Flags: ignoreversion
#endif
Source: "{#PkgSrc}\mail-lib-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: mail_lib; Flags: ignoreversion
Source: "{#PkgSrc}\mailcrypt-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: mailcrypt; Flags: ignoreversion
Source: "{#PkgSrc}\mew-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: mew; Flags: ignoreversion
Source: "{#PkgSrc}\mh-e-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: mh_e; Flags: ignoreversion
Source: "{#PkgSrc}\mine-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: mine; Flags: ignoreversion
Source: "{#PkgSrc}\misc-games-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: misc_games; Flags: ignoreversion
Source: "{#PkgSrc}\mmm-mode-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: mmm_mode; Flags: ignoreversion
#ifdef MULE
Source: "{#PkgSrc}\mule-base-*-pkg.tar"; DestDir: "{app}\mule-packages"; Components: mule_base; Flags: ignoreversion
Source: "{#PkgSrc}\mule-ucs-*-pkg.tar"; DestDir: "{app}\mule-packages"; Components: mule_ucs; Flags: ignoreversion
#endif
Source: "{#PkgSrc}\net-utils-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: net_utils; Flags: ignoreversion
Source: "{#PkgSrc}\ocaml-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: ocaml; Flags: ignoreversion
Source: "{#PkgSrc}\oo-browser-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: oo_browser; Flags: ignoreversion
Source: "{#PkgSrc}\os-utils-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: os_utils; Flags: ignoreversion
Source: "{#PkgSrc}\pc-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: pc; Flags: ignoreversion
Source: "{#PkgSrc}\pcl-cvs-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: pcl_cvs; Flags: ignoreversion
Source: "{#PkgSrc}\pcomplete-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: pcomplete; Flags: ignoreversion
Source: "{#PkgSrc}\perl-modes-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: perl_modes; Flags: ignoreversion
Source: "{#PkgSrc}\pgg-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: pgg; Flags: ignoreversion
Source: "{#PkgSrc}\prog-modes-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: prog_modes; Flags: ignoreversion
Source: "{#PkgSrc}\ps-print-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: ps_print; Flags: ignoreversion
Source: "{#PkgSrc}\psgml-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: psgml; Flags: ignoreversion
Source: "{#PkgSrc}\psgml-dtds-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: psgml_dtds; Flags: ignoreversion
Source: "{#PkgSrc}\python-modes-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: python_modes; Flags: ignoreversion
Source: "{#PkgSrc}\re-builder-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: re_builder; Flags: ignoreversion
Source: "{#PkgSrc}\reftex-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: reftex; Flags: ignoreversion
Source: "{#PkgSrc}\riece-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: riece; Flags: ignoreversion
Source: "{#PkgSrc}\rmail-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: rmail; Flags: ignoreversion
Source: "{#PkgSrc}\ruby-modes-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: ruby_modes; Flags: ignoreversion
Source: "{#PkgSrc}\sasl-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: sasl; Flags: ignoreversion
Source: "{#PkgSrc}\scheme-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: scheme; Flags: ignoreversion
Source: "{#PkgSrc}\semantic-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: semantic; Flags: ignoreversion
Source: "{#PkgSrc}\sgml-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: sgml; Flags: ignoreversion
Source: "{#PkgSrc}\sh-script-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: sh_script; Flags: ignoreversion
Source: "{#PkgSrc}\sieve-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: sieve; Flags: ignoreversion
#ifdef MULE
Source: "{#PkgSrc}\skk-*-pkg.tar"; DestDir: "{app}\mule-packages"; Components: skk; Flags: ignoreversion
#endif
Source: "{#PkgSrc}\slider-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: slider; Flags: ignoreversion
Source: "{#PkgSrc}\sml-mode-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: sml_mode; Flags: ignoreversion
Source: "{#PkgSrc}\sounds-au-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: sounds_au; Flags: ignoreversion
Source: "{#PkgSrc}\sounds-wav-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: sounds_wav; Flags: ignoreversion
Source: "{#PkgSrc}\speedbar-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: speedbar; Flags: ignoreversion
Source: "{#PkgSrc}\strokes-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: strokes; Flags: ignoreversion
Source: "{#PkgSrc}\supercite-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: supercite; Flags: ignoreversion
Source: "{#PkgSrc}\texinfo-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: texinfo; Flags: ignoreversion
Source: "{#PkgSrc}\text-modes-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: text_modes; Flags: ignoreversion
Source: "{#PkgSrc}\textools-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: textools; Flags: ignoreversion
Source: "{#PkgSrc}\time-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: time; Flags: ignoreversion
Source: "{#PkgSrc}\tm-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: tm; Flags: ignoreversion
Source: "{#PkgSrc}\tooltalk-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: tooltalk; Flags: ignoreversion
Source: "{#PkgSrc}\tpu-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: tpu; Flags: ignoreversion
Source: "{#PkgSrc}\tramp-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: tramp; Flags: ignoreversion
Source: "{#PkgSrc}\vc-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: vc; Flags: ignoreversion
Source: "{#PkgSrc}\vc-cc-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: vc_cc; Flags: ignoreversion
Source: "{#PkgSrc}\vhdl-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: vhdl; Flags: ignoreversion
Source: "{#PkgSrc}\view-process-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: view_process; Flags: ignoreversion
Source: "{#PkgSrc}\viper-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: viper; Flags: ignoreversion
Source: "{#PkgSrc}\vm-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: vm; Flags: ignoreversion
Source: "{#PkgSrc}\w3-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: w3; Flags: ignoreversion
Source: "{#PkgSrc}\x-symbol-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: x_symbol; Flags: ignoreversion
Source: "{#PkgSrc}\xemacs-base-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: xemacs_base; Flags: ignoreversion
Source: "{#PkgSrc}\xemacs-devel-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: xemacs_devel; Flags: ignoreversion
Source: "{#PkgSrc}\xetla-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: xetla; Flags: ignoreversion
Source: "{#PkgSrc}\xlib-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: xlib; Flags: ignoreversion
Source: "{#PkgSrc}\xslide-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: xslide; Flags: ignoreversion
Source: "{#PkgSrc}\xslt-process-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: xslt_process; Flags: ignoreversion
Source: "{#PkgSrc}\xwem-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: xwem; Flags: ignoreversion
Source: "{#PkgSrc}\zenirc-*-pkg.tar"; DestDir: "{app}\xemacs-packages"; Components: zenirc; Flags: ignoreversion
#endif  // ifndef QUICKIE_TEST

[Types]
Name: "recommended"; Description: "Recommended installation"
Name: "complete"; Description: "Install XEmacs {#XEmacsVersion} and all packages"
Name: "minimal"; Description: "Minimalist installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Components]
Name: "base"; Description: "XEmacs {#XEmacsVersion} executable and essential support files"; Types: complete minimal recommended custom; Flags: fixed
Name: "Sun"; Description: "Sun: Support for Sparcworks."; Types: complete custom
Name: "ada"; Description: "ada: Ada language support."; Types: complete custom
Name: "apel"; Description: "apel: A Portable Emacs Library.  Used by XEmacs MIME support."; Types: complete custom
Name: "auctex"; Description: "auctex: Basic TeX/LaTeX support."; Types: complete custom
Name: "bbdb"; Description: "bbdb: The Big Brother Data Base"; Types: complete custom
Name: "build"; Description: "build: Build XEmacs from within (UNIX, Windows)."; Types: complete custom
Name: "c_support"; Description: "c-support: Basic single-file add-ons for editing C code."; Types: complete custom recommended
Name: "calc"; Description: "calc: Emacs calculator"; Types: complete custom
Name: "calendar"; Description: "calendar: Calendar and diary support."; Types: complete custom
Name: "cc_mode"; Description: "cc-mode: C, C++, Objective-C, Java, CORBA IDL, Pike and AWK language support."; Types: complete custom recommended
Name: "cedet_common"; Description: "cedet-common: Common files for CEDET development environment."; Types: complete custom
Name: "clearcase"; Description: "clearcase: New Clearcase Version Control for XEmacs (UNIX, Windows)."; Types: complete custom
Name: "cogre"; Description: "cogre: Graph editing mode."; Types: complete custom
Name: "cookie"; Description: "cookie: Spook and Yow (Zippy quotes)."; Types: complete custom
Name: "crisp"; Description: "crisp: Crisp/Brief emulation."; Types: complete custom
Name: "debug"; Description: "debug: GUD, gdb, dbx debugging support."; Types: complete custom recommended
Name: "dictionary"; Description: "dictionary: Interface to RFC2229 dictionary servers."; Types: complete custom
Name: "dired"; Description: "dired: Manage file systems."; Types: complete custom recommended
Name: "docbookide"; Description: "docbookide: DocBook editing support."; Types: complete custom
Name: "easypg"; Description: "easypg: GnuPG interface for Emacs."; Types: complete custom
Name: "ecb"; Description: "ecb: Emacs source code browser."; Types: complete custom recommended
Name: "ecrypto"; Description: "ecrypto: Crypto functionality in Emacs Lisp."; Types: complete custom
Name: "ede"; Description: "ede: Emacs Development Environment."; Types: complete custom
Name: "edebug"; Description: "edebug: An Emacs Lisp debugger."; Types: complete custom recommended
#ifdef MULE
Name: "edict"; Description: "edict: MULE: Lisp Interface to EDICT, Kanji Dictionary."; Types: complete custom
#endif
Name: "ediff"; Description: "ediff: Interface over GNU patch."; Types: complete custom recommended
Name: "edit_utils"; Description: "edit-utils: Miscellaneous editor extensions, you probably need this."; Types: complete custom recommended minimal
Name: "edt"; Description: "edt: DEC EDIT/EDT emulation."; Types: complete custom
Name: "efs"; Description: "efs: Treat files on remote systems the same as local files."; Types: complete custom recommended minimal; Flags: fixed
#ifdef MULE
Name: "egg_its"; Description: "egg-its: MULE: Wnn (4.2 and 6) support.  SJ3 support."; Types: complete custom
#endif
Name: "eieio"; Description: "eieio: Enhanced Implementation of Emacs Interpreted Objects"; Types: complete custom recommended
Name: "elib"; Description: "elib: Portable Emacs Lisp utilities library."; Types: complete custom
Name: "emerge"; Description: "emerge: Another interface over GNU patch."; Types: complete custom
Name: "erc"; Description: "erc: ERC is an Emacs InternetRelayChat client."; Types: complete custom
Name: "escreen"; Description: "escreen: Multiple editing sessions withing a single frame (like screen)."; Types: complete custom
Name: "eshell"; Description: "eshell: Command shell implemented entirely in Emacs Lisp"; Types: complete custom
Name: "eterm"; Description: "eterm: Terminal emulation."; Types: complete custom
Name: "eudc"; Description: "eudc: Emacs Unified Directory Client (LDAP, PH)."; Types: complete custom
Name: "footnote"; Description: "footnote: Footnoting in mail message editing modes."; Types: complete custom
Name: "forms"; Description: "forms: Forms editing support (obsolete, use Widget instead)."; Types: complete custom
Name: "fortran_modes"; Description: "fortran-modes: Fortran support."; Types: complete custom
Name: "frame_icon"; Description: "frame-icon: Set up mode-specific icons for each frame under XEmacs"; Types: complete custom
Name: "fsf_compat"; Description: "fsf-compat: FSF Emacs compatibility files."; Types: complete custom recommended
Name: "games"; Description: "games: Tetris, Sokoban, Sudoku, and Snake."; Types: complete custom
Name: "general_docs"; Description: "general-docs: General XEmacs documentation."; Types: complete custom
Name: "gnats"; Description: "gnats: XEmacs bug reports."; Types: complete custom
Name: "gnus"; Description: "gnus: The Gnus Newsreader and Mailreader."; Types: complete custom
Name: "guided_tour"; Description: "guided-tour: Phil Sung's Guided Tour of Emacs."; Types: complete custom
Name: "haskell_mode"; Description: "haskell-mode: Haskell editing support."; Types: complete custom
Name: "hm__html_menus"; Description: "hm--html-menus: HTML editing."; Types: complete custom
Name: "hyperbole"; Description: "hyperbole: Hyperbole: The Everyday Info Manager"; Types: complete custom
Name: "ibuffer"; Description: "ibuffer: Advanced replacement for buffer-menu"; Types: complete custom
Name: "idlwave"; Description: "idlwave: Editing and Shell mode for the Interactive Data Language"; Types: complete custom
Name: "igrep"; Description: "igrep: Enhanced front-end for Grep."; Types: complete custom
Name: "ilisp"; Description: "ilisp: Front-end for Inferior Lisp."; Types: complete custom
Name: "ispell"; Description: "ispell: Spell-checking with GNU ispell."; Types: complete custom
Name: "jde"; Description: "jde: Integrated Development Environment for Java."; Types: complete custom
#ifdef MULE
Name: "latin_euro_standards"; Description: "latin-euro-standards: MULE: Support for the Latin{{7,8,9,10} character sets & coding systems."; Types: complete custom recommended
Name: "latin_unity"; Description: "latin-unity: MULE: find single ISO 8859 character set to encode a buffer."; Types: complete custom recommended
Name: "leim"; Description: "leim: MULE: Quail.  All non-English and non-Japanese language support."; Types: complete custom
Name: "locale"; Description: "locale: MULE: Localized menubars and localized splash screens."; Types: complete custom recommended
Name: "lookup"; Description: "lookup: MULE: Dictionary support"; Types: complete custom recommended
#endif
Name: "mail_lib"; Description: "mail-lib: Fundamental lisp files for providing email support."; Types: complete custom recommended
Name: "mailcrypt"; Description: "mailcrypt: Support for messaging encryption with PGP."; Types: complete custom
Name: "mew"; Description: "mew: Messaging in an Emacs World."; Types: complete custom
Name: "mh_e"; Description: "mh-e: The XEmacs Interface to the MH Mail System."; Types: complete custom
Name: "mine"; Description: "mine: Minehunt Game."; Types: complete custom
Name: "misc_games"; Description: "misc-games: Other amusements and diversions."; Types: complete custom
Name: "mmm_mode"; Description: "mmm-mode: Multiple major modes in a single buffer"; Types: complete custom
#ifdef MULE
Name: "mule_base"; Description: "mule-base: MULE: Basic Mule support."; Types: complete custom recommended
Name: "mule_ucs"; Description: "mule-ucs: MULE: Extended coding systems (including Unicode) for XEmacs."; Types: complete custom
#endif
Name: "net_utils"; Description: "net-utils: Miscellaneous Networking Utilities."; Types: complete custom recommended
Name: "ocaml"; Description: "ocaml: Objective Caml editing support."; Types: complete custom
Name: "oo_browser"; Description: "oo-browser: OO-Browser: The Multi-Language Object-Oriented Code Browser"; Types: complete custom
Name: "os_utils"; Description: "os-utils: Miscellaneous O/S utilities."; Types: complete custom recommended
Name: "pc"; Description: "pc: PC style interface emulation."; Types: complete custom recommended
Name: "pcl_cvs"; Description: "pcl-cvs: CVS frontend."; Types: complete custom
Name: "pcomplete"; Description: "pcomplete: Provides programmatic completion."; Types: complete custom
Name: "perl_modes"; Description: "perl-modes: Perl support."; Types: complete custom recommended
Name: "pgg"; Description: "pgg: Emacs interface to various PGP implementations."; Types: complete custom
Name: "prog_modes"; Description: "prog-modes: Support for various programming languages."; Types: complete custom recommended
Name: "ps_print"; Description: "ps-print: Printing functions and utilities"; Types: complete custom
Name: "psgml"; Description: "psgml: Validated HTML/SGML editing."; Types: complete custom
Name: "psgml_dtds"; Description: "psgml-dtds: Deprecated collection of DTDs for psgml."; Types: complete custom
Name: "python_modes"; Description: "python-modes: Python support."; Types: complete custom
Name: "re_builder"; Description: "re-builder: Interactive development tool for regular expressions."; Types: complete custom
Name: "reftex"; Description: "reftex: Emacs support for LaTeX cross-references, citations.."; Types: complete custom
Name: "riece"; Description: "riece: IRC (Internet Relay Chat) client for Emacs."; Types: complete custom
Name: "rmail"; Description: "rmail: An obsolete Emacs mailer."; Types: complete custom
Name: "ruby_modes"; Description: "ruby-modes: Ruby support."; Types: complete custom
Name: "sasl"; Description: "sasl: Simple Authentication and Security Layer (SASL) library."; Types: complete custom
Name: "scheme"; Description: "scheme: Front-end support for Inferior Scheme."; Types: complete custom
Name: "semantic"; Description: "semantic: Semantic bovinator (Yacc/Lex for XEmacs). Includes Senator."; Types: complete custom recommended
Name: "sgml"; Description: "sgml: SGML/Linuxdoc-SGML editing."; Types: complete custom
Name: "sh_script"; Description: "sh-script: Support for editing shell scripts."; Types: complete custom recommended
Name: "sieve"; Description: "sieve: Manage Sieve email filtering scripts."; Types: complete custom
#ifdef MULE
Name: "skk"; Description: "skk: MULE: Japanese Language Input Method."; Types: complete custom
#endif
Name: "slider"; Description: "slider: User interface tool."; Types: complete custom
Name: "sml_mode"; Description: "sml-mode: SML editing support."; Types: complete custom
Name: "sounds_au"; Description: "sounds-au: XEmacs Sun sound files."; Types: complete custom
Name: "sounds_wav"; Description: "sounds-wav: XEmacs Microsoft sound files."; Types: complete custom recommended
Name: "speedbar"; Description: "speedbar: Provides a separate frame with convenient references."; Types: complete custom recommended
Name: "strokes"; Description: "strokes: Mouse enhancement utility."; Types: complete custom
Name: "supercite"; Description: "supercite: An Emacs citation tool for News & Mail messages."; Types: complete custom
Name: "texinfo"; Description: "texinfo: XEmacs TeXinfo support."; Types: complete custom recommended minimal
Name: "text_modes"; Description: "text-modes: Miscellaneous support for editing text files."; Types: complete custom recommended
Name: "textools"; Description: "textools: Miscellaneous TeX support."; Types: complete custom
Name: "time"; Description: "time: Display time & date on the modeline."; Types: complete custom recommended
Name: "tm"; Description: "tm: Emacs MIME support. Not needed for gnus >= 5.8.0"; Types: complete custom
Name: "tooltalk"; Description: "tooltalk: Support for building with Tooltalk."; Types: complete custom
Name: "tpu"; Description: "tpu: DEC EDIT/TPU support."; Types: complete custom
Name: "tramp"; Description: "tramp: Remote shell-based file editing."; Types: complete custom
Name: "vc"; Description: "vc: Version Control for Free systems."; Types: complete custom
Name: "vc_cc"; Description: "vc-cc: Version Control for ClearCase (UnFree) systems."; Types: complete custom
Name: "vhdl"; Description: "vhdl: Support for VHDL."; Types: complete custom
Name: "view_process"; Description: "view-process: A Unix process browsing tool."; Types: complete custom
Name: "viper"; Description: "viper: VI emulation support."; Types: complete custom
Name: "vm"; Description: "vm: An Emacs mailer."; Types: complete custom
Name: "w3"; Description: "w3: A Web browser."; Types: complete custom
Name: "x_symbol"; Description: "x-symbol: Semi WYSIWYG for LaTeX, HTML, etc, using additional fonts."; Types: complete custom
Name: "xemacs_base"; Description: "xemacs-base: Fundamental XEmacs support, you almost certainly need this."; Types: complete custom recommended minimal; Flags: fixed
Name: "xemacs_devel"; Description: "xemacs-devel: Emacs Lisp developer support."; Types: complete custom recommended
Name: "xetla"; Description: "xetla: (S)XEmacs Frontend to GNU/arch (tla)."; Types: complete custom
Name: "xlib"; Description: "xlib: Emacs interface to X server."; Types: complete custom
Name: "xslide"; Description: "xslide: XSL editing support."; Types: complete custom
Name: "xslt_process"; Description: "xslt-process: XSLT processing support."; Types: complete custom
Name: "xwem"; Description: "xwem: X Emacs Window Manager."; Types: complete custom
Name: "zenirc"; Description: "zenirc: ZENIRC IRC Client."; Types: complete custom
[INI]

[Icons]
Name: "{group}\XEmacs-{#XEmacsVersion}"; Filename: "{app}\XEmacs-{#XEmacsVersion}\i586-pc-win32\xemacs.exe"
Name: "{group}\{cm:UninstallProgram,XEmacs-{#XEmacsVersion}}"; Filename: "{uninstallexe}"
; WorkingDir corresponds to the 'Start in' property.
Name: "{userdesktop}\XEmacs-{#XEmacsVersion}"; Filename: "{app}\XEmacs-{#XEmacsVersion}\i586-pc-win32\xemacs.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\XEmacs-{#XEmacsVersion}"; Filename: "{app}\XEmacs-{#XEmacsVersion}\i586-pc-win32\xemacs.exe"; Tasks: quicklaunchicon

[Run]
; Unpack and delete the package tarballs
Filename: "{app}\xemacs-packages\unpack.cmd"; WorkingDir: "{app}\xemacs-packages"; Flags: runhidden;  AfterInstall: AfterInstall

[UninstallDelete]

[Code]
Const
  SiteStartFooter = ';;; End of XEmacs_Setup addition' + #10;
  SiteStartHeader = #10 + ';;; Lines added by XEmacs_Setup' + #10;
  SubKeyName = 'Software\XEmacs\XEmacs';
  ValueName = 'EMACSPACKAGEPATH';

// Internal Declarations
procedure AfterInstall(); forward;
procedure CleanupPackagePath(); forward;
procedure CreateSiteStart(); forward;
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep); forward;
procedure RemovePackagePathSetting(RootKey: Integer); forward;
procedure RemoveSiteStartModifications(); forward;


procedure AfterInstall();
begin
  CreateSiteStart;
  CleanupPackagePath;
end;

procedure CleanupPackagePath();
begin
  RemovePackagePathSetting(HKEY_CURRENT_USER);
  RemovePackagePathSetting(HKEY_LOCAL_MACHINE);
end;

// Create a site-start.el file to allow easy package downloading
procedure CreateSiteStart();
var
  Contents: String;
  FtpExe: String;
  HeaderRequired, FooterRequired: Boolean;
  InsertPos: Integer;
  InstallBase: String;
  Payload: String;
  SiteStart: String;
begin

  // Here's what we're going to add to lisp\site-start.el:
  //   ;;; Lines added by XEmacs_Setup
  //   (setq package-get-package-index-file-location "C:/Program Files/XEmacs")
  //   (setq package-get-remote '("ftp.xemacs.org" "pub/xemacs/packages"))
  //   (setq efs-ftp-program-name "C:/WINDOWS/system32/ftp.exe")
  //   ;;; End of XEmacs_Setup addition

  SiteStart := ExpandConstant('{app}') + '\site-packages';
  CreateDir(SiteStart);
  SiteStart := SiteStart + '\lisp';
  CreateDir(SiteStart);
  SiteStart := SiteStart + '\site-start.el';

  // Optimize for the most common cases: either site-start.el does not contain anything related to XEmacs setup
  // or site-start.el contains the entire text verbatim.

  // Convert separators from backslash to slash
  InstallBase := ExpandConstant('{app}');
  StringChange(InstallBase, '\', '/');
  FtpExe := ExpandConstant('{syswow64}') + '\ftp.exe';
  StringChange(FtpExe, '\', '/');
  Payload := '(setq package-get-package-index-file-location "' + InstallBase + '")' + #10 +
             '(setq package-get-remote ' + Chr(39) + '("ftp.xemacs.org" "pub/xemacs/packages"))' + #10
             '(setq efs-ftp-program-name "' + FtpExe + '")' + #10;

  // File is non-existant - write header, payload and footer
  if NOT LoadStringFromFile(SiteStart, Contents) then
  begin
    SaveStringToFile(SiteStart, SiteStartHeader + Payload + SiteStartFooter, False);
  end else
  begin

    // Pos > 0 indicates that the full text already appears verbatim in the site-start.el file, so do nothing in that case
    if Pos(SiteStartHeader + Payload + SiteStartFooter, Contents) = 0 then
    begin
      FooterRequired := True;
      HeaderRequired := True;
      InsertPos := Pos(SiteStartHeader, Contents);
      if InsertPos > 0 then
      begin
        HeaderRequired := False
        InsertPos := Pos(SiteStartFooter, Contents);
        if InsertPos > 0 then
        begin
          FooterRequired := False;
        end else
        begin
          InsertPos := Length(Contents);
        end;
      end;

      if InsertPos = 0 then InsertPos := 1;

      if HeaderRequired then
      begin
        Insert(SiteStartHeader, Contents, InsertPos);
        InsertPos := InsertPos + Length(SiteStartHeader);
      end;
      Insert(Payload, Contents, InsertPos);
      InsertPos := InsertPos + Length(Payload);

      if FooterRequired then
        Insert(SiteStartFooter, Contents, InsertPos);

      SaveStringToFile(SiteStart, Contents, False);
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  case CurUninstallStep of
  usUninstall:
    begin
      RemoveSiteStartModifications;
    end;
  end;
end;

procedure RemovePackagePathSetting(RootKey: Integer);
var
  RootKeyName: String;
  Value: String;
begin
  RootKeyName := 'Unknown Root';
  case RootKey of
    HKEY_CURRENT_USER:
      RootKeyName := 'HKEY_CURRENT_USER';
    HKEY_LOCAL_MACHINE:
      RootKeyName := 'HKEY_LOCAL_MACHINE';
  end;
  // Check to see if the key exists in the specified registry root
  if RegQueryStringValue(RootKey, SubKeyName, ValueName, Value) then
  begin
    // Allow the user to delete it
    if MsgBox('Do you want to delete the registry key ' + RootKeyName + '\' + SubKeyName + '\' + ValueName + '?' #13 'Currently this key has the value "' + Value + '".' #13#13 'If you do not delete this registry key, then the packages installed from this setup kit will not be found when XEmacs runs.' #13, mbConfirmation, MB_YESNO) = IDYES then
    begin
      RegDeleteValue(RootKey, SubKeyName, ValueName);
    end;
  end;
end;


procedure RemoveSiteStartModifications();
var
  Contents: String;
  Footer, Header: Integer;
  SiteStart: String;
begin
  SiteStart := ExpandConstant('{app}') + '\site-packages\lisp\site-start.el';
  if LoadStringFromFile(SiteStart, Contents) then
  begin
    Header := Pos(SiteStartHeader, Contents);
    if Header > 0 then
    begin
      Footer := Pos(SiteStartFooter, Contents);
      if (Footer > 0) AND (Footer > Header) then
      begin
        Footer := Footer + Length(SiteStartFooter);
        Delete(Contents, Header, Footer-Header);
        SaveStringToFile(SiteStart, Contents, False);
      end;
    end;
  end;
end;
