@echo off

REM Check if an argument was provided
if "%~1"=="" (
    echo Drag and drop a shader file onto this script
    pause
    exit /b
)

REM Detect shader version

set "filename=%~nx1"
set "char7=%filename:~-7,1%"

if "%char7%" == "3" (
	ShaderCompile.exe /O 3 -ver 30 -shaderpath "%cd%" ./%1
) else (
	ShaderCompile.exe /O 3 -ver 20b -shaderpath "%cd%" ./%1
)

REM Check error level (exit code)

REM this actually means "if %ERRORLEVEL% >= 1", but windows being windows thinks the former is invalid syntax
if ERRORLEVEL 1 (
    rmdir /s /q "./shaders"
    echo Error while compiling: examine output above
    pause
    exit 1
)

xcopy /e /y /q "./shaders/fxc" "./fxc"
rmdir /s /q "./shaders"
exit 0
