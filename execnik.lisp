;;;; execnik.lisp
(declaim (optimize (safety 2) (debug 3)))

(in-package #:execnik)

(defun run ()
  (sb-int:with-float-traps-masked (:divide-by-zero)
    (within-main-loop
      (let ((window (make-instance 'gtk-window :title "Execnik-window"
                                               :default-width 580
                                               :default-height 200
                                               :border-width 12
                                               :type :toplevel)))

        (g-signal-connect window "destroy"
                          (lambda (widget)
                            (declare (ignorable widget))
                            (format t "QUITTING~%")
                            (leave-gtk-main)))

        (gtk-widget-show-all window)))
    ;; compiled program will not work on Windows without the following
    (join-gtk-main)))
