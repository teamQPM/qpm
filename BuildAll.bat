@echo off

rem
rem $Id$
rem
rem This batch file builds all the executables needed to run QPM.
rem See ./doc/howtosvn.txt
rem

cls

if exist qpm.exe del qpm.exe
if not exist qpm.exe goto BUILD

echo Can't delete qpm.exe
echo Is QPM running ?
echo.
goto FIN

:BUILD
if exist CompileAll.log del CompileAll.log

"qpm_autoproject.qpm" -BUILD -LITE -FORCEFULL -CLEAR -EXIT -log(CompileAll.log)
"qpm_us_msg.qpm"      -BUILD -LITE -FORCEFULL -CLEAR -EXIT -log(CompileAll.log)
"qpm_us_redir.qpm"    -BUILD -LITE -FORCEFULL -CLEAR -EXIT -log(CompileAll.log)
"qpm_us_res.qpm"      -BUILD -LITE -FORCEFULL -CLEAR -EXIT -log(CompileAll.log)
"qpm_us_run.qpm"      -BUILD -LITE -FORCEFULL -CLEAR -EXIT -log(CompileAll.log)
"qpm_us_shell.qpm"    -BUILD -LITE -FORCEFULL -CLEAR -EXIT -log(CompileAll.log)
"qpm_us_slash.qpm"    -BUILD -LITE -FORCEFULL -CLEAR -EXIT -log(CompileAll.log)

if exist _Temp.rc del _Temp.rc

:FIN
