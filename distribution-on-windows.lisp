;;; sbcl --load THIS-FILE

(declaim (optimize (space 0) (speed 0) (debug 3)))

(ql:quickload '(:external-program
                :cl-strings))

(defpackage #:distribution-on-windows
  (:use #:external-program #:cl))

(in-package #:distribution-on-windows)

;;; assuming we started Emacs from cmdlauncher.cmd in the projects path
(defparameter project-path (uiop/os:getcwd))
(defparameter mingw-path #p "c:/msys64/mingw64/")
(defparameter *distribution-folder* "execnik_for_windows")
(defparameter *output*
  (with-output-to-string (out)
    ;; when we have execnik.exe running we can query it for used libraries
    (external-program:run "Listdlls64.exe" '("execnik.exe")
                          :output out)))

(defun quit-on-regular-terminal ()
  (unless (sb-ext:posix-getenv "INSIDE_EMACS")
    (format t "~&Quitting...~%")
    (sb-ext:exit)))

(defun distribution-path (path)
  (if path
      (format nil "~A/~A" *distribution-folder* path)
      (format nil "~A" *distribution-folder*)))

(defun source-wild-path (project wild path )
  (let ((cs (if wild
                "~A~A/*"
                "~A~A/")))
    (format nil cs project path)))


(if  (search "No matching processes were found" *output*)
     (progn
       (format t "~%~%Please start execnik.exe and do not close until we find used libraries")
       (quit-on-regular-terminal))
     (progn
       (format t "~%~%Going to read the libraries used...")
       (let* ((string-list (uiop:split-string *output*
                                              :separator '(#\Return #\Newline)))
              (preceding-path-length 10)
              (mingw-list (loop for e in string-list
                                for found-index = (search "mingw64" e)
                                when found-index
                                  collect (subseq e (- found-index preceding-path-length)))))

         (run "rm"  (list "-r" (distribution-path nil)))

         (run "mkdir"  (list (distribution-path nil)))
         (run "mkdir"  (list (distribution-path "bin")))
         (run "cp"  (list "execnik.exe" (distribution-path "bin/")))

         (loop for dll in  mingw-list do
           (run "cp" (list dll (distribution-path "bin"))))

         (run "mkdir"  (list (distribution-path "share")))
         (run "mkdir"  (list (distribution-path "share/glib-2.0")))
         (run "mkdir"  (list (distribution-path "share/glib-2.0/schemas")))

         (run "mkdir"  (list (distribution-path "share/icons")))
         (run "mkdir"  (list (distribution-path "share/icons/Adwaita")))
         (run "mkdir"  (list (distribution-path "share/icons/hicolor")))

         (when nil                      ; we do not copy icons
           (format T "~&copying icons...~%")
           (run "cp" (list "-r" (source-wild-path mingw-path T "share/glib-2.0/schemas")
                             (source-wild-path project-path nil (distribution-path "share/glib-2.0/schemas/"))))
           (run "cp" (list "-r" (source-wild-path mingw-path T "share/icons/Adwaita")
                             (source-wild-path project-path nil (distribution-path "share/icons/Adwaita/"))))
           (run "cp" (list "-r" (source-wild-path mingw-path T "share/icons/hicolor")
                             (source-wild-path project-path nil (distribution-path "share/icons/hicolor/")))))

         (format t "~&Done!~%")

         (quit-on-regular-terminal))))
