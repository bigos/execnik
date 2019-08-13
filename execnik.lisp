;;;; execnik.lisp
(declaim (optimize (safety 2) (debug 3)))

(in-package #:execnik)

(defun run ()
  (format t "running RUN~%")

  (sb-int:with-float-traps-masked (:divide-by-zero)
    (format t "a ~%")
    (within-main-loop
      (format t "b ~%")
      (let ((window (progn
                      (format t "going to build window~%")
                      (make-instance 'gtk-window :title "Execnik-window"
                                                 :default-width 580
                                                 :default-height 200
                                                 :border-width 12
                                                 :type :toplevel)))
            (zzz (progn (format t "after window building~%"))))
        (format t "window is ~A~%" window)

        (g-signal-connect window "destroy"
                          (lambda (widget)
                            (declare (ignorable widget))
                            (format t "QUITTING~%")
                            (leave-gtk-main)))
        (format t "c ~%")
        (gtk-widget-show-all window)
        (format t "d ~%"))))

  (format t "after RUN~%"))
