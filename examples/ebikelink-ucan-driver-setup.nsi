; This examples demonstrates how libwdi can be used in an installer script
; to automatically install USB drivers along with your application.
;
; Requirements: Nullsoft Scriptable Install System (http://nsis.sourceforge.net/)
;
; To use this script, do the following:
; - configure libwdi (see config.h)
; - compile ebikelink-ucan-driver-setup.exe
; - customize this script (application strings, ebikelink-ucan-driver-setup.exe parameters, etc.)
; - open this script with Nullsoft Scriptable Install System
; - compile and run

; Use modern interface
  !include MUI2.nsh
  !define MUI_FINISHPAGE_NOAUTOCLOSE

; General
  Name                  "libwdi-example"
  OutFile               "libwdi-example-setup.exe"
  InstallDir            $PROGRAMFILES\libwdi-example
  InstallDirRegKey      HKLM "Software\libwdi-example" "Install_Dir"
  ShowInstDetails       show
  RequestExecutionLevel admin

; Pages
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;Languages
  !insertmacro MUI_LANGUAGE "English"

; Installer
Section "libwdi-example" SecDummy
  SetOutPath $INSTDIR
  File "ebikelink-ucan-driver-setup.exe"
  WriteRegStr HKLM SOFTWARE\libwdi-example "Install_Dir" "$INSTDIR"
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\libwdi-example" "DisplayName" "libwdi example"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\libwdi-example" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\libwdi-example" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\libwdi-example" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
SectionEnd

; Call ebikelink-ucan-driver-setup
;
; -c, --cert <certname>      install certificate <certname> from the
;                            embedded user files as a trusted publisher
;     --stealth-cert         installs certificate above without prompting
; -s, --silent               silent mode
; -b, --progressbar=[HWND]   display a progress bar during install
;                            an optional HWND can be specified
; -o, --timeout              set timeout (in ms) to wait for any
;                            pending installations
; -l, --log                  set log level (0=debug, 4=none)
; -h, --help                 display usage
Section "ebikelink-ucan-driver-setup"
  DetailPrint "Running $INSTDIR\ebikelink-ucan-driver-setup.exe"
  nsExec::ExecToLog '"$INSTDIR\ebikelink-ucan-driver-setup.exe" --progressbar=$HWNDPARENT --timeout 120000'
SectionEnd

; Uninstaller
Section "Uninstall"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\libwdi-example"
  DeleteRegKey HKLM SOFTWARE\libwdi-example
  Delete $INSTDIR\ebikelink-ucan-driver-setup.exe
  Delete $INSTDIR\uninstall.exe
  RMDir "$SMPROGRAMS\libwdi-example"
  RMDir "$INSTDIR"
SectionEnd
