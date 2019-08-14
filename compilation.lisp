;;; sbcl --load THIS-FILE

(defparameter project-path (uiop/os:getcwd))

;;; load the project
(push project-path asdf:*central-registry*)
(ql:quickload :execnik)

;;; change to the project's package
(in-package :execnik)

;;; depending on OS choose compilation options
(if (equalp :OS-WINDOWS (uiop/os:detect-os))
    ;; Windows
    (sb-ext:save-lisp-and-die
     (merge-pathnames common-lisp-user::project-path
                      "execnik.exe")
     :toplevel #'run
     :executable T
     :application-type :gui)            ; windows may need this one

    ;; Linux
    (sb-ext:save-lisp-and-die
     (merge-pathnames common-lisp-user::project-path
                      "execnik")
     :toplevel #'run
     :executable T))
