{ config, colors, ... }:

with colors ;{
  home.file.".config/BetterDiscord/themes/chadcat7.theme.css".text = ''
    @import url(https://schnensch0.github.io/zelk/main.css);
    @import url(https://discord-custom-covers.github.io/usrbg/dist/usrbg.css);
    @import url(https://mwittrien.github.io/BetterDiscordAddons/Themes/_res/SettingsIcons.css);

    :root {
      /* set to 'unset' to show */
      --scrollbars: none;
      /* user notes */
      --notes: none;
      /* direct message box */
      --message: none;
      /* set to '4px solid' to show */
      --embed-color: none;
      /* set to 'Inter', sans-serif !important to use Inter font*/
      --font-primary: Whitney, "Helvetica Neue", Helvetica, Arial, sans-serif;
      --font-display: Whitney, "Helvetica Neue", Helvetica, Arial, sans-serif !important;
      --border-radius-1: 10px;
      --border-radius-2: 8px;
    }

    /*-----------CUSTOM COLORS-----------*/
    /*-------------DARK MODE-------------*/
    /*---------------BASIC---------------*/
    .theme-dark {
      --accent-color: #${color4};
      --background-1: #${darker};
      --background-2: #${background};
      --background-accent: #${mbg};
      --border-color: #${color0};
    }

    /*-------------LIGHT MODE------------*/
    .theme-light {
      --accent-color: #${color12};
      --background-1: #${foreground};
      --background-2: #${color15};
      --background-accent: var(--background-2);
      --border-color: transparent;
    }

    /*-------------ADVANCED--------------*/
    .theme-dark {
      /* background */
      --background-primary: var(--background-1);
      --background-primary-alt: var(--background-1);
      --background-secondary: var(--background-1);
      --background-secondary-alt: var(--background-1);
      --background-tertiary: var(--background-2);
      --background-accent-gradient: var(--background-2);
      --background-floating: var(--background-1);
      --background-mentioned: #${background}15;
      --background-mentioned-hover: #${background}15;
      /* modifiers */
      --background-modifier-hover: #${cursorline};
      --background-modifier-active: #${color0};
      --background-modifier-selected: var(--accent-color);
      --background-modifier-accent: transparent;
      --background-message-hover: transparent;
      /* text */
      --text-normal: var(--accent-color);
      --text-positive: var(--text-normal);
      --text-muted: #${comment};
      --text-link: #${foreground};
      --interactive-selected: var(--background-primary);
      --interactive-active: var(--text-normal);
      --interactive-normal: var(--text-normal);
      --interactive-muted: var(--button-background-active);
      --channels-default: var(--text-muted);
      --header-primary: var(--text-normal);
      --header-secondary: var(--text-muted);
      /* more */
      --settings-icon-color: #8eacbc;
      --control-brand-foreground: var(--accent-color);
      --info-warning-foreground: var(--accent-color);
      --tab-selected: #${color8};
      --switch: #${color8};
      --activity-card-background: var(--background-1);
      --brand-experiment: var(--accent-color) !important;
      /* buttons */
      --button-background: #${mbg};
      --button-background-hover: #${color0};
      --button-background-active: #${color0};
      --button-accent: var(--accent-color);
      --button-accent-hover: #${foreground};
      --button-accent-active: #${color4};
      --button-destructive: #${color9};
      --button-destructive-hover: #${color9};
      --button-destructive-active: #${color9};
    }

    .theme-light {
      /* background */
      --background-primary: var(--background-1);
      --background-primary-alt: var(--background-1);
      --background-secondary: var(--background-1);
      --background-secondary-alt: var(--background-1);
      --background-tertiary: var(--background-2);
      --background-accent-gradient: var(--background-2);
      --background-floating: var(--background-1);
      --background-mentioned: #${background}10;
      --background-mentioned-hover: #${background}15;
      /* modifiers */
      --background-modifier-hover: transparent;
      --background-modifier-active: #b7c2cc;
      --background-modifier-selected: var(--accent-color);
      --background-modifier-accent: transparent;
      --background-message-hover: transparent;
      /* text */
      --text-normal: #${background};
      --text-positive: var(--text-normal);
      --text-muted: #8495a7;
      --text-link: #${color4};
      --interactive-selected: var(--background-primary);
      --interactive-active: var(--text-normal);
      --interactive-normal: var(--text-normal);
      --interactive-muted: var(--text-muted);
      --channels-default: var(--text-normal);
      --header-primary: var(--text-normal);
      --header-secondary: var(--text-muted);
      /* more */
      --settings-icon-color: #566e86;
      --control-brand-foreground: var(--accent-color);
      --info-warning-foreground: var(--accent-color);
      --tab-selected: var(--background-1);
      --switch: #c8d0d9;
      --activity-card-background: var(--background-1);
      --brand-experiment: var(--accent-color) !important;
      /* buttons */
      --button-background: var(--background-1);
      --button-background-hover: #d3dae1;
      --button-background-active: #b1bcc8;
      --button-accent: var(--accent-color);
      --button-accent-hover: #${color4};
      --button-accent-active: #${color4};
      --button-destructive: #${color9};
      --button-destructive-hover: #${color9};
      --button-destructive-active: ;
    }

    /*-----------DON'T CHANGE------------*/
    :root {
      --outdated-122: none !important;
    }

    /*  usrbg | snippet by _david_#0218  */
    .userPopout-2j1gM4[style*="--user-background"] .banner-1YaD3N,
    .root-8LYsGj[style*="--user-background"] .banner-1YaD3N {
      height: 120px;
      background: var(--background-tertiary) var(--user-background) var(--user-popout-position, center) center / cover !important;
    }

    .root-8LYsGj[style*="--user-background"] .banner-1YaD3N {
      height: 240px;
    }

  '';
}

