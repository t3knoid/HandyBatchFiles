@echo off
REM This batch file moves a given source folder into a given source folder
REM It uses Robocopy to perform the actual move. It threads several 
REM Robocopy instances to perform multiple moves simultaneously
REM The worker script recreates the moved root folder

echo %date% %time% Robomove starting > robomove.log
setlocal EnableDelayedExpansion
set source=%cd%\s
set dest=%cd%\d
set thread=0
for /f "delims=*" %%a in ('dir "%source%" /ad /b') do (
	REM create worker script
	set /a thread=!thread!+1
	echo robocopy "%source%\%%a" "%dest%\%%a" /Move /MT:8 /r:2 /tee /LOG+:log_%%a.txt > worker!thread!.bat
	echo mkdir "%source%\%%a" >> worker!thread!.bat
	echo ^(goto^) 2^>nul ^& del "%~d0%~p0worker!thread!.bat"  >> worker!thread!.bat
	echo exit >> worker!thread!.bat
	call :runworker "%~d0%~p0worker!thread!.bat"
)
REM Wait for all workers to complete
:waitforworkers
call :checkinstances
if not %INSTANCES% EQU 0  goto waitforworkers
echo %date% %time% Robomove completed >> robomove.log
goto :HALT

REM *****
REM runs a worker if there is an
REM available thread slot
REM @param worker is the path to the worker batch file
REM *****
:runworker
set worker=%~1
set numthreads=3
:wait
call :checkinstances	
REM Wait until there is an available worker slot
echo Waiting for available worker slot to run "%worker%." There are %INSTANCES% of Robocopy running.
if not %INSTANCES% LSS %numthreads% goto wait
echo %date% %time% Running %worker% >> robomove.log
echo Running %worker%
start "" /min "%worker%"
goto :EOF

REM *****
REM Sets the INSTANCES variable to the number of robocopy.exe tasks currently running
REM @noparams
REM *****
:checkinstances
for /f "usebackq" %%t in (`tasklist /fo csv /nh /fi "imagename eq robocopy.exe"^|find /v /c ""`) do set INSTANCES=%%t
set /a INSTANCES-=1
goto :eof

:HALT
cd %OLDDIR%
call :__SetErrorLevel
call :__ErrorExit 2> nul
goto :EOF

:__ErrorExit
()
goto :EOF

:__SetErrorLevel
exit /b %RETVAL%
goto :EOF

:END
exit /b %RETVAL%
