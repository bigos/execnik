;;; sbcl --load THIS-FILE

(defparameter project-path
  (uiop/os:getcwd))

(defparameter exec-name
  (if (equalp :OS-WINDOWS (uiop/os:detect-os))
      "execnik.exe"
      "execnik"))

(push
 project-path
 asdf:*central-registry*)

(ql:quickload :execnik)
(in-package :execnik)

(if (equalp :OS-WINDOWS (uiop/os:detect-os))
    (sb-ext:save-lisp-and-die
     (merge-pathnames common-lisp-user::project-path
                      common-lisp-user::exec-name)
     :toplevel #'run
     :executable T
     :application-type :gui)            ; windows may need this one

    (sb-ext:save-lisp-and-die
     (merge-pathnames common-lisp-user::project-path
                      common-lisp-user::exec-name)
     :toplevel #'run
     :executable T))
