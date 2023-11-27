@echo off
set "ROOT_DIR=%~dp0"
set "BIN_DIR=%ROOT_DIR%bin"
set "DOSBOX_BIN=%ProgramFiles(x86)%\DOSBox-0.74-3\DOSBox.exe"
set "CONFIG_LOC=%ROOT_DIR%"

::"%DOSBOX_BIN%" -conf "%CONFIG_LOC%"
"%DOSBOX_BIN%" -c "MOUNT c %BIN_DIR%" -c "C:"
