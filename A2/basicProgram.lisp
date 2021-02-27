(print (fl-interp '(greater 3 5) '((greater (x y) = (if (> x y) x (if (< x y) y nil)))))  )
(print (fl-interp '(square 4) '((square (x) = (* x x))))  )
(print (fl-interp '(simpleinterest 4 2 5) '((simpleinterest (x y z) = (* x (* y z)))))  )
(print (fl-interp '(xor t nil) '((xor (x y) = (if (equal x y) nil t)))) )
(print (fl-interp '(cadr (5 1 2 7)) '((cadr(x) = (first (rest x))))) )









