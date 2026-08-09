{ config, pkgs, dms, ... }:

{
  home.username = "tux";
  home.homeDirectory = "/home/tux";
  home.stateVersion = "24.11";

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    # Cosmetic-only rebrand to "Sakura Shell": only display text (greeter,
    # about/settings copy) is touched. The ~/.config/DankMaterialShell
    # path and GitHub URLs are left as-is -- those are functional (our
    # custom theme file lives there), not just branding.
    package = (dms.lib.mkDmsShell pkgs).overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        substituteInPlace $out/share/quickshell/dms/Modals/Greeter/GreeterWelcomePage.qml \
          --replace-fail 'Welcome to DankMaterialShell' 'Welcome to Sakura Shell'
        substituteInPlace $out/share/quickshell/dms/Modals/Greeter/GreeterCompletePage.qml \
          --replace-fail 'DankMaterialShell is ready to use' 'Sakura Shell is ready to use' \
          --replace-fail '"DMS Shortcuts"' '"Sakura Shell Shortcuts"' \
          --replace-fail 'No DMS shortcuts configured' 'No Sakura Shell shortcuts configured'
        substituteInPlace $out/share/quickshell/dms/Modules/Settings/PluginBrowser.qml \
          --replace-fail 'not officially supported by DankMaterialShell' 'not officially supported by Sakura Shell'
        substituteInPlace $out/share/quickshell/dms/Modules/Settings/PowerSleepTab.qml \
          --replace-fail 'Restart the DankMaterialShell' 'Restart Sakura Shell'
        substituteInPlace $out/share/quickshell/dms/Modules/Settings/AboutTab.qml \
          --replace-fail 'text: "DANK LINUX"' 'text: "SAKURA SHELL"' \
          --replace-fail "I18n.tr('dms is a highly customizable" "I18n.tr('Sakura Shell is a highly customizable" \
          --replace-fail 'source: "file://" + Theme.shellDir + "/assets/danklogonormal.svg"' \
                          'source: "file:///home/tux/.local/share/dms-icons/astolfo.png"' \
          --replace-fail $'                            layer.enabled: true\n                            layer.smooth: true\n                            layer.mipmap: true\n                            layer.effect: MultiEffect {\n                                saturation: 0\n                                colorization: 1\n                                colorizationColor: Theme.primary\n                            }' \
                          '                            layer.enabled: false'
        substituteInPlace $out/share/quickshell/dms/Modals/Changelog/ChangelogContent.qml \
          --replace-fail 'text: "DMS " + ChangelogService.currentVersion' 'text: "Sakura Shell " + ChangelogService.currentVersion'
        substituteInPlace $out/share/quickshell/dms/Widgets/DankBackdrop.qml \
          --replace-fail 'source: "file://" + Theme.shellDir + "/assets/danklogonormal.svg"' \
                          'source: "file:///home/tux/.local/share/dms-icons/astolfo.png"' \
          --replace-fail $'        layer.enabled: true\n        layer.smooth: true\n        layer.mipmap: true\n        layer.effect: MultiEffect {\n            saturation: 0\n            colorization: 1\n            colorizationColor: Theme.primary\n        }' \
                          '        layer.enabled: false'
        substituteInPlace $out/share/quickshell/dms/Modules/Settings/ClipboardTab.qml \
          --replace-fail 'DMS service is not connected' 'Sakura Shell service is not connected'
        substituteInPlace $out/share/quickshell/dms/Modules/Settings/DefaultAppsTab.qml \
          --replace-fail 'I18n.tr("DMS Chooser")' 'I18n.tr("Sakura Shell Chooser")'
        substituteInPlace $out/share/quickshell/dms/Common/KeybindActions.js \
          --replace-fail '{ id: "dms", label: "DMS Action", icon: "widgets" }' '{ id: "dms", label: "Sakura Shell Action", icon: "widgets" }' \
          --replace-fail '["DMS", "Execute"' '["Sakura Shell", "Execute"'
        substituteInPlace $out/share/quickshell/dms/Modules/Settings/PluginsTab.qml \
          --replace-fail 'extending DMS functionality' 'extending Sakura Shell functionality' \
          --replace-fail 'DMS Plugin Manager Unavailable' 'Sakura Shell Plugin Manager Unavailable' \
          --replace-fail 'Some plugins require a newer version of DMS:' 'Some plugins require a newer version of Sakura Shell:'
      '';
    });
    # Only start alongside niri's own systemd unit, not KDE Plasma's
    # kwin_wayland session (both bind to the generic graphical-session.target).
    systemd.target = "niri.service";
    enableDynamicTheming = true;
    enableSystemMonitoring = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;

    settings = {
      # Dusty pink + ice blue, neutral dark surfaces.
      currentThemeName = "custom";
      currentThemeCategory = "custom";
      customThemeFile = "~/.config/DankMaterialShell/themes/dusty-ice.json";

      # Control center active toggles: ice blue.
      controlCenterTileColorMode = "secondary";

      # Earlier low-battery warnings than the defaults (20/10).
      batteryLowThreshold = 25;
      batteryCriticalThreshold = 12;

      # Bar launcher button: heart instead of the 9-dot app grid icon.
      launcherLogoMode = "custom";
      launcherLogoCustomPath = "/home/tux/.local/share/dms-icons/heart.png";
      launcherLogoColorOverride = "#FF9EBB";

      # A little extra "sweetness" on top of the pink/blue base: soft pink
      # tint on the bar/dock pills (kept subtle + default text color, since
      # a stronger tint made text unreadable before), bigger corner radius.
      widgetColorMode = "default";
      widgetBackgroundColor = "custom";
      widgetBackgroundCustomColor = "#FF9EBB";
      widgetBackgroundCustomStrength = 0.3;
      cornerRadius = 20;

      # Papirus doesn't have a vesktop icon and fell back to a generic
      # rainbow "unknown app" placeholder instead -- reverted to System
      # Default so real app icons (vesktop, etc.) show correctly.

      # KDE-style always-visible bottom dock/taskbar with an app launcher button.
      showDock = true;
      dockAutoHide = false;
      dockLauncherEnabled = true;

      # Only show the dock on the laptop screen, not the side monitor.
      # wallpaper = [] disables DMS's own background layer entirely, so its
      # black fill panel stops covering the mpvpaper video wallpapers
      # (both render on the wlr-layer-shell "background" layer).
      screenPreferences = {
        dock = [ "eDP-1" ];
        wallpaper = [ ];
      };
    };
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    mpvpaper
    nautilus
    xwayland-satellite
    ghostty
    nerd-fonts.jetbrains-mono
    loupe
  ];

  # Default image viewer for JPEG/PNG/etc -- nothing was handling them before.
  # Pre-existing scheme-handler associations (Discord, Claude, GitHub
  # Desktop, LM Studio, browser links) are carried over so they aren't lost.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/bmp" = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";

      "x-scheme-handler/claude" = "Claude.desktop";
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
      "x-scheme-handler/discord" = "vesktop.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/lmstudio" = "lm-studio.desktop";
      "x-scheme-handler/x-github-client" = "github-desktop.desktop";
      "x-scheme-handler/x-github-desktop-dev-auth" = "github-desktop.desktop";
    };
    associations.added = {
      "x-scheme-handler/discord" = "vesktop.desktop";
      "x-scheme-handler/lmstudio" = [ "lm-studio.desktop" "LM-Studio.desktop" ];
    };
  };

  # Catppuccin Mocha Pink cursor -- matches the sakura pink theme instead
  # of the previous neutral white/ice Bibata cursor.
  home.pointerCursor = {
    enable = true;
    package = pkgs.catppuccin-cursors.mochaPink;
    name = "catppuccin-mocha-pink-cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.file.".config/ghostty/config".text = ''
    theme = dankcolors
    font-family = JetBrainsMono Nerd Font
    font-size = 11
    window-padding-x = 10
    window-padding-y = 10
    background-opacity = 0.94
    cursor-style = block
    mouse-hide-while-typing = true
  '';

  # WirePlumber auto-switches Bluetooth to the low-quality HSP/HFP profile
  # whenever any app tries to record audio from it (even if the device is
  # currently in high-quality A2DP mode). Disable that so the headset mic
  # stays off and playback quality never drops.
  home.file.".config/wireplumber/wireplumber.conf.d/51-disable-bt-mic-autoswitch.conf".text = ''
    wireplumber.settings = {
      bluetooth.autoswitch-to-headset-profile = false
    }
  '';

  # Modrinth's AppImage bundles a GTK3 build with no working Wayland
  # backend (crashes in gtk_init before even trying to open a display).
  # Route it through the rootless XWayland instance (xwayland-satellite,
  # spawned by niri on :23) instead of patching/recompiling anything.
  xdg.desktopEntries.modrinth = {
    name = "Modrinth";
    comment = "Modrinth App (via XWayland)";
    icon = "modrinth";
    exec = "/home/tux/.local/bin/modrinth-launch";
    terminal = false;
    categories = [ "Game" ];
    mimeType = [ "application/x-modrinth-modpack+zip" "x-scheme-handler/modrinth" ];
  };

  home.file.".local/bin/modrinth-launch" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      export DISPLAY=:23
      export GDK_BACKEND=x11
      exec appimage-run "/home/tux/İndirilenler/modrinth.AppImage" "$@"
    '';
  };

  home.file.".local/share/icons/hicolor/128x128/apps/modrinth.png".source =
    ./assets/modrinth.png;

  home.file.".local/share/dms-icons/heart.png".source = ./assets/heart.png;
  home.file.".local/share/dms-icons/astolfo.png".source = ./assets/astolfo.png;

  home.file.".config/DankMaterialShell/themes/dusty-ice.json" = {
    text = builtins.toJSON {
      # Sakura Night: vivid cherry-blossom pink against a deep night-sky
      # indigo base (not neutral gray -- a proper "night" undertone).
      dark = {
        name = "Sakura Night";
        primary = "#FF9EBB";
        primaryText = "#2b0f1c";
        primaryContainer = "#5C2A44";
        secondary = "#8C9EDE";
        surface = "#14101F";
        surfaceText = "#F3E7EF";
        surfaceVariant = "#4A4066";
        surfaceVariantText = "#DCD3EA";
        surfaceTint = "#FF9EBB";
        background = "#14101F";
        backgroundText = "#F3E7EF";
        outline = "#8C7FA3";
        surfaceContainerLowest = "#0C0916";
        surfaceContainerLow = "#1B1629";
        surfaceContainer = "#221C33";
        surfaceContainerHigh = "#2C243F";
        surfaceContainerHighest = "#392E4F";
      };
      light = {
        name = "Sakura Night";
        primary = "#D6497C";
        primaryText = "#ffffff";
        primaryContainer = "#FFD9E6";
        secondary = "#5A6DC2";
        surface = "#FFF6FA";
        surfaceText = "#241A24";
        surfaceVariant = "#EBDCE8";
        surfaceVariantText = "#4A4066";
        surfaceTint = "#D6497C";
        background = "#FFF6FA";
        backgroundText = "#241A24";
        outline = "#8C7F9A";
        surfaceContainerLowest = "#ffffff";
        surfaceContainerLow = "#FBEDF4";
        surfaceContainer = "#F5E3EE";
        surfaceContainerHigh = "#EFD9E7";
        surfaceContainerHighest = "#E9CFE0";
      };
    };
  };

  home.file.".local/bin/niri-toggle-desktop.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Toggles "show desktop" on both eDP-1 and HDMI-A-1: switches each
      # output to its dedicated empty workspace, or back to what it had
      # focused before, using a state file to track which mode we're in.
      set -euo pipefail

      state_file="''${XDG_RUNTIME_DIR:-/tmp}/niri-desktop-toggle"

      if [ -f "$state_file" ]; then
        niri msg action focus-monitor "eDP-1"
        niri msg action focus-workspace-previous
        niri msg action focus-monitor "HDMI-A-1"
        niri msg action focus-workspace-previous
        rm -f "$state_file"
      else
        niri msg action focus-monitor "eDP-1"
        niri msg action focus-workspace "desktop-edp"
        niri msg action focus-monitor "HDMI-A-1"
        niri msg action focus-workspace "desktop-hdmi"
        touch "$state_file"
      fi
    '';
  };
}
