/* See LICENSE file for copyright and license details. */

// vim: tabstop=2 shiftwidth=2 expandtab

/* general config */
#define SESSION_FILE "/tmp/dwm-session"
#define ICONSIZE (bh - 13)
#define ICONSPACING 12

/* appearance */
static const unsigned int borderpx  = 0;        /* border pixel of windows */
static const unsigned int gappx	    = 6;      	/* gaps between windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int scalepreview       = 4;        /* tag preview scaling */
static const int showbar            = True;     /* False means no bar */
static const int topbar             = True;     /* False means bottom bar */
static const int user_bh	          = 33;	      /* 0 means that dwm will calculate the bar height, >= 1 means dwm will use user_bh as bar height */
static const int vertpad            = gappx;    /* vertical padding of bar */
static const int sidepad            = gappx;    /* horizontal padding of bar */

/* fonts setup */

// available fonts.
static const char *fonts[] = {
  "JetBrainsMono NF:size=15",
  "CartographCF Nerd Font Mono:size=9",
  "CartographCF Nerd Font Mono:size=8",
  "JetBrainsMono NF:size=20",
  "CartographCF Nerd Font Mono:size=14",
};

// fonts choices.
static const int decotxtfontindex   = 3;                         /* Select a font for the search button. */
static const int tagsfontindex      = 0;                         /* Select a font for the tags. */
static const int normalfontindex    = 1;                         /* Select a font for the others texts. */
static const int dashboard_toggler_fontindex = 4;                /* Select a font for the dashboard toggler */
static const int statusfontindex    = 2;                         /* Select a font for the statusbar. */

/* deco text appearance */

// define format
static const char decotxtfmt[] = "";

// define margins
static const int decotxtmargins = 5;

/* tags appearance */

// tags format
static const char focusedtag[]  = "󰮯";
static const char occupiedtag[] = "󰊠";
static const char inactivetag[] = "󰊠";

// options
static const int urg_render_uline = True;  /* defines if dwm should render an underline if the tag is in urgent mode */

// applying tags number.

// IMPORTANT NOTE: if you want to add/remove tags, you have to update the
// property `tagmap` in the struct `Monitor` and add the number of the tags!
static const char *tags[] = { "1", "2", "3", "4", "5", "6" };

/* dashboard toggler appearance */

// button format
static const char dashboard_toggler_fmt[] = "漣";
static const int  dashboard_toggler_top_padding = 1;

/* colors */

// available themes:
// - decayce
// - onedark
// - tokyonight
// themes planned to add in the future:
// - chasm
// - articblush
// - everblush
// - dark decay
// - decay
// - catppuccin
// > You can help me adding these themes too! (use pull requests lol).

#include "themes/decayce.c"

// schemes definitions
static const char *colors[][3] = {
	/*		                 foreground       background  border     */

	// base schemes.
  [SchemeNorm]         = { foreground,      background, background },
	[SchemeSel]          = { foreground,      lightbg,    background },
	[SchemeHid]	 	       = { foreground,			background, background },

  // search button scheme.
  [SchemeDecoText]     = { background,      blue,       background },

  // layout scheme.
  [SchemeLayout]       = { blue,            background, background },

  // dashboard toggler scheme.
  [SchemeDashboardToggler] = { foreground,  background, background },

	// tags schemes.
  [SchemeFocusedTag]   = { yellow,          background, background },
  [SchemeUrgentTag]    = { red,             background, background },
	[SchemeTag1]         = { cyan,	          background, background },
	[SchemeTag2]         = { blue,            background, background },
	[SchemeTag3]         = { green,	          background, background },
	[SchemeTag4]         = { aqua,            background, background },
	[SchemeTag5]         = { magenta,         background, background },
	[SchemeTag6]         = { red,             background, background },
	[SchemeNormTag]      = { black,	          background, background },
};

// underline
static const int showunderline          = 0;  /* defines if should render an underline in the tags. */
static const unsigned int ulinepad      = 2;	/* horizontal padding between the underline and the tag */
static const unsigned int ulinestroke   = 1;	/* thickness / height of the underline */
static const unsigned int ulinevoffset  = 2;	/* how far above the bottom of the bar the line should appear */
static const unsigned int ulineall	    = 0;	/* 1 to show underline on all tags, 0 for just the actives ones */

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            True,        -1 },
	{ "Firefox",  NULL,       NULL,	      0,	          False,	      1 },
};

/* layout(s) */

// configuration
static const float mfact           = 0.49; /* factor of master area size [0.05..0.95] */
static const int nmaster           = 1;    /* number of clients in master area */
static const int resizehints       = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen    = 1;    /* 1 will force focus on the fullscreen window */
static const int showwinnindeck    = 0;    /* should show the deck layout the number of the clients in the layout name, e.g: [2] */
static const int showwinninmonocle = 0;    /* should show the monocle layout the number of the clients in the layout name, e.g: [4] */

// import external-layouts
#include "gaplessgrid.c"
#include "horizgrid.c"

// define layouts
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
  { "TTT",      bstack },
  { "===",      bstackhoriz },
  { "[D]",      deck },
  { "###",      gaplessgrid },
  { "HHH",      horizgrid },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ NULL,       NULL },
};

/* keybindings */

// keybindings helpers and definitions.
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

// helper for spawning shell commands in the pre dwm-5.0 fashion.
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

// import movestack
#include "movestack.c"

// define keybindings
static Key keys[] = {
	/* modifier                     key        function        argument */

  // programs
  { MODKEY|ShiftMask,             XK_Return, spawn,          SHCMD("rofi -show drun") },
  { MODKEY,                       XK_Return, spawn,          SHCMD("kitty --single-instance") },

  // toggle bar
  { MODKEY,                       XK_b,      togglebar,      {0} },

  // focus
	{ MODKEY,                       XK_j,      focusstackvis,  {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstackvis,  {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_j,      focusstackhid,  {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_k,      focusstackhid,  {.i = -1 } },

  // increment nmaster
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },

  // set mfact
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },

  // move stack (move windows, thanks to movestack patch)
	{ MODKEY|ShiftMask,             XK_j,      movestack,      {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_k,      movestack,      {.i = -1 } },

  // kill clients
	{ MODKEY,                       XK_w,      killclient,     {0} },

  // layouts cycling
	{ MODKEY,                       XK_Tab,    cyclelayout,    {.i = +1 } },
  { MODKEY|ShiftMask,             XK_Tab,    cyclelayout,    {.i = -1 } },

  // floating
	{ MODKEY,                       XK_space,  togglefloating, {0} },

  // multimonitor keybindings
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },

  // manage minimized tags
	{ MODKEY|ShiftMask, 						XK_s,			 show,					 {0} },
	{ MODKEY|ShiftMask,							XK_h,			 hide,					 {0} },

  // gaps management
	{ MODKEY,                       XK_minus,  setgaps,        {.i = -1 } },
	{ MODKEY,                       XK_equal,  setgaps,        {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_equal,  setgaps,        {.i = 0  } },

  // switch/move and manage in general the tags by keyboard numbers.
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)

  // exit of dwm
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
  { MODKEY|ShiftMask,             XK_r,      quit,           {1} },
};

/* button definitions */

// possible values:
// - ClkTagBar: Click in tagbar
// - ClkLtSymbol: Click in layout symbol
// - ClkStatusText: Click in status text
// - ClkWinTitle: Click in windows title.
// - ClkClientWin: Click in client window.
// - ClkRootWin: Click in root window (useful for spawn jgmenu or smth).

// defining buttons
static Button buttons[] = {
	/* click                event mask      button          function        argument */
  { ClkDecoText,          0,              Button1,        spawn,          SHCMD("rofi -show drun") },
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
  { ClkDashboardToggler,  0,              Button1,        spawn,          SHCMD("eww -c ~/.config/dwm/eww open --toggle dashboard") },
	{ ClkWinTitle,          0,              Button1,        togglewin,      {0} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          SHCMD("kitty --single-instance") },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

