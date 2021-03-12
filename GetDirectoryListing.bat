@echo off
REM Copy and run this inside the root folder containing the folders
REM you want to get a directory listing.
REM Open a DOS command prompt to execute this batch file.
REM Each folder structure will be written into a TXT file named using the enumerated folder name
@echo ********
@echo THIS COMMAND WILL CREATE A RECURSIVE DIRECTORY LISTING
@echo FOR EACH SUB-FOLDER FOUND UNDER THIS FOLDER
@echo.
@echo Hit CTRL-C now to immediately terminate this batch file
@echo ********
pause
for /d %%a in (*) do (
     start /b "" cmd.exe /c dir /s /b /a-D "%%a" >> "%%a.txt"
)
