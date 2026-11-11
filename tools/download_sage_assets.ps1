$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$agentId = '569fdd95-4d10-43ab-ca70-79becc718b46'
$base = "https://media.valorant-api.com/agents/$agentId"

$downloads = @{
    'assets/sage/images/portrait.png' = "$base/fullportrait.png"
    'assets/sage/images/background.png' = "$base/background.png"
    'assets/sage/abilities/barrier_orb.png' = "$base/abilities/grenade/displayicon.png"
    'assets/sage/abilities/slow_orb.png' = "$base/abilities/ability1/displayicon.png"
    'assets/sage/abilities/healing_orb.png' = "$base/abilities/ability2/displayicon.png"
    'assets/sage/abilities/resurrection.png' = "$base/abilities/ultimate/displayicon.png"
}

foreach ($entry in $downloads.GetEnumerator()) {
    $destination = Join-Path $root $entry.Key
    $directory = Split-Path -Parent $destination
    New-Item -ItemType Directory -Force -Path $directory | Out-Null
    Write-Host "Downloading $($entry.Key)..."
    Invoke-WebRequest -Uri $entry.Value -OutFile $destination
    if ((Get-Item $destination).Length -lt 100) {
        throw "Downloaded file looks too small: $destination"
    }
}

Write-Host ''
Write-Host 'Sage images and ability icons are ready.'
Write-Host 'Now add the four MP4 files to assets/sage/videos/.'
Write-Host 'Optional: add the Russian MP3 files to assets/sage/voice/.'
