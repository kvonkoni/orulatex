!define APPNAME "OrulaTex"
!define COMPANYNAME "Kier von Konigslow"
!define DESCRIPTION "LaTeX tools that streamline course content creation for teachers"
# These three must be integers
!define VERSIONMAJOR 0
!define VERSIONMINOR 1
!define VERSIONBUILD 0
# These will be displayed by the "Click here for support information" link in "Add/Remove Programs"
# It is possible to use "mailto:" links in here to open the email client
!define HELPURL "http://kvonkonigslow.com" # "Support Information" link
!define UPDATEURL "http://kvonkonigslow.com" # "Product Updates" link
!define ABOUTURL "http://kvonkonigslow.com" # "Publisher" link
# This is the size (in kB) of all the files copied into "Program Files"
!define INSTALLSIZE 1800

RequestExecutionLevel admin

# Setting basic information
Name ${APPNAME}
OutFile ${APPNAME}-win-install-v${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}.exe
SetOverwrite ifnewer

# Setting default installation directory
InstallDir "$PROGRAMFILES\${APPNAME}"

# Show details
ShowInstDetails show
ShowUninstDetails show

# Creating directory variables
Var MIKTEXDIR
Var USERDIR
Var CUSTPACDIR

!include FontReg.nsh
#!include FontRegAdv.nsh
!include FontName.nsh
!include x64.nsh
!include MUI2.nsh

#--------------------------------
# MikTex macros and functions.

# Setting up the MikTex database
Function pickRepository
        DetailPrint "Selecting appropriate MikTex 2.9 repository-url."
        ${If} ${RunningX64}
                nsExec::ExecToStack '"$MIKTEXDIR\miktex\bin\x64\mpm" --admin --pick-repository-url'
        ${Else}
                nsExec::ExecToStack '"$MIKTEXDIR\miktex\bin\mpm" --admin --pick-repository-url'
        ${EndIf}
FunctionEnd

#Downloading the necessary packages from the MikTex database
Function requirePackages
        DetailPrint "Setting the package manager to install-on-the-fly without user input..."
        ${If} ${RunningX64}
                nsExec::ExecToStack '"$MIKTEXDIR\miktex\bin\x64\initexmf" --admin --set-config-value [MPM]AutoInstall=1'
        ${Else}
                nsExec::ExecToStack '"$MIKTEXDIR\miktex\bin\initexmf" --admin --set-config-value [MPM]AutoInstall=1'
        ${EndIf}
        DetailPrint "...done."
FunctionEnd

# Adding the CUSTPACDIR folder to the MikTex root directories list
Function registerCustPacDirAsRoot
        DetailPrint "Adding $CUSTPACDIR to the MikTex root directories list..."
        ${If} ${RunningX64}
                nsExec::ExecToStack '"$MIKTEXDIR\miktex\bin\x64\initexmf" --admin --register-root="$CUSTPACDIR"'
        ${Else}
                nsExec::ExecToStack '"$MIKTEXDIR\miktex\bin\initexmf" --admin --register-root="$CUSTPACDIR"'
        ${EndIf}
        DetailPrint "...done."
FunctionEnd

# Removing the CUSTPACDIR folder from the MikTex root directories list
Function un.registerCustPacDirAsRoot
        DetailPrint "Removing $CUSTPACDIR from the MikTex root directories list..."
        ${If} ${RunningX64}
                nsExec::ExecToStack '"$MIKTEXDIR\miktex\bin\x64\initexmf" --admin --unregister-root="$CUSTPACDIR"'
        ${Else}
                nsExec::ExecToStack '"$MIKTEXDIR\miktex\bin\initexmf" --admin --unregister-root="$CUSTPACDIR"'
        ${EndIf}
        DetailPrint "...done."
FunctionEnd

# Refreshing the MikTex database
!macro FNDP un
       Function ${un}updateFNDB
                DetailPrint "Refreshing MikTex 2.9 File Name Database (FNDB)..."
                ${If} ${RunningX64}
                        nsExec::ExecToStack '"$MIKTEXDIR\miktex\bin\x64\initexmf" --admin --update-fndb'
                ${Else}
                       nsExec::ExecToStack '"$MIKTEXDIR\miktex\bin\initexmf" --admin --update-fndb'
                ${EndIf}
                DetailPrint "...FNDB updated"
        FunctionEnd
!macroend
!insertmacro FNDP ""
!insertmacro FNDP "un."

# Locating the MikTex directory
!macro SMTD un
       Function ${un}setMikTexDir
                ${If} ${RunningX64}
                      DetailPrint "64-bit Windows"
                      SetRegView 64
                ${Else}
                       DetailPrint "32-bit Windows"
                       SetRegView 32
                ${EndIf}
                # Check to see if already installed
                ReadRegStr $MIKTEXDIR HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\MiKTeX 2.9" "InstallLocation"
                IfFileExists $MIKTEXDIR found notfound
                notfound:
                         StrCpy $MIKTEXDIR "$PROGRAMFILES"
                         MessageBox MB_OK "Miktex 2.9 installation not found!"
                found:
        FunctionEnd
!macroend
!insertmacro SMTD ""
!insertmacro SMTD "un."

#--------------------------------
# Interface Settings

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP ".\images\orulatex_header_right.bmp"
!define MUI_HEADERIMAGE_RIGHT
!define MUI_ABORTWARNING

#--------------------------------
# General

!define MUI_ICON ".\images\orulatex_icon.ico"
!define MUI_UNICON ".\images\orulatex_icon.ico"
!define MUI_PAGE_HEADER_TEXT "The ${APPNAME} toolbox"
!define MUI_PAGE_HEADER_SUBTEXT "Install the ${APPNAME} tools."

#--------------------------------
# Welcome Page
!define MUI_WELCOMEFINISHPAGE_BITMAP ".\images\orulatex_welcome.bmp"
!define MUI_WELCOMEPAGE_TITLE "The ${APPNAME} Installation"
!define MUI_WELCOMEPAGE_TEXT "Welcome to the ${APPNAME} installation program. This application will guide you through the installation of the ${APPNAME} tools."
!insertmacro MUI_PAGE_WELCOME

#--------------------------------
# Licence Page

!define MUI_LICENSEPAGE_TEXT_TOP "The ${APPNAME} License"
!insertmacro MUI_PAGE_LICENSE ".\LICENSE"

#--------------------------------
# First Directory Page

!insertmacro MUI_PAGE_COMPONENTS

#--------------------------------
# Program directory Page

!define MUI_PAGE_HEADER_SUBTEXT "Choose a location to install the ${APPNAME} application"
!define MUI_DIRECTORYPAGE_TEXT_TOP "The installer will install the ${APPNAME} application files in the following folder. To install in a different folder, click Browse and select another folder. Click Next to continue."
!define MUI_DIRECTORYPAGE_VARIABLE $INSTDIR
!insertmacro MUI_PAGE_DIRECTORY
#--------------------------------

#--------------------------------
# User directory Page

!define MUI_PAGE_HEADER_SUBTEXT "Choose a location to install the user files"
!define MUI_DIRECTORYPAGE_TEXT_TOP "The installer will install the user files in the following folder. To install in a different folder, click Browse and select another folder. Click Next to continue."
!define MUI_DIRECTORYPAGE_VARIABLE $USERDIR
!insertmacro MUI_PAGE_DIRECTORY
#--------------------------------

!insertmacro MUI_PAGE_INSTFILES

#--------------------------------
# Finish Page

!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_TITLE "Installation Complete"
!define MUI_FINISHPAGE_TEXT 'Installation of the ${APPNAME} toolbox is complete. Click "Finish" to close the installer.'
!define MUI_FINISHPAGE_BUTTON "Finish"
!insertmacro MUI_PAGE_FINISH

#--------------------------------
# Uninstall Welcome Page

!define MUI_UNWELCOMEFINISHPAGE_BITMAP ".\images\orulatex_welcome.bmp"
!insertmacro MUI_UNPAGE_WELCOME

#--------------------------------
# Uninstall Confirm Page

!insertmacro MUI_UNPAGE_CONFIRM

#--------------------------------
# Uninstall Component Page

!insertmacro MUI_UNPAGE_COMPONENTS

#--------------------------------

!insertmacro MUI_UNPAGE_INSTFILES

#--------------------------------
# Uninstall Finish Page

!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!insertmacro MUI_UNPAGE_FINISH

#--------------------------------
# Languages

!insertmacro MUI_LANGUAGE "English"

Function .oninit

         Call setMikTexDir
         StrCpy $USERDIR "$DOCUMENTS\${APPNAME} Files"
         SetShellVarContext all

FunctionEnd

Section "Core Files" corefiles

        #--------------------------------
	# Setting up the Root of the Installation Directory
	
	# Creating the installation directory and setting that to be the current output path
        setOutPath $INSTDIR
	
	# Uninstaller - See function un.onInit and section "uninstall" for configuration
        writeUninstaller "$INSTDIR\uninstall_orulatex.exe"
        
	# Installing the icon
	file ".\images\orulatex_icon.ico"
	# Installing the root directory binary
	file ".\bin\add_current_to_root.bat"
	# Installing the repository chooser binary
	file ".\bin\pick_repository.bat"
	# Installing the repository manager autoinstall binary
	file ".\bin\set_manager_to_autoinstall.bat"
	# Installing the FNDB updater binary
	file ".\bin\update_fndb.bat"
	
	# Adding the package directory to the MikTex root directories list
	StrCpy $CUSTPACDIR $INSTDIR
	Call registerCustPacDirAsRoot
        
        #--------------------------------
        # Setting up the Compiler sub directory in the Installation Directory
        
	# Creating the compiler sub-directory and setting that to be the current output path
        setOutPath $INSTDIR\compiler
        
	file ".\compiler\orulapath.compile-win-lualatex.bat"
	file ".\compiler\orulatest.compile-win.bat"
	file ".\compiler\orulatest.compile-win-xelatex.bat"
	file ".\compiler\orulatest.compile-win-lualatex.bat"
	file ".\compiler\orulawork.compile-win.bat"
	file ".\compiler\orulawork.compile-win-xelatex.bat"
	file ".\compiler\orulawork.compile-win-lualatex.bat"
	
	#--------------------------------
	# Setting up the Package sub directory in the Installation Directory
	
	# Creating the tex package sub-directory and setting that to be the current output path
        setOutPath $INSTDIR\tex\latex\orulatex
        
	# Installing the OrulaTex package files
	file ".\package\tex\latex\orulatex\orulatest.cls"
	file ".\package\tex\latex\orulatex\orulatest_header.pdf"
	file ".\package\tex\latex\orulatex\orulatest_header_col.pdf"
	file ".\package\tex\latex\orulatex\orulawork.cls"
	file ".\package\tex\latex\orulatex\orulawork_header.pdf"
	file ".\package\tex\latex\orulatex\orulawork_header_col.pdf"
	file ".\package\tex\latex\orulatex\orulapath.cls"
	
	#--------------------------------
	# Setting up the User Directory
	
	# Creating the user directory and setting that to be the current output path
        setOutPath $USERDIR
	
	#--------------------------------
	# Setting up the Custom sub directory in the User Directory
	
	# Creating the custom tex package sub-directory and setting that to be the current output path
	setOutPath $USERDIR\custom

	# Installing the instructions for the custom tex package folder
	file ".\custom\INSTRUCTIONS.txt"
        # Installing the root directory binary for the custom tex package folder
	file ".\bin\add_current_to_root.bat"
	
	# Adding directories so that the custom directory has the required structure
        setOutPath $USERDIR\custom\tex\latex\orulatex
	
	# Adding the Custom User Files directory to the MikTex root directories list
	StrCpy $CUSTPACDIR "$USERDIR\custom"
	Call registerCustPacDirAsRoot
	
	#--------------------------------
	# Updating MikTex settings
	
	# Choosing an appropriate repository for the location
        Call pickRepository
        # Setting the package manager to autoinstall
        Call requirePackages
	# Updating the MikTeX FNDB
        Call updateFNDB
        
        #--------------------------------
	# Installing Start Menu items
	
	createDirectory "$SMPROGRAMS\${APPNAME}"
	createShortCut "$SMPROGRAMS\${APPNAME}\Uninstall ${APPNAME}.lnk" "$INSTDIR\uninstall_orulatex.exe"
	
	#--------------------------------
	# Registry information for add/remove programs

	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME} - ${DESCRIPTION}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" '"$INSTDIR\uninstall_orulatex.exe"'
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayIcon" "$\"$INSTDIR\orulatex_icon.ico$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "Publisher" "$\"${COMPANYNAME}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "HelpLink" "$\"${HELPURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "URLUpdateInfo" "$\"${UPDATEURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "URLInfoAbout" "$\"${ABOUTURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayVersion" "$\"${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}$\""
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMinor" ${VERSIONMINOR}
	# There is no option for modifying or repairing the install
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoRepair" 1
	# Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "EstimatedSize" ${INSTALLSIZE}
	
	#--------------------------------
	# Setting compile command for .tex file context menu

	WriteRegStr HKCR "SystemFileAssociations\.tex\shell\orulatex-test" "" "Compile as ${APPNAME} Test"
	WriteRegStr HKCR "SystemFileAssociations\.tex\shell\orulatex-test\command" "" '"$INSTDIR\compiler\orulatest.compile-win-lualatex.bat" "%1"'
	WriteRegStr HKCR "SystemFileAssociations\.tex\shell\orulatex-assignment" "" "Compile as ${APPNAME} Assignment"
	WriteRegStr HKCR "SystemFileAssociations\.tex\shell\orulatex-assignment\command" "" '"$INSTDIR\compiler\orulawork.compile-win-lualatex.bat" "%1"'
	#WriteRegStr HKCR "SystemFileAssociations\.tex\shell\orulatex-path" "" "Compile as ${APPNAME} Path"
	#WriteRegStr HKCR "SystemFileAssociations\.tex\shell\orulatex-path\command" "" '"$INSTDIR\compiler\orulapath.compile-win-lualatex.bat" "%1"'

	#--------------------------------

SectionEnd

Section "Third Party Packages" thirdparty

        #--------------------------------
        # Setting up the Package sub directory in the MikTeX Directory
        
        # Creating the installation directory and setting that to be the current output path
	setOutPath $MIKTEXDIR
	
	# Installing third-party packages
	file /r "doc"
	file /r "tex"
	
	#--------------------------------
	# Updating MikTex settings
	
	# Updating the MikTeX FNDB
        Call updateFNDB
        
        #--------------------------------
        
SectionEnd

Section "Examples" examples

	#--------------------------------
	# Creating the custom package directory and setting that to be the current output path

        setOutPath $USERDIR\custom\tex\latex\orulatex
        
        # Installing the custom files
        file ".\custom\tex\latex\orulatex\custom_coverpage.tex"
	file ".\custom\tex\latex\orulatex\orulatest_commands.tex"
	
	#--------------------------------
	# Updating MikTex settings
	
	# Updating the MikTeX FNDB
        Call updateFNDB
	
	#--------------------------------
	# Creating the examples directory and setting that to be the current output path

        setOutPath $USERDIR\examples
	
	# Installing the examples to the user directory
	file ".\examples\equation-example-test1.tex"
	file ".\examples\example-homework1.tex"
	file ".\examples\example-homework2.tex"
	file ".\examples\example-homework3.tex"
	file ".\examples\example-test1.tex"
	
	#--------------------------------
	
SectionEnd

Section "Fonts" fonts

        #--------------------------------
	# Installing custom fonts

        StrCpy $FONT_DIR $FONTS
	!insertmacro InstallTTFFont '.\specialfonts\OpenDyslexic3-Bold.ttf'
	!insertmacro InstallTTFFont '.\specialfonts\OpenDyslexic3-Regular.ttf'
	#!insertmacro InstallTTFFont '.\specialfonts\OpenDyslexicAlta-Bold.ttf'
	#!insertmacro InstallTTFFont '.\specialfonts\OpenDyslexicAlta-BoldItalic.ttf'
	#!insertmacro InstallTTFFont '.\specialfonts\OpenDyslexicAlta-Italic.ttf'
	#!insertmacro InstallTTFFont '.\specialfonts\OpenDyslexicAlta-Regular.ttf'
	#!insertmacro InstallTTFFont '.\specialfonts\OpenDyslexic-Bold.ttf'
	#!insertmacro InstallTTFFont '.\specialfonts\OpenDyslexic-BoldItalic.ttf'
	#!insertmacro InstallTTFFont '.\specialfonts\OpenDyslexic-Italic.ttf'
	#!insertmacro InstallTTFFont '.\specialfonts\OpenDyslexicMono-Regular.ttf'
	#!insertmacro InstallTTFFont '.\specialfonts\OpenDyslexic-Regular.ttf'
	#!insertmacro InstallFONFont '.\specialfonts\OpenDyslexicAlta-Bold.otf' 'OpenDyslexicAlta-Bold'
	#!insertmacro InstallFONFont '.\specialfonts\OpenDyslexicAlta-BoldItalic.otf' 'OpenDyslexicAlta-BoldItalic'
	#!insertmacro InstallFONFont '.\specialfonts\OpenDyslexicAlta-Italic.otf' 'OpenDyslexicAlta-Italic'
	#!insertmacro InstallFONFont '.\specialfonts\OpenDyslexicAlta-Regular.otf' 'OpenDyslexicAlta-Regular'
	SendMessage ${HWND_BROADCAST} ${WM_FONTCHANGE} 0 0 /TIMEOUT=5000
	
	#--------------------------------
	
SectionEnd

LangString DESC_corefiles ${LANG_ENGLISH} "Select this option to install the core ${APPNAME} files."
LangString DESC_thirdparty ${LANG_ENGLISH} "Select this option to install optional third party packages."
LangString DESC_examples ${LANG_ENGLISH} "Select this option to install ${APPNAME} examples."
LangString DESC_fonts ${LANG_ENGLISH} "Select this option to install custom fonts."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${corefiles} $(DESC_corefiles)
	!insertmacro MUI_DESCRIPTION_TEXT ${thirdparty} $(DESC_thirdparty)
	!insertmacro MUI_DESCRIPTION_TEXT ${examples} $(DESC_examples)
	!insertmacro MUI_DESCRIPTION_TEXT ${fonts} $(DESC_fonts)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

function un.oninit

         Call un.setMikTexDir
         SetShellVarContext all

functionEnd

section "un.Remove Fonts" unfonts

        #--------------------------------
	# Installing custom fonts
	
	StrCpy $FONT_DIR $FONTS
	#!insertmacro RemoveTTF 'OpenDyslexic3-Bold.ttf'
	#!insertmacro RemoveTTF 'OpenDyslexic3-Regular.ttf'
	#!insertmacro RemoveTTF 'OpenDyslexicAlta-Bold.ttf'
	#!insertmacro RemoveTTF 'OpenDyslexicAlta-BoldItalic.ttf'
	#!insertmacro RemoveTTF 'OpenDyslexicAlta-Italic.ttf'
	#!insertmacro RemoveTTF 'OpenDyslexicAlta-Regular.ttf'
	#!insertmacro RemoveTTF 'OpenDyslexic-Bold.ttf'
	#!insertmacro RemoveTTF 'OpenDyslexic-BoldItalic.ttf'
	#!insertmacro RemoveTTF 'OpenDyslexic-Italic.ttf'
	#!insertmacro RemoveTTF 'OpenDyslexicMono-Regular.ttf'
	#!insertmacro RemoveTTF 'OpenDyslexic-Regular.ttf'
	#!insertmacro RemoveFON 'OpenDyslexicAlta-Bold.otf' 'OpenDyslexicAlta-Bold'
	#!insertmacro RemoveFON 'OpenDyslexicAlta-BoldItalic.otf' 'OpenDyslexicAlta-BoldItalic'
	#!insertmacro RemoveFON 'OpenDyslexicAlta-Italic.otf' 'OpenDyslexicAlta-Italic'
	#!insertmacro RemoveFON 'OpenDyslexicAlta-Regular.otf' 'OpenDyslexicAlta-Regular'
	#SendMessage ${HWND_BROADCAST} ${WM_FONTCHANGE} 0 0 /TIMEOUT=5000
	
	#--------------------------------
	
sectionEnd

section "un.Remove Core Files" uncorefiles

        #--------------------------------
        # Removing Start Menu items

	# Remove Start Menu launcher
	delete "$SMPROGRAMS\${APPNAME}\Uninstall ${APPNAME}.lnk"
	rmDir "$SMPROGRAMS\${APPNAME}"
	
	#--------------------------------
        # Removing package files
        
        # Deleting package files
	delete $INSTDIR\tex\latex\orulatex\orulatest.cls
	delete $INSTDIR\tex\latex\orulatex\orulatest_header.pdf
	delete $INSTDIR\tex\latex\orulatex\orulatest_header_col.pdf
	delete $INSTDIR\tex\latex\orulatex\orulawork.cls
	delete $INSTDIR\tex\latex\orulatex\orulawork_header.pdf
	delete $INSTDIR\tex\latex\orulatex\orulawork_header_col.pdf
	delete $INSTDIR\tex\latex\orulatex\orulapath.cls
	
	# Trying to remove the package directory
	rmDir $INSTDIR\tex\latex\orulatex
	rmDir $INSTDIR\tex\latex
	rmDir $INSTDIR\tex
	
	#--------------------------------
        # Removing compiler
	
	# Deleting compiler files
	delete "$INSTDIR\compiler\orulapath.compile-win-lualatex.bat"
	delete "$INSTDIR\compiler\orulatest.compile-win.bat"
	delete "$INSTDIR\compiler\orulatest.compile-win-xelatex.bat"
	delete "$INSTDIR\compiler\orulatest.compile-win-lualatex.bat"
	delete "$INSTDIR\compiler\orulawork.compile-win.bat"
	delete "$INSTDIR\compiler\orulawork.compile-win-xelatex.bat"
	delete "$INSTDIR\compiler\orulawork.compile-win-lualatex.bat"
	delete "$INSTDIR\compiler\orulatex_icon.ico"
	
	# Trying to remove the compiler directory
	rmDir $INSTDIR\compiler
	
	#--------------------------------
        # Removing program directory files
	
	# Deleting binaries
	delete $INSTDIR\orulatex_icon.ico
	delete $INSTDIR\add_current_to_root.bat
	delete $INSTDIR\pick_repository.bat
	delete $INSTDIR\set_manager_to_autoinstall.bat
	delete $INSTDIR\update_fndb.bat
	
	#--------------------------------
	# Updating MikTex settings
	
	# Removing the install directory from the MikTeX roots
	StrCpy $CUSTPACDIR $INSTDIR
	Call un.registerCustPacDirAsRoot
	
        # Updating the MikTeX FNDB
	Call un.updateFNDB
	
	#--------------------------------
	# Removing the registry settings

	# Remove uninstaller information from the registry
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
	
	# Remove compile command for .tex file context menu
	#DeleteRegKey HKCR "SystemFileAssociations\.tex\shell\orulatex-path"
	DeleteRegKey HKCR "SystemFileAssociations\.tex\shell\orulatex-test"
	DeleteRegKey HKCR "SystemFileAssociations\.tex\shell\orulatex-assignment"
	
	#--------------------------------
	# Deleting the uninstaller

	# Always delete uninstaller as the last action
	delete $INSTDIR\uninstall_orulatex.exe
	
	#--------------------------------
	# Final step, trying to remove the program directory
	
	rmDir $INSTDIR
	
	#--------------------------------
	
sectionEnd

#LangString DESC_uncorefiles ${LANG_ENGLISH} "Select this option to uninstall the core ${APPNAME} files."
#LangString DESC_unfonts ${LANG_ENGLISH} "Select this option to uninstall the custom fonts."

#!insertmacro MUI_UNFUNCTION_DESCRIPTION_BEGIN
#	!insertmacro MUI_DESCRIPTION_TEXT ${uncorefiles} $(DESC_uncorefiles)
#	!insertmacro MUI_DESCRIPTION_TEXT ${unfonts} $(DESC_unfonts)
#!insertmacro MUI_UNFUNCTION_DESCRIPTION_END