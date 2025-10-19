;; https://atomized.org/blog/2020/07/06/common-lisp-in-practice/

(require :asdf)

(defpackage :gio
  (:use :common-lisp)
  (:export :greet :main :read-issues-json))

(in-package :gio)

(defun greet (whom)
  "Create a greeting message for WHOM."
  (format nil "Hello, ~A." whom))

(defun read-issues-json ()
  "Read the contents of src/issues.json and return it as a string."
  (uiop:read-file-string
   "issues.json"))

(defun all-issues ()
  ;; https://github.com/Zulu-Inuoe/jzon/
  (jzon:parse (read-issues-json)))

;; https://gigamonkeys.com/book/object-reorientation-classes
(defclass issue ()
  ((title
    :initarg :title
    :initform (error "Title is required."))
   (number
    :initarg :number
    :initform (error "Issue number is required."))))

(defmethod print-object ((obj issue) out)
  (print-unreadable-object (obj out :type t)
    (format out "~s ~s" (slot-value obj 'number) (slot-value obj 'title))))

(make-instance 'issue :title "hello" :number 123)

(defun main ()
  "Greet someone, or something."
  (write-line (greet (first (uiop:command-line-arguments))))

  (uiop:quit))
