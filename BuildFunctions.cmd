@rem Build functions

@echo off
set ASMLIBFUNC=%~1
@shift /1
call :%ASMLIBFUNC% %1 %2 %3 %4 %5 %6 %7 %8 %9
goto exit



@rem Setup initial params
:dosetup
@set DemoName=DepackTest

set ObjDir=Build
set RelDir=Release
set ObjFileList=
set OutDir=%ObjDir%

@rem General build params
set BuildParam=-m68000 -Fhunk -kick1hunks -linedebug -nowarn=62 -x -I Include

@rem General linker params, strip symbols unless debugging, -k keeps section order so order source files with biggest data first
set LinkParam=-bamigahunk -Bstatic -k

if not exist %ObjDir% md %ObjDir%
if errorlevel 1 goto failed
del %ObjDir%\*.o %ObjDir%\*.info %ObjDir%\*.adf /s /q >NUL
del %OutDir%\%DemoName% /s /q >NUL

exit /b





@rem Assemble function
:doassemble
set SrcFile=%1 
set ObjFile=%ObjDir%\%2
set ObjFileList=%ObjFileList% %ObjFile%
ECHO ASSEMBLING: %1
vasmm68k_mot_win32.exe %BuildParam% -o %ObjFile% %SrcFile% 
ECHO.
exit /b



@rem Link function
:dolink
echo.
echo LINKING %DemoName%
echo LinkParam: %LinkParam%
echo.

vlink %LinkParam% -o %OutDir%\%DemoName% %ObjFileList%
if errorlevel 1 goto LinkFailed
if not exist %OutDir%\%DemoName% goto LinkFailed
exit /b 0
:LinkFailed
exit /b 1


:exit
exit /b
