# Sage ability voice placeholders

The Sage dossier uses the same inline sound control as Viper: each ability card has a speaker button. Add one short MP3 for each ability:

- `C_act.mp3` — Barrier Orb activation
- `Q_act.mp3` — Slow Orb activation
- `E_act.mp3` — Healing Orb activation
- `X_act.mp3` — Resurrection activation

Place the files in this folder. The app loads them as `AssetSource('sage/voice/<filename>')`. These are local placeholder filenames for the selected clips; the app no longer shows a separate voice archive.
