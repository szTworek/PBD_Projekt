@echo off
REM Batch script to run all Python generator scripts matching '.*generator.py'

echo Running Python CSV generator scripts...

for %%F in (*generator.py) do (
    echo Running %%F...
    python %%F
    if errorlevel 1 (
        echo Error occurred while running %%F
        exit /b 1
    )
)

echo All generator scripts completed successfully.
