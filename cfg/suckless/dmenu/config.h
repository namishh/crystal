/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
static int centered = 0;                    /* -c option; centers dmenu on screen */
static int min_width = 500;                    /* minimum width when centered */
/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"Iosevka Nerd Font:size=13",
  "NotoColorEmoji:pixelsize=13:antialias=true:autohint=true"

};
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/*     fg         bg       */
	[SchemeNorm] = { "#b9c1c1", "#18181a" },
	[SchemeSel] = { "#0f0f0f", "#6d92b7" },
  [SchemeSelHighlight] = { "#0f0f0f", "#e1b56a" },
  [SchemeNormHighlight] = { "#0f0f0f", "#6d92b7" },
	[SchemeOut] = { "#0f0f0f", "#679ca6" },
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 0;
/* -h option; minimum height of a menu line */
static unsigned int lineheight = 0;
static unsigned int min_lineheight = 10;

static int fuzzy = 1;                      /* -F  option; if 0, dmenu doesn't use fuzzy matching     */
/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

/* Size of the window border */
static const unsigned int border_width = 3;
