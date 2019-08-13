;;; sbcl --load THIS-FILE

(push
 #p "c:/Users/Jacek/Documents/Programming/Lisp/execnik/"
 asdf:*central-registry*)

(ql:quickload :execnik)
(in-package :execnik)

;; ;; (sb-ext:disable-debugger)

(sb-ext:save-lisp-and-die
 #p "c:/Users/Jacek/Documents/Programming/Lisp/execnik/execnik.exe"
 :toplevel #'run
 :executable T
 :application-type :gui)
