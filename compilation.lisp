;;; sbcl --load THIS-FILE

(push
 #p "c:/Users/Jacek/Documents/Programming/Lisp/execnik/"
 asdf:*central-registry*)

(ql:quickload :execnik)
;; (in-package :execnik)

;; ;; (sb-ext:disable-debugger)

;; (sb-ext:save-lisp-and-die
;;  #p "c:/Users/Jacek/Documents/Programming/Lisp/execnik/execnik.exe"
;;  :toplevel #'run
;;  :executable T
;;  :application-type :console
;;  )

(require :asdf)

(defmethod asdf:output-files ((o asdf:program-op)
                              (s (eql (asdf:find-system :execnik))))
  (let ((exe-path (uiop/os:getcwd)))
    (if exe-path
        (values (list (concatenate 'string (directory-namestring exe-path) "execnik2.exe")) t)
        (call-next-method))))

(asdf:operate :program-op :execnik)
