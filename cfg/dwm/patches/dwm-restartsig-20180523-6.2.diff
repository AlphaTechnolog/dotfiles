From 2991f37f0aaf44b9f9b11e7893ff0af8eb88f649 Mon Sep 17 00:00:00 2001
From: Christopher Drelich <cd@cdrakka.com>
Date: Wed, 23 May 2018 22:50:38 -0400
Subject: [PATCH] Modifies quit to handle restarts and adds SIGHUP and SIGTERM
 handlers.

Modified quit() to restart if it receives arg .i = 1
MOD+CTRL+SHIFT+Q was added to confid.def.h to do just that.

Signal handlers were handled for SIGHUP and SIGTERM.
If dwm receives these signals it calls quit() with
arg .i = to 1 or 0, respectively.

To restart dwm:
MOD+CTRL+SHIFT+Q
or
kill -HUP dwmpid

To quit dwm cleanly:
MOD+SHIFT+Q
or
kill -TERM dwmpid
---
 config.def.h |  1 +
 dwm.1        | 10 ++++++++++
 dwm.c        | 22 ++++++++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/config.def.h b/config.def.h
index a9ac303..e559429 100644
--- a/config.def.h
+++ b/config.def.h
@@ -94,6 +94,7 @@ static Key keys[] = {
 	TAGKEYS(                        XK_8,                      7)
 	TAGKEYS(                        XK_9,                      8)
 	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
+	{ MODKEY|ControlMask|ShiftMask, XK_q,      quit,           {1} }, 
 };
 
 /* button definitions */
diff --git a/dwm.1 b/dwm.1
index 13b3729..36a331c 100644
--- a/dwm.1
+++ b/dwm.1
@@ -142,6 +142,9 @@ Add/remove all windows with nth tag to/from the view.
 .TP
 .B Mod1\-Shift\-q
 Quit dwm.
+.TP
+.B Mod1\-Control\-Shift\-q
+Restart dwm.
 .SS Mouse commands
 .TP
 .B Mod1\-Button1
@@ -155,6 +158,13 @@ Resize focused window while dragging. Tiled windows will be toggled to the float
 .SH CUSTOMIZATION
 dwm is customized by creating a custom config.h and (re)compiling the source
 code. This keeps it fast, secure and simple.
+.SH SIGNALS
+.TP
+.B SIGHUP - 1
+Restart the dwm process.
+.TP
+.B SIGTERM - 15
+Cleanly terminate the dwm process.
 .SH SEE ALSO
 .BR dmenu (1),
 .BR st (1)
diff --git a/dwm.c b/dwm.c
index bb95e26..286eecd 100644
--- a/dwm.c
+++ b/dwm.c
@@ -205,6 +205,8 @@ static void setup(void);
 static void seturgent(Client *c, int urg);
 static void showhide(Client *c);
 static void sigchld(int unused);
+static void sighup(int unused);
+static void sigterm(int unused);
 static void spawn(const Arg *arg);
 static void tag(const Arg *arg);
 static void tagmon(const Arg *arg);
@@ -260,6 +262,7 @@ static void (*handler[LASTEvent]) (XEvent *) = {
 	[UnmapNotify] = unmapnotify
 };
 static Atom wmatom[WMLast], netatom[NetLast];
+static int restart = 0;
 static int running = 1;
 static Cur *cursor[CurLast];
 static Clr **scheme;
@@ -1248,6 +1251,7 @@ propertynotify(XEvent *e)
 void
 quit(const Arg *arg)
 {
+	if(arg->i) restart = 1;
 	running = 0;
 }
 
@@ -1536,6 +1540,9 @@ setup(void)
 	/* clean up any zombies immediately */
 	sigchld(0);
 
+	signal(SIGHUP, sighup);
+	signal(SIGTERM, sigterm);
+
 	/* init screen */
 	screen = DefaultScreen(dpy);
 	sw = DisplayWidth(dpy, screen);
@@ -1637,6 +1644,20 @@ sigchld(int unused)
 }
 
 void
+sighup(int unused)
+{
+	Arg a = {.i = 1};
+	quit(&a);
+}
+
+void
+sigterm(int unused)
+{
+	Arg a = {.i = 0};
+	quit(&a);
+}
+
+void
 spawn(const Arg *arg)
 {
 	if (arg->v == dmenucmd)
@@ -2139,6 +2160,7 @@ main(int argc, char *argv[])
 	setup();
 	scan();
 	run();
+	if(restart) execvp(argv[0], argv);
 	cleanup();
 	XCloseDisplay(dpy);
 	return EXIT_SUCCESS;
-- 
2.7.4

