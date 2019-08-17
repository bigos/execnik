;;; sbcl --load THIS-FILE

(declaim (optimize (space 0) (speed 0) (debug 3)))

(ql:quickload '(:external-program
                :cl-strings))

(defpackage #:distribution-on-windows
  (:use #:cl))

(in-package #:distribution-on-windows)

(defparameter mingw-path #p "c:/msys64/mingw64/")
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


(external-program:run "mkdir"  '("distro"))
(external-program:run "mkdir"  '("distro/bin"))
(external-program:run "cp"  '("execnik.exe" "distro/bin/"))

(loop for dll in  mingw-list do
  (external-program:run "cp" (list dll "distro/bin")))

(external-program:run "mkdir"  '("distro/share"))
(external-program:run "mkdir"  '("distro/share/glib-2.0"))
(external-program:run "mkdir"  '("distro/share/glib-2.0/schemas"))

(external-program:run "mkdir"  '("distro/share/icons"))
(external-program:run "mkdir"  '("distro/share/icons/Adwaita"))
(external-program:run "mkdir"  '("distro/share/icons/hicolor"))

(defun source-wild-path (project wild path )
  (let ((cs (if wild
                "~A~A/*"
                "~A~A/")))
      (format nil cs project path)))

(external-program:run "cp" (list (source-wild-path mingw-path T "share/glib-2.0/schemas")
                                 (source-wild-path project-path nil "distro/share/glib-2.0/schemas")))
(external-program:run "cp" (list (source-wild-path mingw-path T "share/icons/Adwaita")
                                 (source-wild-path project-path nil "distro/icons/Adwaita")))
(external-program:run "cp" (list (source-wild-path mingw-path T "share/icons/hicolor")
                                 (source-wild-path project-path nil "distro/icons/hicolor")))

(format t "~&Done!~%")
(sb-ext:exit)
