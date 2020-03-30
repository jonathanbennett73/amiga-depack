@if "X%VBCC%"=="X%~dp0" goto AlreadySet
@set VBCC=%~dp0
@set PATH=%VBCC%;%PATH%
:AlreadySet