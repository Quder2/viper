# Agent profile template

Viper and Sage now use the same profile data model:

- `AgentProfileConfig` stores the agent name, code, hero image, dossier copy, role, difficulty, archive labels and ability list.
- `AgentAbilityData` stores each ability's code, title, icon, description, video and sound asset paths.
- Each agent keeps a separate profile config and theme palette.
- Both home screens use the same layout and interaction pattern: animated hero, accelerometer parallax, pulse response, particle layer, ability cards, sound buttons, video archive and dossier navigation.
- The Sage video player mirrors the full Viper player controls, including seeking, playback speed, loop, mute, landscape fullscreen and system-back handling.

## Adding another agent

1. Create `assets/<agent>/images`, `abilities`, `videos` and `voice`.
2. Add a config file based on `lib/config/sage_profile_config.dart` or `lib/config/viper_profile_config.dart`.
3. Fill one `AgentProfileConfig` with the agent's text, hero image and `AgentAbilityData` entries. Keep asset names consistent across agents when practical (for example `C_act.mp3`, `Q_act.mp3`, `E_act.mp3`, `X_act.mp3`).
4. Create the agent palette by following `lib/theme/sage_theme.dart`; the visual effects should use palette tokens rather than one-off color literals.
5. Use the Sage profile page as the visual template. Keep the layout and effects unchanged; swap only config, palette and asset directory.
6. For video playback, use the same control behavior as `lib/pages/sage_video_player_page.dart` until the player is extracted into a shared palette-driven widget.

## Current intentional exception

Sage's Radiant Lab is temporarily omitted. It will be revisited separately after the profile, archive and player are stable.
