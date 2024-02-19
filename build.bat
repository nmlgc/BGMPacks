@echo off
setlocal
set /p old=<README.sed 2>NUL
for /f "delims=" %%s in ('oggenc -v') do set "new=s/{oggenc_version}/%%s/"
if not "%old%" == "%new%" echo %new%>README.sed
tup
