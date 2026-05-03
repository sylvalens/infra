param (
    [string]$DataRoot = $env:FOREST_DATA_ROOT
)

if (-not $DataRoot) {
    # Default relative to this script's location (infra/scripts -> ../../forest-res)
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
    $DataRoot = Join-Path -Path $ScriptDir -ChildPath "..\..\forest-res"
}

$DataRoot = Resolve-Path -Path $DataRoot -ErrorAction SilentlyContinue

Write-Host "Checking data volume at: $DataRoot"

if (-not $DataRoot -or -not (Test-Path -Path $DataRoot -PathType Container)) {
    Write-Host "❌ ERROR: Data root directory does not exist or was not found." -ForegroundColor Red
    Write-Host "Please download the required datasets and place them in the correct folder, or set the FOREST_DATA_ROOT environment variable." -ForegroundColor Yellow
    exit 1
}

$RequiredDirs = @(
    "FORMS-T",
    "global-forest-change",
    "lidar-hd"
)

$RequiredFiles = @(
    "cadastre-68-communes.json"
)

$Missing = $false

foreach ($dir in $RequiredDirs) {
    $targetPath = Join-Path -Path $DataRoot -ChildPath $dir
    if (-not (Test-Path -Path $targetPath -PathType Container)) {
        Write-Host "❌ ERROR: Required directory '$dir' is missing in $DataRoot" -ForegroundColor Red
        $Missing = $true
    } else {
        Write-Host "✅ Found directory: $dir" -ForegroundColor Green
    }
}

foreach ($file in $RequiredFiles) {
    $targetPath = Join-Path -Path $DataRoot -ChildPath $file
    if (-not (Test-Path -Path $targetPath -PathType Leaf)) {
        Write-Host "❌ ERROR: Required file '$file' is missing in $DataRoot" -ForegroundColor Red
        $Missing = $true
    } else {
        Write-Host "✅ Found file: $file" -ForegroundColor Green
    }
}

if ($Missing) {
    Write-Host ""
    Write-Host "❌ Data validation failed. Please ensure all required datasets are present before starting the services." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ All required external datasets validated successfully!" -ForegroundColor Green
exit 0
