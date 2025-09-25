@echo off
REM === Squad WebUI Launcher: AMD Ryzen 7 5700G + RX 6650 XT 8GB ===

REM ✅ Optional: Explicit Python path
set PYTHON=c:\AUTO1111\stable-diffusion-webui\venv\Scripts\python.exe

REM ✅ Optional: Virtual environment directory
set VENV_DIR=venv

REM ✅ Optional: Git path if needed
REM set GIT=git

REM Ensure logs directory exists to avoid "The system cannot find the path specified." when redirecting output
if not exist "%~dp0logs" (
    mkdir "%~dp0logs"
)

REM Sanity-check PYTHON path; fall back to local venv if the explicitly set path is missing
if not exist "%PYTHON%" (
    echo WARNING: Python executable not found at %PYTHON%
    echo Attempting fallback to local virtual environment: %VENV_DIR%\Scripts\python.exe
    set "PYTHON=%~dp0%VENV_DIR%\Scripts\python.exe"
    if not exist "%PYTHON%" (
        echo ERROR: Could not find Python executable at %PYTHON%
        echo Please create the virtual environment or set PYTHON to the correct path in webui-user.bat
        pause
    ) else (
        echo Found Python at %PYTHON%
    )
)

REM ✅ Fallback flags if not injected by PowerShell
if not defined COMMANDLINE_ARGS (
set COMMANDLINE_ARGS=--use-directml --precision full --no-half --lowvram --disable-nan-check --skip-torch-cuda-test --loglevel INFO --skip-install --enable-insecure-extension-access --theme dark --opt-split-attention

)

REM ✅ Optional: Log launch timestamp
echo [%DATE% %TIME%] Launching WebUI with flags: %COMMANDLINE_ARGS% >> logs\launch.log

REM 🚀 Launch WebUI
call webui.bat