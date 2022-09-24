Common subdirectories: dwm/.git and dwm-new/.git
diff -up dwm/config.def.h dwm-new/config.def.h
--- dwm/config.def.h	2019-12-10 17:24:37.944708263 +1300
+++ dwm-new/config.def.h	2019-12-10 17:44:38.447670711 +1300
@@ -5,6 +5,8 @@ static const unsigned int borderpx  = 1;
 static const unsigned int snap      = 32;       /* snap pixel */
 static const int showbar            = 1;        /* 0 means no bar */
 static const int topbar             = 1;        /* 0 means bottom bar */
+static const int vertpad            = 10;       /* vertical padding of bar */
+static const int sidepad            = 10;       /* horizontal padding of bar */
 static const char *fonts[]          = { "monospace:size=10" };
 static const char dmenufont[]       = "monospace:size=10";
 static const char col_gray1[]       = "#222222";
diff -up dwm/dwm.c dwm-new/dwm.c
--- dwm/dwm.c	2019-12-10 17:24:37.945708263 +1300
+++ dwm-new/dwm.c	2019-12-10 17:41:46.192676099 +1300
@@ -241,6 +241,8 @@ static int screen;
 static int sw, sh;           /* X display screen geometry width, height */
 static int bh, blw = 0;      /* bar geometry */
 static int lrpad;            /* sum of left and right padding for text */
+static int vp;               /* vertical padding for bar */
+static int sp;               /* side padding for bar */
 static int (*xerrorxlib)(Display *, XErrorEvent *);
 static unsigned int numlockmask = 0;
 static void (*handler[LASTEvent]) (XEvent *) = {
@@ -567,7 +569,7 @@ configurenotify(XEvent *e)
 				for (c = m->clients; c; c = c->next)
 					if (c->isfullscreen)
 						resizeclient(c, m->mx, m->my, m->mw, m->mh);
-				XMoveResizeWindow(dpy, m->barwin, m->wx, m->by, m->ww, bh);
+				XMoveResizeWindow(dpy, m->barwin, m->wx + sp, m->by + vp, m->ww -  2 * sp, bh);
 			}
 			focus(NULL);
 			arrange(NULL);
@@ -705,7 +707,7 @@ drawbar(Monitor *m)
 	if (m == selmon) { /* status is only drawn on selected monitor */
 		drw_setscheme(drw, scheme[SchemeNorm]);
 		sw = TEXTW(stext) - lrpad + 2; /* 2px right padding */
-		drw_text(drw, m->ww - sw, 0, sw, bh, 0, stext, 0);
+		drw_text(drw, m->ww - sw - 2 * sp, 0, sw, bh, 0, stext, 0);
 	}
 
 	for (c = m->clients; c; c = c->next) {
@@ -731,12 +733,12 @@ drawbar(Monitor *m)
 	if ((w = m->ww - sw - x) > bh) {
 		if (m->sel) {
 			drw_setscheme(drw, scheme[m == selmon ? SchemeSel : SchemeNorm]);
-			drw_text(drw, x, 0, w, bh, lrpad / 2, m->sel->name, 0);
+			drw_text(drw, x, 0, w - 2 * sp, bh, lrpad / 2, m->sel->name, 0);
 			if (m->sel->isfloating)
 				drw_rect(drw, x + boxs, boxs, boxw, boxw, m->sel->isfixed, 0);
 		} else {
 			drw_setscheme(drw, scheme[SchemeNorm]);
-			drw_rect(drw, x, 0, w, bh, 1, 1);
+			drw_rect(drw, x, 0, w - 2 * sp, bh, 1, 1);
 		}
 	}
 	drw_map(drw, m->barwin, 0, 0, m->ww, bh);
@@ -1547,6 +1549,9 @@ setup(void)
 	lrpad = drw->fonts->h;
 	bh = drw->fonts->h + 2;
 	updategeom();
+	sp = sidepad;
+	vp = (topbar == 1) ? vertpad : - vertpad;
+
 	/* init atoms */
 	utf8string = XInternAtom(dpy, "UTF8_STRING", False);
 	wmatom[WMProtocols] = XInternAtom(dpy, "WM_PROTOCOLS", False);
@@ -1573,6 +1578,7 @@ setup(void)
 	/* init bars */
 	updatebars();
 	updatestatus();
+	updatebarpos(selmon);
 	/* supporting window for NetWMCheck */
 	wmcheckwin = XCreateSimpleWindow(dpy, root, 0, 0, 1, 1, 0, 0, 0);
 	XChangeProperty(dpy, wmcheckwin, netatom[NetWMCheck], XA_WINDOW, 32,
@@ -1701,7 +1707,7 @@ togglebar(const Arg *arg)
 {
 	selmon->showbar = !selmon->showbar;
 	updatebarpos(selmon);
-	XMoveResizeWindow(dpy, selmon->barwin, selmon->wx, selmon->by, selmon->ww, bh);
+	XMoveResizeWindow(dpy, selmon->barwin, selmon->wx + sp, selmon->by + vp, selmon->ww - 2 * sp, bh);
 	arrange(selmon);
 }
 
@@ -1811,7 +1817,7 @@ updatebars(void)
 	for (m = mons; m; m = m->next) {
 		if (m->barwin)
 			continue;
-		m->barwin = XCreateWindow(dpy, root, m->wx, m->by, m->ww, bh, 0, DefaultDepth(dpy, screen),
+		m->barwin = XCreateWindow(dpy, root, m->wx + sp, m->by + vp, m->ww - 2 * sp, bh, 0, DefaultDepth(dpy, screen),
 				CopyFromParent, DefaultVisual(dpy, screen),
 				CWOverrideRedirect|CWBackPixmap|CWEventMask, &wa);
 		XDefineCursor(dpy, m->barwin, cursor[CurNormal]->cursor);
@@ -1826,11 +1832,11 @@ updatebarpos(Monitor *m)
 	m->wy = m->my;
 	m->wh = m->mh;
 	if (m->showbar) {
-		m->wh -= bh;
-		m->by = m->topbar ? m->wy : m->wy + m->wh;
-		m->wy = m->topbar ? m->wy + bh : m->wy;
+		m->wh = m->wh - vertpad - bh;
+		m->by = m->topbar ? m->wy : m->wy + m->wh + vertpad;
+		m->wy = m->topbar ? m->wy + bh + vp : m->wy;
 	} else
-		m->by = -bh;
+		m->by = -bh - vp;
 }
 
 void
