# Viper assets

Viper media is being organized into the same per-agent layout as Sage:

- `abilities/` — ability icons
- `images/` — character artwork and preview images
- `videos/` — local MP4 recordings
- `voice/` — ability sounds and voice lines

After pulling this change, run `tools/migrate_agent_assets.ps1` once from the repository root. It moves the existing Viper files into these folders without changing their contents. Do not delete the old files manually before running the script.
