@echo off
REG query HKLM\HARDWARE\DESCRIPTION\System\CentralProc
essor\0 /v Identifier | find "Intel64"
if "%errorlevel%"=="0" (
   echo "64-bit Windows detected"
) else (
   echo "32-bit Windows detected"
)
