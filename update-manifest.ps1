# Script to update the Scoop manifest with the latest dev build info
# Run this manually after each release or automate via GitHub Actions

param(
    [Parameter(Mandatory)]
    [string]$Owner,
    
    [Parameter(Mandatory)]
    [string]$Repo,
    
    [Parameter()]
    [string]$Tag = "dev-latest",
    
    [Parameter()]
    [string]$OutputPath = "bloom-dev.json"
)

$ErrorActionPreference = "Stop"

# Fetch release info from GitHub API
$apiUrl = "https://api.github.com/repos/$Owner/$Repo/releases/tags/$Tag"
Write-Host "Fetching release info from $apiUrl..."

try {
    $release = Invoke-RestMethod -Uri $apiUrl -Headers @{
        "Accept" = "application/vnd.github.v3+json"
    }
} catch {
    Write-Error "Failed to fetch release: $($_.Exception.Message)"
    exit 1
}

# Find the zip asset
$asset = $release.assets | Where-Object { $_.name -eq "Bloom-Windows.zip" }
if (-not $asset) {
    Write-Error "Could not find Bloom-Windows.zip in the release"
    exit 1
}

$downloadUrl = $asset.browser_download_url
$updatedAt = $release.published_at

# Parse commit short hash from tag or body for version string
$versionDate = [DateTime]::Parse($updatedAt).ToString("yyyy.MM.dd")
$commitHash = $release.target_commitish.Substring(0, 7)
$version = "$versionDate-$commitHash"

# Download file to calculate hash
Write-Host "Downloading $downloadUrl to calculate hash..."
$tempFile = [System.IO.Path]::GetTempFileName() + ".zip"
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile -UseBasicParsing
    $hash = (Get-FileHash $tempFile -Algorithm SHA256).Hash.ToLower()
    Write-Host "Hash: $hash"
} finally {
    Remove-Item $tempFile -ErrorAction SilentlyContinue
}

# Read the manifest template and update values
$manifestPath = "$PSScriptRoot\bloom-dev.json"
if (-not (Test-Path $manifestPath)) {
    Write-Error "Manifest template not found at $manifestPath"
    exit 1
}

$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json -AsHashtable

# Update version and hash
$manifest.version = $version
$manifest.architecture.'64bit'.url = $downloadUrl
$manifest.architecture.'64bit'.hash = $hash

# Write updated manifest
$manifest | ConvertTo-Json -Depth 10 | Set-Content $OutputPath
Write-Host "Manifest updated: $OutputPath"
Write-Host "Version: $version"
Write-Host "URL: $downloadUrl"
Write-Host "Hash: $hash"
