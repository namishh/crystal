{ colors, ... }:

with colors ;{
  home.file.".obsidian/themes/chadcat.css".text = ''
    :root
    {
        --dark0:  #${background};
        --dark1:  #${mbg};
        --dark2:  #${color8};
        --dark3:  #${color0};
        --darker: #${darker};

        --light0: #${foreground};
        --light1: #${foreground};
        --light2: #${color7};
        --light3: #${color15};

        --red:    #${color1};
        --orange: #${color11};
        --yellow: #${color3};
        --green:  #${color2};
        --purple: #${color13};
        --lavender: #${color12};
        --teal: #${color14};
    }

    .theme-dark
    {
        --background-primary:         var(--dark0);
        --background-primary-alt:     var(--dark2);
        --background-secondary:       var(--darker);
        --background-secondary-alt:   var(--dark1);
        --text-normal:                var(--light2);
        --text-faint:                 var(--light0);
        --text-muted:                 var(--light1);
        --text-title-h1:              var(--red);
        --text-title-h2:              var(--blue);
        --text-title-h3:              var(--yellow);
        --text-title-h4:              var(--green);
        --text-title-h5:              var(--lavender);
        --text-title-h6:              var(--teal);
        --text-link:                  var(--blue);
        --text-a:                     var(--blue);
        --text-a-hover:               var(--dark3);
        --text-mark:                  var(--lavender);
        --pre-code:                   var(--dark3);
        --text-highlight-bg:          var(--lavender);
        --text-highlight-bg-active:   var(--green);
        --interactive-accent:         var(--lavender);
        --interactive-before:         var(--dark2);
        --background-modifier-border: var(--dark0);
        --text-accent:                var(--teal);
        --interactive-accent-rgb:     var(--teal);
        --inline-code:                var(--yellow);
        --code-block:                 var(--lavender);
        --vim-cursor:                 var(--orange);
        --text-selection:             var(--dark3);
        --text-tag:                   var(--teal);
        --task-checkbox:              var(--teal);
    }
    .theme-light
    {
        --background-primary:         var(--light3);
        --background-primary-alt:     var(--light2);
        --background-secondary:       var(--light2);
        --background-secondary-alt:   var(--light1);
        --text-normal:                var(--dark1);
        --text-faint:                 var(--dark3);
        --text-muted:                 var(--dark2);
        --text-title-h1:              var(--red);
        --text-title-h2:              var(--orange);
        --text-title-h3:              var(--yellow);
        --text-title-h4:              var(--green);
        --text-title-h5:              var(--purple);
        --text-title-h6:              var(--orange);
        --text-link:                  var(--blue);
        --text-a:                     var(--blue);
        --text-a-hover:               var(--dark0);
        --text-mark:                  var(--dark3);
        --pre-code:                   var(--dark3);
        --text-highlight-bg:          var(--purple); 
        --text-highlight-bg-active:   var(--yellow);
        --interactive-accent:         var(--dark3);
        --interactive-before:         var(--light0);
        --background-modifier-border: var(--light1);
        --text-accent:                var(--dark1);
        --interactive-accent-rgb:     var(--orange);
        --inline-code:                var(--blue);
        --code-block:                 var(--blue);
        --vim-cursor:                 var(--purple);
        --text-selection:             var(--light0);
        --text-tag:                   var(--teal);
        --task-checkbox:              var(--teal);
    }

    :root {
      --default-font: -apple-system, BlinkMacSystemFont, Segoe UI,
        Helvetica, Arial, sans-serif, Apple Color Emoji,
        Segoe UI Emoji;

      --editor-font: 'JetBrainsMono Nerd Font', 'Source Code Pro',
        ui-monospace, SFMono-Regular, SF Mono, Menlo,
        Consolas, Liberation Mono, monospace;
    }

    .markdown-source-view {
      font-family: var(--editor-font);
    }

    .markdown-preview-view {
      font-family: var(--default-font);
    }

    .theme-dark code[class*="language-"],
    .theme-dark pre[class*="language-"],
    .theme-light code[class*="language-"],
    .theme-light pre[class*="language-"]
    {
        text-shadow: none !important;
        background-color: var(--pre-code) !important;
    }

    .graph-view.color-circle,
    .graph-view.color-fill-highlight,
    .graph-view.color-line-highlight
    {
        color: var(--interactive-accent-rgb) !important;
    }
    .graph-view.color-text
    {
        color: var(--text-a-hover) !important;
    }
    /*
    .graph-view.color-fill
    {
        color: var(--background-secondary);
    }
    .graph-view.color-line
    {
      color: var(--background-modifier-border);
    }
    */

    html,
    body
    {
        font-size: 16px !important;
    }

    strong
    {
        font-weight: 600 !important;
    }

    a,
    .cm-hmd-internal-link
    {
        color: var(--text-a) !important;
        text-decoration: none !important;
    }

    a:hover,
    .cm-hmd-internal-link:hover,
    .cm-url
    {
        color: var(--text-a-hover) !important;
        text-decoration: underline !important;
    }

    a.tag, a.tag:hover {
      color: var(--text-tag) !important;
      background-color: var(--background-secondary-alt);
      padding: 2px 4px;
      border-radius: 4px;
    }

    mark
    {
        background-color: var(--text-mark);
    }

    .titlebar {
      background-color: var(--background-secondary-alt);
    }

    .titlebar-inner {
      color: var(--text-normal);
    }

    .view-actions a
    {
        color: var(--text-normal) !important;
    }

    .view-actions a:hover
    {
        color: var(--text-a) !important;
    }

    .HyperMD-codeblock-bg
    {
        background-color: var(--pre-code) !important;
    }

    .HyperMD-codeblock
    {
        line-height: 1.4em !important;
        color: var(--code-block) !important;
    }

    .HyperMD-codeblock-begin
    {
        border-top-left-radius: 4px !important;
        border-top-right-radius: 4px !important;
    }

    .HyperMD-codeblock-end
    {
        border-bottom-left-radius: 4px !important;
        border-bottom-right-radius: 4px !important;
    }

    th
    {
        font-weight: 600 !important;
    }

    thead
    {
        border-bottom: 2px solid var(--background-modifier-border) !important;
    }

    .HyperMD-table-row
    {
        line-height: normal !important;
        padding-left: 4px !important;
        padding-right: 4px !important;
        /* background-color: var(--pre-code) !important; */
    }

    .HyperMD-table-row-0
    {
        /* padding-top: 4px !important; */
    }

    .CodeMirror-foldgutter-folded,
    .is-collapsed .nav-folder-collapse-indicator
    {
        color: var(--text-a) !important;
    }

    .nav-file-tag
    {
        color: var(--text-a) !important;
    }

    .is-active .nav-file-title
    {
        color: var(--text-a) !important;
        background-color: var(--background-primary-alt) !important;
    }

    .nav-file-title
    {
        border-bottom-left-radius: 0 !important;
        border-bottom-right-radius: 0 !important;
        border-top-left-radius: 0 !important;
        border-top-right-radius: 0 !important;
    }

    .HyperMD-list-line
    {
        padding-top: 0 !important;
    }

    .cm-hashtag
    {
        color: var(--text-tag) !important;
    }

    .search-result-file-matched-text
    {
        color: var(--light3) !important;
    }

    .markdown-preview-section pre code,
    .markdown-preview-section code
    {
        font-size: 0.9em !important;
        background-color: var(--pre-code) !important;
    }

    .markdown-preview-section pre code
    {
        padding: 4px !important;
        line-height: 1.4em !important;
        display: block !important;
        color: var(--code-block) !important;
    }

    .markdown-preview-section code
    {
        color: var(--inline-code) !important;
    }

    .markdown-preview-view hr
    {
        border: none;
        border-top: 1px solid var(--text-faint);
    }

    .markdown-source-view hr
    {
        border: none;
        border-top: 1px solid var(--text-faint);
    }

    .cm-s-obsidian,
    .cm-inline-code
    {
        -webkit-font-smoothing: auto !important;
    }

    .cm-inline-code
    {
        color: var(--inline-code) !important;
        background-color: var(--pre-code) !important;
        padding: 1px !important;
    }

    .workspace-leaf-header-title
    {
        font-weight: 600 !important;
    }

    .side-dock-title
    {
        padding-top: 15px !important;
        font-size: 20px !important;
    }

    .side-dock-ribbon-tab:hover,
    .side-dock-ribbon-action:hover,
    .side-dock-ribbon-action.is-active:hover,
    .nav-action-button:hover,
    .side-dock-collapse-btn:hover
    {
        color: var(--text-a);
    }

    .side-dock
    {
        border-right: 0 !important;
    }

    .cm-s-obsidian,
    .markdown-preview-view
    {
        /* padding-left: 10px !important; */
        padding-right: 10px !important;
    }

    /* vertical resize-handle */
    .workspace-split.mod-vertical > * > .workspace-leaf-resize-handle,
    .workspace-split.mod-left-split > .workspace-leaf-resize-handle,
    .workspace-split.mod-right-split > .workspace-leaf-resize-handle
    {
        width: 1px !important;
        background-color: var(--background-secondary-alt);
    }

    /* horizontal resize-handle */
    .workspace-split.mod-horizontal > * > .workspace-leaf-resize-handle
    {
        height: 1px !important;
        background-color: var(--background-secondary-alt);
    }

    /* Remove vertical split padding */
    .workspace-split.mod-root .workspace-split.mod-vertical .workspace-leaf-content,
    .workspace-split.mod-vertical > .workspace-split,
    .workspace-split.mod-vertical > .workspace-leaf,
    .workspace-tabs
    {
        padding-right: 0px;
    }

    .markdown-embed-title
    {
        font-weight: 600 !important;
    }

    .markdown-embed
    {
        padding-left: 10px !important;
        padding-right: 10px !important;
        margin-left: 10px !important;
        margin-right: 10px !important;
    }

    .cm-header-1.cm-link,
    h1 a
    {
        color: var(--text-title-h1) !important;
    }

    .cm-header-2.cm-link,
    h2 a
    {
        color: var(--text-title-h2) !important;
    }

    .cm-header-3.cm-link,
    h3 a
    {
        color: var(--text-title-h3) !important;
    }
    .cm-header-4.cm-link,
    h4 a
    {
        color: var(--text-title-h4) !important;
    }
    .cm-header-5.cm-link,
    h5 a
    {
        color: var(--text-title-h5) !important;
    }
    .cm-header-6.cm-link,
    h6 a
    {
        color: var(--text-title-h6) !important;
    }

    .cm-header {
        font-weight: 500 !important;
    }

    .HyperMD-header-1,
    .markdown-preview-section h1
    {
        font-weight: 500 !important;
        font-size: 2.2em !important;
        color: var(--text-title-h1) !important;
    }

    .HyperMD-header-2,
    .markdown-preview-section h2
    {
        font-weight: 500 !important;
        font-size: 2.0em !important;
        color: var(--text-title-h2) !important;
    }

    .HyperMD-header-3,
    .markdown-preview-section h3
    {
        font-weight: 500 !important;
        font-size: 1.8em !important;
        color: var(--text-title-h3) !important;
    }

    .HyperMD-header-4,
    .markdown-preview-section h4
    {
        font-weight: 500 !important;
        font-size: 1.6em !important;
        color: var(--text-title-h4) !important;
    }

    .HyperMD-header-5,
    .markdown-preview-section h5
    {
        font-weight: 500 !important;
        font-size: 1.4em !important;
        color: var(--text-title-h5) !important;
    }

    .HyperMD-header-6,
    .markdown-preview-section h6
    {
        font-weight: 500 !important;
        font-size: 1.2em !important;
        color: var(--text-title-h6) !important;
    }

    .suggestion-item.is-selected
    {
        background-color: var(--background-secondary);
    }

    .empty-state-action:hover
    {
        color: var(--interactive-accent);
    }

    .checkbox-container
    {
        background-color: var(--interactive-before);
    }

    .checkbox-container:after
    {
        background-color: var(--background-secondary-alt);
    }

    .mod-cta
    {
        color: var(--background-secondary-alt) !important;
        font-weight: 600 !important;
    }

    .mod-cta:hover
    {
        background-color: var(--interactive-before) !important;
        font-weight: 600 !important;
    }

    .CodeMirror-cursor
    {
        background-color: var(--vim-cursor) !important;
        opacity: 60% !important;
    }

    input.task-list-item-checkbox {
        border: 1px solid var(--task-checkbox);
        appearance: none;
        --webkit-appearance: none;
    }

    input.task-list-item-checkbox:checked {
        background-color: var(--task-checkbox);
        box-shadow: inset 0 0 0 2px var(--background-primary);
    }

    .mermaid .note
    {
        fill: var(--blue) !important;
    }

    .setting-item-control input[type="text"] {
        color: var(--text-normal);
    }
    .setting-item-control input[type="text"]::placeholder {
        color: var(--dark3);
    }
  '';
}


