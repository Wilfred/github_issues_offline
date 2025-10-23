;; https://atomized.org/blog/2020/07/06/common-lisp-in-practice/

(require :asdf)

(load "~/quicklisp/setup.lisp")

(defpackage :gio
  (:use :common-lisp)
  (:export :greet :main :read-issues-json))

(in-package :gio)

(ql:quickload '#:com.inuoe.jzon)
(sb-ext:add-package-local-nickname '#:jzon '#:com.inuoe.jzon)

(defun greet (whom)
  "Create a greeting message for WHOM."
  (format nil "Hello, ~A." whom))

(defun read-issues-json ()
  "Read the contents of src/issues.json and return it as a string."
  (uiop:read-file-string "issues.json"))

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
    :initform (error "Issue number is required."))
   (url
    :initarg :url
    :initform (error "URL is required."))
   (created-at
    :initarg :created-at
    :initform (error "created-at is required."))
   (updated-at
    :initarg :updated-at
    :initform (error "updated-at is required."))))

(defmethod print-object ((obj issue) out)
  (print-unreadable-object (obj out :type t)
    (format out "~s ~s" (slot-value obj 'number) (slot-value obj 'title))))

(defun issue-from-hash (hash)
  (make-instance
   'issue
   :title (gethash "title" hash)
   :number (gethash "number" hash)
   :url (gethash "url" hash)
   :created-at (gethash "created_at" hash)
   :updated-at (gethash "updated_at" hash)))

(defclass comment ()
  ((body
    :initarg :body
    :initform (error "Body is required."))))

(defclass user ()
  ((login
    :initarg :login
    :initform (error "Login (username) is required."))))

(defun user-from-hash (hash)
  (make-instance 'user
                 :login (gethash "login" hash)))

;; (defparameter *comments*
;;   (jzon:parse (uiop:read-file-string "comments.json")))

;; (defparameter *issues*
;;   (jzon:parse (uiop:read-file-string "issues.json")))

;; (defun hash-keys (hash)
;;   (let ((keys '()))
;;     (maphash (lambda (k v)
;;                (push k keys))
;;              hash)
;;     keys))

;; (issue-from-hash (elt *issues* 0))

(defun main ()
  "Print issues."
  (let* ((issues-path (first (uiop:command-line-arguments)))
         (issues-src (uiop:read-file-string issues-path))
         (issues-json (com.inuoe.jzon:parse issues-src)))
    (loop
      for item across issues-json
      do (write-line (format nil "item: ~A." (issue-from-hash item)))))

  (uiop:quit))
