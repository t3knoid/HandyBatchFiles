@echo off
REM This is single-liner that gets a list of sub-folders from each top level folder
REM where the batch file is executed in
for /f "delims=" %a in ('dir /ad /b') do @for /f "delims=" %b in ('dir %a /ad /b') do @echo %a\%b
