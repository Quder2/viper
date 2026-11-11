$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$folders = @(
    @{ Source = 'assets/abilities'; Destination = 'assets/viper/abilities' },
    @{ Source = 'assets/images'; Destination = 'assets/viper/images' },
    @{ Source = 'assets/videos'; Destination = 'assets/viper/videos' },
    @{ Source = 'assets/sound'; Destination = 'assets/viper/voice' }
)

foreach ($folder in $folders) {
    $source = Join-Path $root $folder.Source
    $destination = Join-Path $root $folder.Destination

    if (-not (Test-Path -LiteralPath $source)) {
        Write-Host "Already moved or not present: $($folder.Source)"
        continue
    }

    New-Item -ItemType Directory -Force -Path $destination | Out-Null

    Get-ChildItem -LiteralPath $source -Force | ForEach-Object {
        $target = Join-Path $destination $_.Name
        if (Test-Path -LiteralPath $target) {
            throw "Target already exists; refusing to overwrite: $target"
        }
        Move-Item -LiteralPath $_.FullName -Destination $target
    }

    Remove-Item -LiteralPath $source -Force
    Write-Host "Moved $($folder.Source) -> $($folder.Destination)"
}

Write-Host ''
Write-Host 'Viper assets are now under assets/viper/.'
Write-Host 'Sage assets are under assets/sage/.'
Write-Host 'Next: add Sage MP4 files to assets/sage/videos/.'
