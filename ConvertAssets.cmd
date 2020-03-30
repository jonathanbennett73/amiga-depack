@echo off
@set _oldpath=%cd%
cd /d %~dp0
call bin\setpaths.bat

if not exist AssetsConverted md AssetsConverted
if errorlevel 1 goto failed
del AssetsConverted\* /s /q >NUL
if errorlevel 1 goto failed

copy Assets\*.* AssetsConverted\*.*
cd /d AssetsConverted

@rem test file 1 (text files)
call :compress test.bin


echo SUCCESS
cd /d %_oldpath%
exit /b 0

:failed
echo FAILED
cd /d %_oldpath%
exit /b 1


:compress
lz4 -9 --no-frame-crc %1 %1.lz4
nrv2x -es -o %1.nrv2s %1
doynamite68k_lz -o %1.doy %1
cranker -cd -f %1 -o %1.cra
rnc_pack_x86.exe p %1 %1.rnc1 -m=1
rnc_pack_x86.exe p %1 %1.rnc2 -m=2

rem arjbeta a -m7 -jm %1.arj %1
rem arj2raw %1.arj %1 %1.am7
rem del %1.arj

packfire -l %1 %1.pkl
packfire -t %1 %1.pkt

shrinkler -3 -d -p %1 %1.shr

exit /b
