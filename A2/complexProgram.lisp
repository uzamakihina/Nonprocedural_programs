(print (fl-interp '(last (s u p)) '((last (x) = (if (null (rest x)) (first x) (last (rest x))))))                                     )
(print (fl-interp '(push (1 2 3) 4) '((push (x y) = (if (null x) (cons y nil) (cons (first x) (push (rest x) y)))))) )
(print (fl-interp '(pop (1 2 3)) '((pop (x) = (if (atom (rest (rest x))) (cons (first x) nil) (cons (first x) (pop (rest x))))))) )
(print (fl-interp '(power 4 2) '((power (x y) = (if (= y 1) x (power (* x x) (- y 1)))))) )
(print (fl-interp '(factorial 4) '((factorial (x) = (if (= x 1) 1 (* x (factorial (- x 1))))))) )
(print (fl-interp '(divide 24 4) '((divide (x y) = (div x y 0)) (div (x y z) = (if (> (* y z) x) (- z 1) (div x y (+ z 1))))))  )










