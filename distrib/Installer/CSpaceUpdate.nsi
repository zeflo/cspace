!define CSPACE_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\CSpace.exe"

!include CSpaceUpdate-BuildNumber.nsh

OutFile CSpaceUpdate${BUILD_NUMBER}.exe
XPStyle on
Name "CSpace"
InstallDir "$PROGRAMFILES\CSpace"
InstallDirRegKey HKLM "${CSPACE_DIR_REGKEY}" ""
Icon "..\..\cspace\main\ui\Images\cspace.ico"
UninstallIcon "..\..\cspace\main\ui\Images\cspace.ico"

Page instfiles
UninstPage uninstConfirm
UninstPage instfiles

!include InstCode.nsh

!insertmacro CheckCSpace ""
!insertmacro CheckCSpace "un."
!insertmacro KillApplets ""
!insertmacro KillApplets "un."

Function .onInit
    Call CheckCSpace
    Call KillApplets
FunctionEnd

Section "Install"
    SetAutoClose true
    SetOutPath "$INSTDIR"
    RMDir /r "$INSTDIR\Services"
    RMDir /r "$INSTDIR\ContactActions"
    File /r /x *.dll /x *.pyd /x w9xpopen.exe /x CSpaceVNCViewer.exe /x CSpaceWinVNC.exe "..\dist\*.*"
    File "BuildNumber.txt"
    CreateDirectory "$SMPROGRAMS\CSpace"
    CreateShortCut "$SMPROGRAMS\CSpace\CSpace.lnk" "$INSTDIR\CSpace.exe"
    CreateShortCut "$SMPROGRAMS\CSpace\Uninstall.lnk" "$INSTDIR\uninst.exe"
    WriteUninstaller "$INSTDIR\uninst.exe"
    WriteRegStr HKLM "${CSPACE_DIR_REGKEY}" "" "$INSTDIR\CSpace.exe"
    Delete "$INSTDIR\ncrypt.pyd"
SectionEnd

Function .onInstSuccess
    Exec "$INSTDIR\CSpace.exe"
FunctionEnd

Function un.onInit
    Call un.CheckCSpace
    Call un.KillApplets
FunctionEnd

Section "Uninstall"
    Delete "$DESKTOP\CSpace.lnk"
    RMDir /r "$SMPROGRAMS\CSpace"
    RMDir /r "$INSTDIR"
    DeleteRegKey HKLM "${CSPACE_DIR_REGKEY}"
SectionEnd
