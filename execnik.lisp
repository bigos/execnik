;;;; execnik.lisp

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
                           (leave-gtk-main)))
       (gtk-widget-show-all window)))))
