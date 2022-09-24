From 7b7773458c072e4b24d6ea32d0364a8e402e4a43 Mon Sep 17 00:00:00 2001
From: swy7ch <swy7ch@protonmail.com>
Date: Fri, 8 May 2020 19:07:24 +0200
Subject: [PATCH] [PATCH] update dwm-fullgaps patch to be used with tile layout
 update

the recent tile layout changes in commit HEAD~1 (f09418b) broke the
patch

this patch adapt the new `if` statements to take gaps into account

this patch also provides manpage entries for the keybindings
---
 config.def.h |  4 ++++
 dwm.1        | 10 ++++++++++
 dwm.c        | 33 +++++++++++++++++++++++----------
 3 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/config.def.h b/config.def.h
index 1c0b587..38d2f6c 100644
--- a/config.def.h
+++ b/config.def.h
@@ -2,6 +2,7 @@
 
 /* appearance */
 static const unsigned int borderpx  = 1;        /* border pixel of windows */
+static const unsigned int gappx     = 5;        /* gaps between windows */
 static const unsigned int snap      = 32;       /* snap pixel */
 static const int showbar            = 1;        /* 0 means no bar */
 static const int topbar             = 1;        /* 0 means bottom bar */
@@ -84,6 +85,9 @@ static Key keys[] = {
 	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
 	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
 	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
+	{ MODKEY,                       XK_minus,  setgaps,        {.i = -1 } },
+	{ MODKEY,                       XK_equal,  setgaps,        {.i = +1 } },
+	{ MODKEY|ShiftMask,             XK_equal,  setgaps,        {.i = 0  } },
 	TAGKEYS(                        XK_1,                      0)
 	TAGKEYS(                        XK_2,                      1)
 	TAGKEYS(                        XK_3,                      2)
diff --git a/dwm.1 b/dwm.1
index 13b3729..0202d96 100644
--- a/dwm.1
+++ b/dwm.1
@@ -140,6 +140,16 @@ View all windows with any tag.
 .B Mod1\-Control\-[1..n]
 Add/remove all windows with nth tag to/from the view.
 .TP
+.B Mod1\--
+Decrease the gaps around windows.
+.TP
+.B Mod1\-=
+Increase the gaps around windows.
+.TP
+.B Mod1\-Shift-=
+Reset the gaps around windows to
+.BR 0 .
+.TP
 .B Mod1\-Shift\-q
 Quit dwm.
 .SS Mouse commands
diff --git a/dwm.c b/dwm.c
index 9fd0286..45a58f3 100644
--- a/dwm.c
+++ b/dwm.c
@@ -119,6 +119,7 @@ struct Monitor {
 	int by;               /* bar geometry */
 	int mx, my, mw, mh;   /* screen size */
 	int wx, wy, ww, wh;   /* window area  */
+	int gappx;            /* gaps between windows */
 	unsigned int seltags;
 	unsigned int sellt;
 	unsigned int tagset[2];
@@ -200,6 +201,7 @@ static void sendmon(Client *c, Monitor *m);
 static void setclientstate(Client *c, long state);
 static void setfocus(Client *c);
 static void setfullscreen(Client *c, int fullscreen);
+static void setgaps(const Arg *arg);
 static void setlayout(const Arg *arg);
 static void setmfact(const Arg *arg);
 static void setup(void);
@@ -639,6 +641,7 @@ createmon(void)
 	m->nmaster = nmaster;
 	m->showbar = showbar;
 	m->topbar = topbar;
+	m->gappx = gappx;
 	m->lt[0] = &layouts[0];
 	m->lt[1] = &layouts[1 % LENGTH(layouts)];
 	strncpy(m->ltsymbol, layouts[0].symbol, sizeof m->ltsymbol);
@@ -1498,6 +1501,16 @@ setfullscreen(Client *c, int fullscreen)
 	}
 }
 
+void
+setgaps(const Arg *arg)
+{
+	if ((arg->i == 0) || (selmon->gappx + arg->i < 0))
+		selmon->gappx = 0;
+	else
+		selmon->gappx += arg->i;
+	arrange(selmon);
+}
+
 void
 setlayout(const Arg *arg)
 {
@@ -1684,18 +1697,18 @@ tile(Monitor *m)
 	if (n > m->nmaster)
 		mw = m->nmaster ? m->ww * m->mfact : 0;
 	else
-		mw = m->ww;
-	for (i = my = ty = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), i++)
+		mw = m->ww - m->gappx;
+	for (i = 0, my = ty = m->gappx, c = nexttiled(m->clients); c; c = nexttiled(c->next), i++)
 		if (i < m->nmaster) {
-			h = (m->wh - my) / (MIN(n, m->nmaster) - i);
-			resize(c, m->wx, m->wy + my, mw - (2*c->bw), h - (2*c->bw), 0);
-			if (my + HEIGHT(c) < m->wh)
-				my += HEIGHT(c);
+			h = (m->wh - my) / (MIN(n, m->nmaster) - i) - m->gappx;
+			resize(c, m->wx + m->gappx, m->wy + my, mw - (2*c->bw) - m->gappx, h - (2*c->bw), 0);
+			if (my + HEIGHT(c) + m->gappx < m->wh)
+				my += HEIGHT(c) + m->gappx;
 		} else {
-			h = (m->wh - ty) / (n - i);
-			resize(c, m->wx + mw, m->wy + ty, m->ww - mw - (2*c->bw), h - (2*c->bw), 0);
-			if (ty + HEIGHT(c) < m->wh)
-				ty += HEIGHT(c);
+			h = (m->wh - ty) / (n - i) - m->gappx;
+			resize(c, m->wx + mw + m->gappx, m->wy + ty, m->ww - mw - (2*c->bw) - 2*m->gappx, h - (2*c->bw), 0);
+			if (ty + HEIGHT(c) + m->gappx < m->wh)
+				ty += HEIGHT(c) + m->gappx;
 		}
 }
 
-- 
2.26.2

