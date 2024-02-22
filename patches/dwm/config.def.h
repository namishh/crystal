 /* See LICENSE file for copyright and license details. */
 #include <X11/XF86keysym.h>

#define SESSION_FILE "/tmp/dwm-session"
 /* appearance */
static unsigned int borderpx  = 3;        /* border pixel of windows */
static unsigned int snap      = 8;       /* snap pixel */
static int showbar            = 1;        /* 0 means no bar */
static int topbar             = 1;        /* 0 means bottom bar */
static char normbgcolor[]           = "#222222";
static char normbordercolor[]       = "#444444";
static const int horizpadbar        = 6;        /* horizontal padding for statusbar */
static const int vertpadbar         = 5;        /* vertical padding for statusbar */
static char normfgcolor[]           = "#bbbbbb";
static char selfgcolor[]            = "#eeeeee";
static char selbordercolor[]        = "#005577";
static char selbgcolor[]            = "#005577";
static char urgborder[]   = "#ff0000";

static const char buttonbar[]       = " ";

static const unsigned int tabModKey 		= 0x40;	/* if this key is hold the alt-tab functionality stays acitve. This key must be the same as key that is used to active functin altTabStart `*/
static const unsigned int tabCycleKey 		= 0x17;	/* if this key is hit the alt-tab program moves one position forward in clients stack. This key must be the same as key that is used to active functin altTabStart */
static const unsigned int tabPosY 			= 1;	/* tab position on Y axis, 0 = bottom, 1 = center, 2 = top */
static const unsigned int tabPosX 			= 1;	/* tab position on X axis, 0 = left, 1 = center, 2 = right */
static const unsigned int maxWTab 			= 600;	/* tab menu width */
static const unsigned int maxHTab 			= 200;	/* tab menu height */


static char *colors[][3] = {
       /*               fg           bg           border   */
       [SchemeNorm] = { normfgcolor, normbgcolor, normbordercolor },
       [SchemeSel]  = { selfgcolor,  selbgcolor,  selbordercolor  },
       [SchemeHid]  = { normfgcolor, selbgcolor,  normbordercolor },
       [SchemeUrg]  = { normfgcolor, normbgcolor,  urgborder  },
       [SchemeButton]  = { normbgcolor, selfgcolor,  urgborder  },

 };
static const int user_bh            = 10;        /* 2 is the default spacing around the bar's font */

static const unsigned int ulinepad	= 5;	/* horizontal padding between the underline and tag */
static const unsigned int ulinestroke	= 2;	/* thickness / height of the underline */
static const unsigned int ulinevoffset	= 0;	/* how far above the bottom of the bar the line should appear */
static const int ulineall 		= 0;	/* 1 to show underline on all tags, 0 for just the active ones */
static const int swallowfloating    = 1;        /* 1 means swallow floating windows by default */
static const unsigned int gappx     = 10;

static const unsigned int systraypinning =
    0; /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor
          X */
static const unsigned int systrayonleft =
    0; /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 10; /* systray spacing */
static const int systraypinningfailfirst =
    1; /* 1: if pinning fails, display systray on the first monitor, False:
          display systray on the last monitor*/
static const unsigned int systrayiconsize = 12; /* systray icon size in px */
static const int showsystray = 1;               /* 0 means no systray */
static const char *fonts[] = {
    "Iosevka Nerd Font:size=12:style=Regular",
    "Noto Color Emoji:size=12:antialias=true:autohint=true",
    "Material Design Icons Desktop:size=11"};

static const char dmenufont[] = "Iosevka Nerd Font:size=14";

 /* tagging */
static char *tags[] = {"cmd", "www", "dev", "chat", "sys"};
static char *alttags[] = {"[cmd]",  "[www]", "[dev]",
                          "[chat]"};

typedef struct {
	const char *name;
	const void *cmd;
} Sp;

const  char *spterm[] = {"wezterm","start" ,"--always-new-process", "--class" ,"spterm", NULL};

static Sp scratchpads[] = {
	/* name          cmd  */
	{"spterm",      spterm},
};


 static const Rule rules[] = {
 	/* xprop(1):
 	 *	WM_CLASS(STRING) = instance, class
 	 *	WM_NAME(STRING) = title
 	 */
  { "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
	/* class     instance  title           tags mask  isfloating  isterminal  noswallow  monitor */
{ "Gimp",    NULL,     NULL,           0,         1,          0,           0,        -1 },
	{ "Firefox", NULL,     NULL,           1 << 8,    0,          0,          -1,        -1 },
{ "org.wezfurlong.wezterm",      NULL,     NULL,           0,         0,          1,           0,        -1 },
{ "st-256color",      NULL,     NULL,           0,         0,          1,           0,        -1 },
{ NULL,      "spterm",     NULL,           SPTAG(0),         1,          -1,          0,        -1 },
	{ NULL,      NULL,     "Event Tester", 0,         0,          0,           1,        -1 }, /* xev */

 };
 
 /* layout(s) */
 static  float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
 static  int nmaster     = 1;    /* number of clients in master area */
 static  int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
 static  int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
 
 static const Layout layouts[] = {
 	/* symbol     arrange function */
 	{ "[]=",      tile },    /* first entry is default */
 	{ "><>",      NULL },    /* no layout function means floating behavior */
 	{ "[M]",      monocle },
 };
 
 /* key definitions */
 #define MODKEY Mod4Mask
 #define TAGKEYS(KEY,TAG) \
 	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
 	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
 	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
 	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },
 
 /* helper for spawning shell commands in the pre dwm-5.0 fashion */
 #define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
 
 /* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */

static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
 static const char *termcmd[]  = { "wezterm", NULL };

static const char *upvol[]      = { "changevolume","up", NULL };
static const char *downvol[]      = { "changevolume","down", NULL };
static const char *mutevol[]      = { "changevolume","mute", NULL };

static const char *light_up[]   = { "changebrightness", "up", NULL };
static const char *light_down[]   = { "changebrightness", "down", NULL };

static const char *power[]   = { "dmenupower",  NULL };
static const char *emoji[]   = { "dmenuemoji",  NULL };
 static const Key keys[] = {
 	/* modifier                     key        function        argument */
 	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
 	{ MODKEY,                       XK_x,      spawn,          {.v = power } },
 	{ MODKEY|ShiftMask,                       XK_e,      spawn,          {.v = emoji } },
  { 0,				XK_Print,	 	   spawn,	SHCMD("maim -s -u | xclip -selection clipboard -t image/png") },
  { ShiftMask,				XK_Print,	 	   spawn,	SHCMD("maim -u | xclip -selection clipboard -t image/png") },
 	{ MODKEY,             XK_Return, spawn,          {.v = termcmd } },
 	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstackvis,  {.i = +1 } },
  { MODKEY,            			XK_v,  	   togglescratch,  {.ui = 0 } },
	{ MODKEY,                       XK_k,      focusstackvis,  {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_j,      focusstackhid,  {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_k,      focusstackhid,  {.i = -1 } },
 	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
 	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
 	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
 	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
 	{ MODKEY|ShiftMask,                       XK_Return, zoom,           {0} },
 	{ MODKEY,                       XK_q,    view,           {0} },
  { Mod1Mask,             		XK_Tab,    altTabStart,	   {0} },
 	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
 	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
 	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
 	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
 	{ MODKEY,                       XK_space,  setlayout,      {0} },
 	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
  { MODKEY|ShiftMask,             XK_f,      togglefullscr,  {0} },
 	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
 	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
 	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
 	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
 	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
 	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	{ MODKEY,                       XK_minus,  setgaps,        {.i = -1 } },
  { MODKEY,                       XK_equal,  setgaps,        {.i = +1 } },
  { MODKEY,                       XK_s,      show,           {0} },
	{ MODKEY|ShiftMask,             XK_s,      showall,        {0} },
	{ MODKEY,                       XK_h,      hide,           {0} },

  { MODKEY|ShiftMask,             XK_equal,  setgaps,        {.i = 0  } },
  { MODKEY,                       XK_A,     xrdb,           {.v = NULL } },
 	TAGKEYS(                        XK_1,                      0)
 	TAGKEYS(                        XK_2,                      1)
 	TAGKEYS(                        XK_3,                      2)
 	TAGKEYS(                        XK_4,                      3)
 	TAGKEYS(                        XK_5,                      4)
 	TAGKEYS(                        XK_6,                      5)
 	TAGKEYS(                        XK_7,                      6)
 	TAGKEYS(                        XK_8,                      7)
 	TAGKEYS(                        XK_9,                      8)
 	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
  	{ 0,                       XF86XK_AudioLowerVolume, spawn, {.v = downvol } },
	{ 0,                       XF86XK_AudioMute, spawn, {.v = mutevol } },
	{ 0,                       XF86XK_AudioRaiseVolume, spawn, {.v = upvol   } },
  	{ 0,				XF86XK_MonBrightnessUp,		spawn,	{.v = light_up} },
	{ 0,				XF86XK_MonBrightnessDown,	spawn,	{.v = light_down} },
  { MODKEY|ControlMask|ShiftMask, XK_q,      quit,           {1} },

 };
 
 /* button definitions */
 /* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
 static const Button buttons[] = {
 	/* click                event mask      button          function        argument */
 	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
 	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
 	{ ClkWinTitle,          0,              Button2,        zoom,           {0} }, 
 	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
 	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
 	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
 	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
 	{ ClkTagBar,            0,              Button1,        view,           {0} },
 	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
 	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
 	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
 };

