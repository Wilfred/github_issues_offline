;; https://atomized.org/blog/2020/07/06/common-lisp-in-practice/

(require :asdf)

(defpackage :gio
  (:use :common-lisp)
  (:export :greet :main))

(in-package :gio)

(defun greet (whom)
  "Create a greeting message for WHOM."
  (format nil "Hello, ~A." whom))


(defun main ()
  "Greet someone, or something."
  (write-line (greet (first (uiop:command-line-arguments))))

  (uiop:quit))
