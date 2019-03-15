set REGKEY=HKLM\System\CurrentControlSet\Services\OCRWorker1
set REGVAL=ImagePath
 
for /f "tokens=2,*" %%a in ('reg query %REGKEY% /v %REGVAL% ^| findstr %REGVAL%') do (
    set VALUE=%%b
)
