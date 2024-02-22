diff -up dwm/dwm.c dwmmod/dwm.c
--- dwm/dwm.c	2020-06-25 00:21:30.383692180 -0300
+++ dwmmod/dwm.c	2020-06-25 00:20:35.643692330 -0300
@@ -1057,6 +1057,8 @@ manage(Window w, XWindowAttributes *wa)
 	updatewindowtype(c);
 	updatesizehints(c);
 	updatewmhints(c);
+	c->x = c->mon->mx + (c->mon->mw - WIDTH(c)) / 2;
+	c->y = c->mon->my + (c->mon->mh - HEIGHT(c)) / 2;
 	XSelectInput(dpy, w, EnterWindowMask|FocusChangeMask|PropertyChangeMask|StructureNotifyMask);
 	grabbuttons(c, 0);
 	if (!c->isfloating)
