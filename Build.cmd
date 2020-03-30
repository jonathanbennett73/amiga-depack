@echo off
@set _oldpath=%cd%
cd /d %~dp0
call bin\setpaths.bat

@rem Setup initial values and then override as needed
call BuildFunctions.cmd dosetup

echo.
echo ASSEMBLING %DemoName%
echo BuildParam: %BuildParam%
echo.

REM Assemble all sections and link together. Assemble entry point file first
REM Assemble files that have large data/bss sections first.

call BuildFunctions.cmd doassemble main.s main.o
if errorlevel 1 goto failed

call BuildFunctions.cmd doassemble Framework\IntroLibrary.s IntroLibrary.o
if errorlevel 1 goto failed

@rem Link
call BuildFunctions.cmd dolink
if errorlevel 1 goto failed


echo SUCCESS
cd /d %_oldpath%
exit /b 0

:failed
echo FAILED
cd /d %_oldpath%
exit /b 1

@rem END

