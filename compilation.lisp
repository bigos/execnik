;;; sbcl --load THIS-FILE

(defparameter project-path
  (uiop/os:getcwd))

(defparameter exec-name
  (if (equalp :OS-UNIX (uiop/os:detect-os))
      "execnik"
      "execnik.exe"))

(push
 project-path
 asdf:*central-registry*)

(ql:quickload :execnik)
(in-package :execnik)

(if (equalp :OS-UNIX (uiop/os:detect-os))
    (sb-ext:save-lisp-and-die
     (merge-pathnames common-lisp-user::project-path
                      common-lisp-user::exec-name)
     :toplevel #'run
     :executable T)

    (sb-ext:save-lisp-and-die
     (merge-pathnames common-lisp-user::project-path
                      common-lisp-user::exec-name)
     :toplevel #'run
     :executable T
     :application-type :gui)) ; windows may need this one
