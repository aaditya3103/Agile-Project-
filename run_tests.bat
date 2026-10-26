@echo off
setlocal EnableDelayedExpansion

title TaskPilot - Automated Test Suite

:: Change directory to the folder containing this batch script
cd /d "%~dp0"

echo =========================================================
echo       TaskPilot - Automated PyTest Suite
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
echo Please install Python 3 from https://www.python.org/downloads/
echo.
pause
exit /b 1

:python_found
echo [OK] Python detected: !PYTHON_CMD!
!PYTHON_CMD! --version
echo.

:: Ensure pytest is installed
!PYTHON_CMD! -c "import pytest" >nul 2>&1
if !ERRORLEVEL! neq 0 (
    echo [INFO] PyTest not found. Installing test dependencies via !PYTHON_CMD! -m pip...
    !PYTHON_CMD! -m pip install -r "%~dp0requirements.txt"
    echo.
)

echo [Running PyTest Suite...]
echo ---------------------------------------------------------
!PYTHON_CMD! -m pytest -v "%~dp0test_app.py"
set "TEST_EXIT_CODE=!ERRORLEVEL!"
echo ---------------------------------------------------------
echo.

if !TEST_EXIT_CODE! equ 0 (
    echo [SUCCESS] All 13 test cases PASSED successfully!
) else (
    echo [FAILURE] Test suite finished with exit code !TEST_EXIT_CODE!.
)

echo.
pause
exit /b !TEST_EXIT_CODE!
