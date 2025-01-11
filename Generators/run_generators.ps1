# PowerShell script to run all Python generator scripts matching '.*generator.py'

Write-Output "Running Python CSV generator scripts..."

# Get all Python scripts that match the pattern *generator.py
$generatorScripts = Get-ChildItem -Path . -Filter *generator.py

# Loop through each script and execute it
foreach ($script in $generatorScripts) {
    Write-Output "Running $($script.Name)..."
    python $script.FullName

    if ($LASTEXITCODE -ne 0) {
        Write-Output "Error occurred while running $($script.Name)"
        exit $LASTEXITCODE
    }
}

Write-Output "All generator scripts completed successfully."
