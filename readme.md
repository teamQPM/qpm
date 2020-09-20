
# Welcome to QPM

QPM (QAC based Project Manager) is the Open Source continuation of the QAC
application developed by CarozoDeQuilmes (inspired on the MPM utility
designed by Roberto López, the creator of Harbour MiniGUI library).

QPM is a project manager for software applications
based on Harbour and xHarbour languages and its contributions, specialy the
graphic support libraries for Windows: Harbour MiniGUI, Harbour MiniGUI Extend
and Object Oriented Harbour GUI (OOHG), and Borland, Pelles and MinGW C/C++
compilers.

It assists programmers in the processes of program writing, compilation, debugging 
and linking by offering interactive and batch tools to:

+ Access external utilities to edit fonts, forms, headers and DBF files.
+ Keep and recover previous versions of modified files (hot recovery function).
+ View and search source files, forms, headers, and DBF files.
+ Incrementally compile GUI, console, and mixed-type programs.
+ View error files resulting from compilation and execution.
+ View .PPO files (preprocessor output).
+ Execute post-build processes.
+ Create CHM and HTML help files.
+ Create static libraries and DLL access interfaces.
+ Show the names of the functions included in static and dynamic libraries.
+ Compress EXE files with the UPX utility.

## How to inform on a bug, make a request or ask for help?

See https://github.com/teamQPM/qpm/issues/new/choose

## Contributing to QPM

#### With code:
1. Fork this repository.
2. Create a branch: `git checkout -b <branch_name>`.
3. Make your changes and commit them: `git commit -m '<commit_message>'`
4. Push to the original branch: `git push origin <project_name>/<location>`
5. [Create a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).
#### With money:
[![Donate](https://img.shields.io/badge/Donate-Now-ff4500.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=VYXQYCKWXLWAG&currency_code=USD&source=url "Donate Now")

## Site structure

Folder|Content
------|-------
QPM|Contain all the various make files, the ChangeLog, the main source files and the utilities.
doc|Documentation and white-papers.
FuentesComunes|Miscelaneous functions.
FuentesComunes\Recursos|Miscelaneous images used by QPM.
HelpQPM|Miscelaneous images and other files used for building QPM's help.
htmlhelp|Folder used for building QPM's help.
OldDistros|Installers for older versions.
Resource|Miscelaneous images used by QPM.
RTFtoHTML|VB project to convert encoded Rich Text to HTML format.
Samples|Miscelaneous samples.
Samples\Agenda|How to build a GUI application.
Samples\ConsoleMode|How to build a CUI application.
Samples\Contactos|How to build a GUI application.
Samples\MakeLIB|How to build a library.
Samples\MergeConsoleModeWithWindowsMode|How to build a mixed CUI/GUI application.
Samples\SHG_SimpleHelpGenerator|How to build and use a CHM help file.
Samples\TsBrowse_(Extended_1_5_b54)|How to build an application based on TSBrowse class from MiniGUI Extended.
users-list|Messages from the old user group on Yahoo.

## How to build QPM from scratch

1. Download the last QPM installer from https://github.com/teamQPM/qpm/releases and install to folder C:\QPMdev.
2. Install GitHub Desktop or another Git client and checkout the QPM repository.
3. An alternative is to download a zip with all the files from the aforementioned site using the green button labeled "Code".
4. Install Harbour MiniGUI Extended Edition from https://github.com/teamQPM/hmgext or, if you want to try a newer version, from https://sourceforge.net/projects/hmgs-minigui/
5. Install Borland C++ Compiler version 5.8.2 from:
   * http://www.xharbour.org/index.asp?page=download/windows/required_win
   * http://www.whosaway.com/
6. Start QPM, go to Settings/Global Options menu, select the tab labeled "Extended 1.x with Borland C", and configure all its fields.
7. If you didn´t installed at folder C:\QPMdev, you must modify, build and execute ./HelpQPM/SHG_Change.prg to change the path to
the files used by QPM to build QPM.CHM help file. The building tools do not support relative paths so a full default path must be
specified (C:\QPMdev). If you fail to do this, QPM will complain that it can't found the images and zips files.
8. Launch CompileAll.bat to build all the binaries.


## How to build a new release

1. In QPM_version.ch set the values of this defines:

         #define QPM_VERSION_NUMBER_MAYOR   '05'
         #define QPM_VERSION_NUMBER_MINOR   '05'
         #define QPM_VERSION_NUMBER_BUILD   '00'

2. Open your working version of QPM and load ./QPM_AutoProject.qpm

3. If AUTOINC option is set to ON then change version, release and
    build to one less than the release to build.
    E.G. if you want to build 5.01.10, set QPM to 5.01.09
    if you want to build 5.01.00, set QPM to 5.00.9999
    If AUTOINC option is set to OFF then change version, release and
    build to the desired values.

4. Build the project.

5. Install INNO Setup Compiler from http://www.jrsoftware.org/

6. Open QPM.ISS and
   1. Check if all the required files are included (look for 'vExeList' at QPM_Functions.prg).
   2. Check if all the samples are incluided (look into Samples folder).
   3. Set "AppVerName" and "OutputBaseFilename" variables to reflect the new version number.
   4. Set "AppPublisher" variable to your name.
   5. Update "AppCopyright" to the current year.
   6. Hit "compile" button.

7. Upload the installer to GitHub's release page.

## How to update the Internet Help site

1. QPM's Internet Help site is located at https://qpm.sourceforge.io/ and can be accessed from "Browse help file" link at https://teamqpm.github.io/
2. If you don't have one, download and install a FTP client.
    FileZilla is a fine choice: https://filezilla-project.org/
3. Open QPM_AutoProjectOnlyHelp.qpm and:
   1. Select SHG tab page and make all the necessary changes.
   2. Check "Add HTML Output" option.
   3. Click "Generate" button.
   4. If prompted save all unsaved topics.
   5. When prompted select folder "htmlhelp" (this folder will hold all the files generated by the build process).
   6. Wait until the process ends and close the project.
   7. Note that the html files are generated from rtf text by us_r2h.exe utility.
4. Open you FTP client and
    1. Set folder "htmlhelp" as your local site.
    2. Set "web.sourceforge.net" as the server.
    3. Set "sftp" as transfer protocol, set port to 22.
    4. Set "normal" as access mode.
    5. Use your SourceForge's username and password to connect.
    6. List "/home/project-web/qpm/htdocs" directory.
    7. Select "htdocs" folder.
    8. Upload "index.htm" from "QPM" local folder to "htdocs" folder.
    9. Select "QPM" folder.
    10. Upload files from "htmlhelp" local folder to "QPM" server folder.
5. Note that changes to "index.htm" page must be done by hand!

## How to format your CHANGELOG.TXT entries

1. Always add new entries to the top of the file.
2. Add an entry header using this format:
   * YYYY-MM-DD HH:MM UTC[-|+]hhmm Your Full Name <your_email_address>
3. Add an entry listing all the files changed, deleted or added.
4. Mention the name of the changed function or macro.
5. Describe the changes, the reasons, and other useful comments or explanations.
6. If some related work has to be done, make a clear note about it and reference the corresponding issue.
7. Group the related changes into logical sections and use the following marks to highlight them. Example:

```
* folder/file1.txt    
+ folder/file2.prg    
- folder/file3.ch    
  * Changed: ...    
  ! Fixed: ...    
  % Optimized: ...    
  + Added: ...    
  - Removed: ...    
  ; Note
```
