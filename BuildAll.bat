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
for %%X in (*.QPM) do "%%X" -lite -forcefull -exit -clear --log(CompileAll.log) --logOnlyError
if exist _Temp.rc del _Temp.rc

:FIN
