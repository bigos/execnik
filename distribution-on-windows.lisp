;;; sbcl --load THIS-FILE

(declaim (optimize (space 0) (speed 0) (debug 3)))

(ql:quickload '(:external-program
                :cl-strings))

(defpackage #:distribution-on-windows
  (:use #:cl))

(in-package #:distribution-on-windows)

(defparameter project-path (uiop/os:getcwd))

(format t "project path is ~A~%" project-path)

(defparameter *output*
  (with-output-to-string (out)
    ;; run command with parameters as list of strings
    (external-program:run "Listdlls64.exe" '("execnik.exe")
                          :output out)))
(if  (search "No matching processes were found" *output*)
     (format t "~%~%Please start execnik.exe and do not close until we find used libraries")
     (format t "~%~%Going to read the libraries used"))

(defparameter mingw-list
  (let ((string-list (uiop:split-string *output*
                                        :separator '(#\Return #\Newline)))
        (preceding-path-length 10))
    (loop for e in string-list
          for found-index = (search "mingw64" e)
          when found-index
            collect (subseq e (- found-index preceding-path-length)))))


(external-program:run "mkdir"  '("distro") :output *standard-output*)
(external-program:run "mkdir"  '("distro/bin") :output *standard-output*)
(external-program:run "cp"  '("execnik.exe" "distro/bin/") :output *standard-output*)

(loop for dll in  mingw-list do
  (external-program:run "cp" (list dll "distro/bin")))
