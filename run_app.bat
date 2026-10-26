@echo off
setlocal EnableDelayedExpansion

title TaskPilot - DevOps To-Do Application

:: Change directory to the folder containing this batch script
cd /d "%~dp0"

echo =========================================================
echo       TaskPilot - DevOps To-Do Application
echo =========================================================
echo.

set "PYTHON_CMD="

:: 1. Check local virtual environments (.venv or venv)
if exist "%~dp0.venv\Scripts\python.exe" (
    "%~dp0.venv\Scripts\python.exe" -c "import sys" >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        set "PYTHON_CMD="%~dp0.venv\Scripts\python.exe""
        goto :python_found
    )
)
if exist "%~dp0venv\Scripts\python.exe" (
    "%~dp0venv\Scripts\python.exe" -c "import sys" >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        set "PYTHON_CMD="%~dp0venv\Scripts\python.exe""
        goto :python_found
    )
)

:: 2. Check Windows 'py -3' launcher (standard when python is not in PATH)
py -3 -c "import sys" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    set "PYTHON_CMD=py -3"
    goto :python_found
)

:: 3. Check standard 'python' in system PATH
python -c "import sys" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    set "PYTHON_CMD=python"
    goto :python_found
)

:: 4. Check 'py' launcher
py -c "import sys" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    set "PYTHON_CMD=py"
    goto :python_found
)

:: 5. Check 'python3' in PATH
python3 -c "import sys" >nul 2>&1
if !ERRORLEVEL! equ 0 (
    set "PYTHON_CMD=python3"
    goto :python_found
)

:: 6. Search common Windows installation folders
for /d %%D in ("%LocalAppData%\Programs\Python\Python3*") do (
    if exist "%%D\python.exe" (
        "%%D\python.exe" -c "import sys" >nul 2>&1
        if !ERRORLEVEL! equ 0 (
            set "PYTHON_CMD="%%D\python.exe""
            goto :python_found
        )
    )
)

for /d %%D in ("%ProgramFiles%\Python3*") do (
    if exist "%%D\python.exe" (
        "%%D\python.exe" -c "import sys" >nul 2>&1
        if !ERRORLEVEL! equ 0 (
            set "PYTHON_CMD="%%D\python.exe""
            goto :python_found
        )
    )
)

for /d %%D in ("C:\Python3*") do (
    if exist "%%D\python.exe" (
        "%%D\python.exe" -c "import sys" >nul 2>&1
        if !ERRORLEVEL! equ 0 (
            set "PYTHON_CMD="%%D\python.exe""
            goto :python_found
        )
    )
)

:python_not_found
echo [ERROR] Python was not detected on this system!
echo.
echo Troubleshooting:
echo   1. Install Python from https://www.python.org/downloads/
echo   2. During setup, make sure to check:
echo        [X] "Add python.exe to PATH"
echo      and/or
echo        [X] "Install launcher for all users (py.exe)"
echo.
pause
exit /b 1

:python_found
echo [OK] Python detected: !PYTHON_CMD!
!PYTHON_CMD! --version
echo.

:: Check / install dependencies using python -m pip
echo [1/2] Verifying application dependencies...
!PYTHON_CMD! -c "import flask, flask_sqlalchemy, prometheus_client" >nul 2>&1
if !ERRORLEVEL! neq 0 (
    echo [INFO] Installing required dependencies via !PYTHON_CMD! -m pip...
    !PYTHON_CMD! -m pip install -r "%~dp0requirements.txt"
    if !ERRORLEVEL! neq 0 (
        echo.
        echo [WARNING] 'pip install' encountered an issue. Checking if app can still start...
    )
) else (
    echo [OK] All dependencies are already installed.
)

echo.
echo [2/2] Starting TaskPilot server...
echo =========================================================
echo   * URL:         http://localhost:5000
echo   * Health:      http://localhost:5000/health
echo   * Metrics:     http://localhost:5000/metrics
echo   * Stop server: Press Ctrl+C in this window
echo =========================================================
echo.

!PYTHON_CMD! "%~dp0app.py"

echo.
echo =========================================================
echo   TaskPilot server has stopped.
echo =========================================================
echo.
pause
