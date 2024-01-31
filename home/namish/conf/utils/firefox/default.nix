{ colors, pkgs }:
with colors;{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "general.smoothScroll" = true;
          "layers.acceleration.force-enabled" = true;
          "media.av1.enabled" = false;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.force-enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;
          "widget.dmabuf.force-enabled" = true;
          "widget.use-xdg-desktop-portal" = true;
          "extensions.pocket.enabled" = false;
          "extensions.pocket.onSaveRecs" = false;
        };
        search = {
          force = true;
          default = "Gooogle";
          order = [ "Google" ];
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "Bing".metaData.hidden = true;
            "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
          };
        };

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          re-enable-right-click
          don-t-fuck-with-paste

          enhancer-for-youtube
          sponsorblock
          return-youtube-dislikes

          enhanced-github
          refined-github
          github-file-icons
          reddit-enhancement-suite
        ];

        userChrome = ''
          :root {
            --sfwindow: #${darker};
            --sfsecondary: #${background};
          }

          /* Urlbar View */

          /*─────────────────────────────*/
          /* Comment this section if you */
          /* want to show the URL Bar    */
          /*─────────────────────────────*/

          /*
          .urlbarView {
            display: none !important;
          }

          */

          /*─────────────────────────────*/

          /* 
          ┌─┐┌─┐┬  ┌─┐┬─┐┌─┐
          │  │ ││  │ │├┬┘└─┐
          └─┘└─┘┴─┘└─┘┴└─└─┘ 
          */

          /* Tabs colors  */
          #tabbrowser-tabs:not([movingtab])
            > #tabbrowser-arrowscrollbox
            > .tabbrowser-tab
            > .tab-stack
            > .tab-background[multiselected='true'],
          #tabbrowser-tabs:not([movingtab])
            > #tabbrowser-arrowscrollbox
            > .tabbrowser-tab
            > .tab-stack
            > .tab-background[selected='true'] {
            background-image: none !important;
            background-color: var(--toolbar-bgcolor) !important;
          }

          /* Inactive tabs color */
          #navigator-toolbox {
            background-color: var(--sfwindow) !important;
          }

          /* Window colors  */
          :root {
            --toolbar-bgcolor: var(--sfsecondary) !important;
            --tabs-border-color: var(--sfsecondary) !important;
            --lwt-sidebar-background-color: var(--sfwindow) !important;
            --lwt-toolbar-field-focus: var(--sfsecondary) !important;
          }

          /* Sidebar color  */
          #sidebar-box,
          .sidebar-placesTree {
            background-color: var(--sfwindow) !important;
          }
          /* Tabs elements  */

          .tabbrowser-tab:not([pinned]) .tab-icon-image {
            display: none !important;
          }

          #nav-bar:not([tabs-hidden='true']) {
            box-shadow: none;
          }

          #tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs])
            > #tabbrowser-arrowscrollbox
            > .tabbrowser-tab[first-visible-unpinned-tab] {
            margin-inline-start: 0 !important;
          }

          :root {
            --toolbarbutton-border-radius: 0 !important;
            --tab-border-radius: 0 !important;
            --tab-block-margin: 0 !important;
          }

          .tab-background {
            border-right: 0px solid rgba(0, 0, 0, 0) !important;
            margin-left: -4px !important;
          }

          .tabbrowser-tab:is([visuallyselected='true'], [multiselected])
            > .tab-stack
            > .tab-background {
            box-shadow: none !important;
          }

          .tabbrowser-tab[last-visible-tab='true'] {
            padding-inline-end: 0 !important;
          }

          #tabs-newtab-button {
            padding-left: 0 !important;
          }

          /* Url Bar  */
          #urlbar-input-container {
            background-color: var(--sfsecondary) !important;
            border: 1px solid rgba(0, 0, 0, 0) !important;
          }

          #urlbar-container {
            margin-left: 0 !important;
          }

          #urlbar[focused='true'] > #urlbar-background {
            box-shadow: none !important;
          }

          #navigator-toolbox {
            border: none !important;
          }

          /* Bookmarks bar  */
          toolbarbutton.bookmark-item:not(.subviewbutton) {
            min-width: 1.6em;
          }

          /* Toolbar  */
          #tracking-protection-icon-container,
          #urlbar-zoom-button,
          #star-button-box,
          #pageActionButton,
          #pageActionSeparator,
          #PanelUI-button,
          .tab-secondary-label {
            display: none !important;
          }

          .urlbarView-url {
            color: #dedede !important;
          }

          /* Disable elements  */
          #context-navigation,
          #context-savepage,
          #context-pocket,
          #context-sendpagetodevice,
          #context-selectall,
          #context-viewsource,
          #context-inspect-a11y,
          #context-sendlinktodevice,
          #context-openlinkinusercontext-menu,
          #context-bookmarklink,
          #context-savelink,
          #context-savelinktopocket,
          #context-sendlinktodevice,
          #context-searchselect,
          #context-sendimage,
          #context-print-selection {
            display: none !important;
          }

          #context_bookmarkTab,
          #context_moveTabOptions,
          #context_sendTabToDevice,
          #context_reopenInContainer,
          #context_selectAllTabs,
          #context_closeTabOptions {
            display: none !important;
          }
        '';

        userContent = ''
            @namespace url("http://www.w3.org/1999/xhtml");
            @-moz-document url("about:home") ,url("about:blank"), url("about:newtab") {
              body {
                background-color: #${darker} !important;
              }
              .search-handoff-button {
                border-radius: 12px !important;
                border-width: 2px !important;
                border-color: #${background} !important;
                background-size: 0px !important;
                background-color: #${mbg} !important;
                padding-inline-start: 10px !important;
                padding-inline-end: 10px !important;
              }
            .search-wrapper input {
              background-color: #${mbg} !important;
              border-radius: 0px !important;
              background-image: none !important;
              background-size: none !important;
              text-align: center !important;
              font-size: 17px !important;
              padding-inline-start: 10px !important;
              padding-inline-end: 10px !important;
            }
          }
        '';
      };
    };
  };
}
