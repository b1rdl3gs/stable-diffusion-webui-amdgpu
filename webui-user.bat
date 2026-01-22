@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM Stable Diffusion WebUI - AMD (DirectML) Launcher
REM GPU: AMD RX 9060 XT 16GB
REM Repo: lshqqytiger DirectML lineage (your fork)
REM ============================================================

set "ROOT=%~dp0"
cd /d "%ROOT%"

REM --- Ensure logs directory exists ---
if not exist "%ROOT%logs" (
    mkdir "%ROOT%logs"
)

REM --- VENV / Python ---
REM Prefer local venv python. If missing, WebUI will create venv when running webui.bat.
set "VENV_DIR=venv"
set "PYTHON=%ROOT%%VENV_DIR%\Scripts\python.exe"

if not exist "%PYTHON%" (
    echo [WARN] Python not found at: %PYTHON%
    echo [INFO] If this is first run, launching webui.bat will create the venv.
)

REM ============================================================
REM AMD DirectML Recommended Flags (RX 9060 XT 16GB)
REM ============================================================
REM Core:
REM --use-directml      : DirectML backend
REM --no-half-vae       : Helps avoid SDXL/Pony VAE decode weirdness on some setups
REM --skip-torch-cuda-test : Prevent CUDA checks
REM Optional stability:
REM --disable-nan-check : Only if you still get NaNs/black images after UI upcast setting
REM VRAM modes:
REM --medvram           : safer if you run heavy SDXL/Pony + ControlNet
REM --lowvram           : last resort
REM ============================================================

REM ---- Choose VRAM mode: default / medvram / lowvram ----
set "VRAM_MODE=default"

set "COMMANDLINE_ARGS=--use-directml --no-half-vae --skip-torch-cuda-test"

if /I "%VRAM_MODE%"=="medvram" set "COMMANDLINE_ARGS=%COMMANDLINE_ARGS% --medvram"
if /I "%VRAM_MODE%"=="lowvram" set "COMMANDLINE_ARGS=%COMMANDLINE_ARGS% --lowvram"

REM If you still get NaNs after enabling Settings -> Optimizations -> Upcast cross-attention to float32,
REM uncomment the next line:
REM set "COMMANDLINE_ARGS=%COMMANDLINE_ARGS% --disable-nan-check"

REM --- Log launch ---
echo [%DATE% %TIME%] Launching with: %COMMANDLINE_ARGS%>> "%ROOT%logs\launch.log"

REM --- Launch ---
set "LOGFILE=%ROOT%webui_directml.log"
echo [INFO] Launching with args: %COMMANDLINE_ARGS% > "%LOGFILE%"

REM Use webui.bat for standard environment setup if python isn't present yet
if not exist "%PYTHON%" (
    call webui.bat
    exit /b
)

call "%PYTHON%" launch.py %COMMANDLINE_ARGS% >> "%LOGFILE%" 2>&1
