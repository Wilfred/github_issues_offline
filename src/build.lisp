(load "main.lisp")

(sb-ext:save-lisp-and-die "gio"
 :toplevel 'gio:main
 :executable t)

