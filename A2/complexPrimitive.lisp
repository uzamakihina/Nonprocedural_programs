(print (fl-interp '(+ (* 2 2) (* 2 (- (+ 2 (+ 1 (- 7 4))) 2))) nil)                                                                          )
(print (fl-interp '(and (> (+ 3 2) (- 4 2)) (or (< 3 (* 2 2)) (not (= 3 2)))) nil) )
(print (fl-interp '(or (= 5 (- 4 2)) (and (not (> 2 2)) (< 3 2))) nil) )
(print (fl-interp '(if (not (null (first (a c e)))) (if (number (first (a c e))) (first (a c e)) (cons (a c e) d)) (rest (a c e))) nil) )






