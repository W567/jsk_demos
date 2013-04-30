(defun sweep-under-table-yukizaki ()
  ;;$B%b%C%W$rDO$_D>$9(B


  (when debug
  (r2p)
  (setq z-axis-inversed-p
        (let ((r (send (send *pr2* :larm :end-coords) :rotate-vector #f(0 0 1))))
          (if (> (elt r 2) 0) t nil)))
  (setq z-axis (if z-axis-inversed-p 0
                 180))
  (send *ri* :stop-grasp :rarm)
  (send *pr2* :reset-pose)
  (send *pr2* :inverse-kinematics
        (make-coords :pos (send *pr2* :transform-vector #f(800 600 900)) :rpy (float-vector 0 0 (deg2rad z-axis)))
        :rotation-axis t
        :move-target (send *pr2* :larm :end-coords)
        :use-torso t
        :debug-view nil)
  (send *pr2* :head :look-at (send *pr2* :larm :end-coords :worldpos))
  (p2r)
  (send *ri* :wait-interpolation)


  (send *ri* :stop-grasp :larm)
  (unix::sleep 2)
  (send *ri* :wait-interpolation)
  (send *pr2* :larm :move-end-pos #f(-500 0 0))
  (p2r)
  (send *ri* :wait-interpolation)
  (send *ri* :start-grasp :larm)
  (send *ri* :wait-interpolation)
)



  ;;sweep under table
  (let ((i 0))
    (loop
     (if (= i 3) (return i))
     (setq i (+ i 1))
     ;;   (send *pr2* :angle-vector start-sweep)
     (send *pr2* :inverse-kinematics
           (make-coords :pos (send *pr2* :transform-vector #f(140 600 700)) :rpy (float-vector -0.2 -0.4 (deg2rad z-axis)))
           :rotation-axis t
           :move-target (send *pr2* :larm :end-coords)
           :link-list (send *pr2* :link-list
                            (send *pr2* :larm :end-coords :parent)
                            (send *pr2* :torso_lift_link))
           :debug-view nil)
     (send *pr2* :head :look-at (send *pr2* :larm :end-coords :worldpos))
     (p2r)
     (send *ri* :wait-interpolation)
     ;;   (send *pr2* :angle-vector end-sweep)
     (send *pr2* :inverse-kinematics
           (make-coords :pos (send *pr2* :transform-vector (float-vector 640 (- 500 (* 150 i)) 500)) :rpy (float-vector 0 -0.7 (deg2rad z-axis)))
           :rotation-axis t
           :move-target (send *pr2* :larm :end-coords)
           :link-list (send *pr2* :link-list
                            (send *pr2* :larm :end-coords :parent)
                            (send *pr2* :torso_lift_link))
           :debug-view nil)
     (send *pr2* :head :look-at (send *pr2* :larm :end-coords :worldpos))
     (p2r)
     (send *ri* :wait-interpolation)
     ))


  ;;$BN><j$G(B
  ;;make broom model
  (setq *broom2* (room73b2-broom))
  (objects (list *pr2* *broom2*))
  (send *pr2* :assoc *broom2*)
  (send *broom2* :locate #f(600 0 500) :parent)
  (send *broom2* :orient (deg2rad 0) :y :parent)
  ;;$B<j<s$r@5$7$/(B
  (setq *handle-l* (make-coords :coords (send (car (send *broom2* :handle)) :worldcoords)))
  (send *handle-l* :rotate (deg2rad z-axis) :x)

  ;;$B:8<j$rA0$K(B
  (send *pr2* :reset-pose)
  (send *pr2* :inverse-kinematics
        *handle-l*
        :rotation-axis t
        :move-target (send *pr2* :larm :end-coords)
        :use-torso t
        :debug-view nil)
  (p2r)
  (send *ri* :wait-interpolation)

  (send *broom2* :locate #f(600 0 0) :parent)
  (setq *handle-l* (make-coords :coords (send (car (send *broom2* :handle)) :worldcoords)))
  (send *handle-l* :rotate (deg2rad z-axis) :x)
  (send *pr2* :reset-pose)
  (send *pr2* :inverse-kinematics
        *handle-l*
        :rotation-axis t
        :move-target (send *pr2* :larm :end-coords)
        :use-torso t
        :debug-view nil)
  (p2r)
  (send *ri* :wait-interpolation)
  ;;$B1&<j$r3+$$$FA0$K(B
  (send *ri* :stop-grasp :rarm)
  (send *ri* :wait-interpolation)
  (unix::sleep 2)
  (send *pr2* :inverse-kinematics
        (car (cdr (send *broom2* :handle)))
        :rotation-axis t
        :move-target (send *pr2* :rarm :end-coords)
        :use-torso t
        :debug-view nil)
  (send *pr2* :rarm :move-end-pos #f(60 0 0))
  (p2r)
  (send *ri* :wait-interpolation)
  (unix:sleep 2)

  ;;$B1&<j$G$D$+$`(B
  (send *ri* :start-grasp :rarm)
  (unix:sleep 5)

  ;;$B:8<jDO$_D>$7(B
  (send *ri* :stop-grasp :larm)
  (send *pr2* :larm :move-end-pos #f(-200 0 0))
  (p2r)
  (send *ri* :wait-interpolation)
  (unix:sleep 2)
  (send *pr2* :inverse-kinematics
        (car (send *broom2* :handle))
        :rotation-axis t
        :move-target (send *pr2* :larm :end-coords)
        :use-torso t
        :debug-view t)
  (p2r)
  (send *ri* :wait-interpolation)
  (unix:sleep 2)
  (send *ri* :start-grasp :larm)
  (unix:sleep 5)

  (send *broom2* :locate #f(900 0 0) :parent)
  (send *broom2* :orient (deg2rad -30) :y :parent)
  ;;sweep start
  (send *pr2* :reset-pose)
  (send *pr2* :inverse-kinematics
        (car (cdr (send *broom2* :handle)))
        :rotation-axis t
        :move-target (send *pr2* :rarm :end-coords)
        :use-torso t
        :debug-view nil)
  (send *pr2* :inverse-kinematics
        (car (send *broom2* :handle))
        :rotation-axis t
        :move-target (send *pr2* :larm :end-coords)
        :use-torso t
        :debug-view nil)
  (p2r)
  (send *ri* :wait-interpolation)

  (send *broom2* :locate #f(1200 0 -150) :parent)
  (send *broom2* :orient (deg2rad -55) :y :parent)
  ;;sweep end
  (send *pr2* :reset-pose)
  (send *pr2* :inverse-kinematics
        (car (cdr (send *broom2* :handle)))
        :rotation-axis t
        :move-target (send *pr2* :rarm :end-coords)
        :use-torso t
        :debug-view nil)
  (send *pr2* :inverse-kinematics
        (car (send *broom2* :handle))
        :rotation-axis t
        :move-target (send *pr2* :larm :end-coords)
        :use-torso t
        :debug-view nil)
  (p2r)
  (send *ri* :wait-interpolation)

  )