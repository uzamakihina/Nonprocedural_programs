(print (fl-interp '(+ 10 5) nil))             
(print (fl-interp '(- 12 8) nil) )
(print (fl-interp '(* 5 9) nil) )
(print (fl-interp '(> 2 3) nil) )
(print (fl-interp '(< 1 131) nil) )
(print (fl-interp '(= 88 88) nil) )
(print (fl-interp '(and nil t) nil) )
(print (fl-interp '(or t nil) nil)  )
(print (fl-interp '(not t) nil) )
(print (fl-interp '(number 354) nil) )
(print (fl-interp '(equal (3 4 1) (3 4 1 )) nil) )
(print (fl-interp '(if nil 2 3) nil) )
(print (fl-interp '(null ()) nil) )
(print (fl-interp '(atom (3)) nil)  )
(print (fl-interp '(eq x x) nil)  )
(print (fl-interp '(first (8 5 16)) nil) )
(print (fl-interp '(rest (8 5 16)) nil) )
(print (fl-interp '(cons 6 3) nil) )




