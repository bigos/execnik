;;;; execnik.asd

(asdf:defsystem #:execnik
  :description "Describe execnik here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-cffi-gtk)
  :components ((:file "package")
               (:file "execnik")))
