; By Joe Xu
; 1472886
; CMPUT 325 section B1
; Assighnmnet 2

; get length of a list L
(defun L_Size (L)
  (if (null L)
    0
    (+ 1 (L_Size (cdr L)))))

; get the params or arguments of a program named f with a specific arg size from program list
; for example f = 'xor, size = 2, P = '((xor (x y) = (if (equal x y) nil t)))) 
; this will return (x y)
(defun program_params (f size P)
    (cond 
      ((null (caar p)) nil )
      ((equal f (caar p) ) 
          (if (eq size (L_Size (cadr (car p))) )  
            (cadr (car p)) 
            (program_params f size (cdr p)))    )
      (t (program_params f size (cdr p)) )))


; get the body of a program named f with a specific arg size from program list
; for example f = 'xor, size = 2, P = '((xor (x y) = (if (equal x y) nil t)))) 
; this will return (if (equal x y) nil t)
(defun get_Pbody (f size p)
  (cond 
      ((null (caar p)) nil )
      ((equal f (caar p) ) 
          ( if (eq size (L_Size (cadr (car p))) )  
            (cadddr (car p)) 
            (get_Pbody f size (cdr p)))    )
      (t (get_Pbody f size (cdr p)) )))



; for a body, replace all the x with value then return it
; for example if x = y value = 4 body = (* y (+ c y))
; then this will return (* 4 (+ c 4))
(defun subs_params (x value body) 
    (cond
    ((null body ) nil )
    ((null (atom (car body ) ) ) ( cons (subs_params x value (car body)) (subs_params x value (cdr body)) )  ) 
    ((equal (car body) x ) ( cons value (subs_params x value (cdr body)) )  )
    (t ( cons (car body) (subs_params x value (cdr body)) ) )

    ))

; calls sub_params untill every x has been replaced by every value in the body 
; so if you had x = (w v) value = (1 2) and body = (+ w v)
; the function will call itself to solve recursively to get (+ w 2)
; then it will call sub params with x = w value = 1 body = (+ w 2)
; which returns +( 1 2)
(defun subs (x value body)
    (if (null (cdr x)) 
        (subs_params (car x) (car value) body )  
        (subs_params (car x) (car value) (subs (cdr x) (cdr value) body ))))


; takes a list and calles fl-interp to solve each element in it
; for example if args = ( 3 4 (+ 3 4) (list 3) )
; it will return (3 4 7 (3))
(defun solve_args (args P)
    (cond 
        ((null args) nil)
        ((atom (car args)) (cons (car args) (solve_args (cdr args) P)))
        (t (cons (fl-interp (car args) P) (solve_args (cdr args) P)))))


; Takes and expression and program and solves the expresstion by replacing equals with
; equals from the program list. This does it using applicative order reduction so 
; for any user defined expression f (a b c d) it first solves the args (a b c d) by calling 
; fl-interp on each element in the args. Then solves itself by replaceing equals with equals from the
; program list P where f = program name AND size of arguments = size of program arguments
( defun fl-interp (E P)
  (cond 
	((atom E) E)  
        (t
            (let ( (f (car E))  (arg (cdr E)) )
	            (cond 
                    ; solves for primitive functions
                    ((eq f '<) (< 
                        (fl-interp (car arg) P)
                        (fl-interp (cadr arg) P) ))
                    ((eq f '>) (> 
                        (fl-interp (car arg) P)
                        (fl-interp (cadr arg) P)))
                    ((eq f '=) (= 
                        (fl-interp (car arg) P)
                        (fl-interp (cadr arg) P)))
                    ((eq f '+) (+
                        (fl-interp (car arg)P)
                        (fl-interp (cadr arg)P)))
                    ((eq f '-) (-
                        (fl-interp (car arg)P)
                        (fl-interp (cadr arg)P)))
                    ((eq f '*) (*
                        (fl-interp (car arg)P)
                        (fl-interp (cadr arg)P)))
                    ((eq f 'eq) (eq
                        (fl-interp (car arg)P)
                        (fl-interp (cadr arg)P)))
                    ((eq f 'if) (if (fl-interp (car arg) P) 
                        (fl-interp (cadr arg) P) 
                        (fl-interp (caddr arg) P)))
                    ((eq f 'cons)(cons 
                        (fl-interp (car arg)P)
                        (fl-interp (cadr arg)P)))
                    ((eq f 'and)(and
                        (fl-interp (car arg)P)
                        (fl-interp (cadr arg)P)))
                    ((eq f 'or) (or 
                        (fl-interp (car arg)P)
                        (fl-interp (cadr arg)P)))
                    ((eq f 'equal) (equal 
                        (fl-interp (car arg)P)
                        (fl-interp (cadr arg)P)))
                    ((eq f 'not)  (not (fl-interp (car arg) P)))
                    ((eq f 'first)  (car (fl-interp (car arg) P)))
                    ((eq f 'rest) (cdr (fl-interp (car arg) P)))
                    ((eq f 'null) (null (fl-interp (car arg) P)))
                    ((eq f 'atom) (atom (fl-interp (car arg) P)))
                    ((eq f 'number) (numberp (fl-interp (car arg) P)))

                    ;Solves for user defined functions  
                    ( t 
                        ; if it is not a user defeind function either then return E
                        (if (null (get_Pbody f (L_Size arg) P))       
                            E
                            ; solve arg and then start replacing the variables with the values in the body
                            (fl-interp 
                                (subs (program_params f (L_Size arg) P ) 
                                    (solve_args arg P) 
                                    (  get_Pbody f (L_Size arg) P )) P )   )))))))



	       
