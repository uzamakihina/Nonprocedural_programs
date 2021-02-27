; By Joe Xu
; 1472886
; CMPUT 325 section B1
; Assighnmnet 1

; QUESTION 1
; This functions takes an atom and a list and returns true if the 
; atom is in the list or nil if it is not
; It does this by comparing each atom in the item. If any matches then return true
(defun xmember (item item_list)
    (if (null item_list) nil 
        ( if (equal (car item_list) item) 
            t 
            (xmember item (cdr item_list)) )) )



; QUESTION 2
; This functions takes a list and returns a list that contains only 
; the atoms of the incoming list 
; It works by cons'ing each element to a list to return, if that element is a atom add it then move 
; to the cdr recursive call. If it is a list then call itself on that element 
; and append that list to the cdr recursive call
(defun flatten (incomming_list)
    (if (null incomming_list) 
        nil
        (if ( atom (car incomming_list) ) 
            ( cons (car incomming_list) (flatten (cdr incomming_list) )  ) 
            ( append (flatten (car incomming_list)) (flatten (cdr incomming_list)) ))))


    
; QUESTION 3
; This function takes in a list and removes all the duplicate elements in its list 
; It does this by reconstructing a list where it calls xmember on each element in the list
; if xmember returns true then dont add it to the new list, if it returns false then add 
; it to the new list because there is only one of it
(defun remove-duplicate (x)
    (cond 
        ( (null x) '())
        ( (xmember (car x) (cdr x))  (remove-duplicate (cdr x)) )
        ( t (cons (car x) (remove-duplicate (cdr x)) ))))



; QUESTION 4
; returns a list that is a alternating mix of L1 and L2 starting from L1
; It does this by creating a list that adds the first atom of L1 then next L2
; if L1 or L2 is empty then just add from the other
; for example (mix '(a b c) '(d e)) => (a d b e c)
(defun mix_helper (L1 L2 turn)
    (cond ( (and (null L1) (null L2))  '() )                       ; if both empty return nil
          ( (null L1) (cons (car L2) (mix_helper L1 (cdr L2) 1) )) ; if L1 is empty add from L2 
          ( (null L2) (cons (car L1) (mix_helper (cdr L1) L2 2) )) ; if L2 is empty add from L1
          ( t( if ( eq turn 1 )                                    ; add from whoevers turn it is from the variable turn
                (cons (car L1) (mix_helper (cdr L1) L2 2)  )
                (cons (car L2) (mix_helper L1 (cdr L2) 1)  )))))
            
; Calls the helper function to do the task because we need an extra parameter to keep track
; of which list to add from next
(defun mix (L1 L2)
    (mix_helper L1 L2 1))



; QUESTION 5
; gets every combanation of an element and list0
; since element is just 1 element, we just append the single element to every element in list0
; for example gen_combanations (a) ((b) (c d)) => ((a b) (a c d))
(defun gen_combanations (element list0 )
    (if (null (cdr list0))
        (list (append element (car list0) ))
        (cons (append element (car list0) )    
            (gen_combanations element (cdr list0) ))))

; takes a list of atoms and puts every one of those atoms in their own list
; for example (a b c ) => ((a) (b) (c))
(defun turn_list (L)
    (if (null (car L)) 
        nil
        (cons (list (car L)) (turn_list(cdr L) ))))

; get all the subsets of L by appending (car L ) to ( every combanation of (car L) and ( subsets (cdr L)) )  then to (cdr L)
; for example if L was ( (a) (b) (c) )  
;    (car L) = ((a)) +
;    (combanations of (car L) and (subsets (cdr L))) = ((a b) (a c) (a b c)) +
;    (cdr L) = ( (b) (c) ) =
;    ( (a) (a b) (a c) (a b c) (b) (c))
(defun getsubsets (L)
    (cond
        ( (null (car L)) '() ) 
        ( (null (cdr L) )  L )
        ( t (append 
                (list (car L) )
                (gen_combanations (car L) (getsubsets (cdr L)) ) 
                (getsubsets (cdr L) )))))

; get all subsets by wrapping all of the elements in a list then generating 
; all the subsets using the getsubsets function then add nil because the empty set is in all subsets
; putting them in a list makes it easier combine sets together
(defun allsubsets (L)
    (cons nil (getsubsets (turn_list L)) ))



; QUESTION 6 reached
; returns all the websites that can be reached by 1 link from the accessed list
; this is done by iterating through every pair in all_websites and appending the second atom 
; of the pair to a list to be returned. This is done by using xmember to see if the first of the pair is 
; in the accessed list
(defun get_matches (accessed all_websites)
    (if (null (car all_websites))
        nil
        (if (xmember (caar all_websites) accessed )
            (cons (cadar all_websites) (get_matches accessed (cdr all_websites)) )   
            (get_matches accessed (cdr all_websites)))))

; this function removes atom x from list L
(defun remove_atom (x L)
    (if (null (car L))
        '()
        (if (equal (car L) x)
            (cdr L)
            (cons (car L) (remove_atom x (cdr L)) ))))

; this function gets the length of a list
(defun get_length (L) 
    (if ( null ( car L )  ) 
        0
        (+ 1 (get_length (cdr L) ) )))
    
; iterates throught the list and appends the sites it can access to the accessed list, 
; if the accessed list got bigger call itself and do it again with new accessed list
; if there is no change in the accessed list size then return the accessed list
; for example reached_helper '(a) '( (b c) (a b)) makes (a b)
; then we again call reached_helper '(a b) '((b c) (a b)) which makes (a b c)
; we again call reached_helper '(a b c) '( (b c) (a b)) since there is no change in accessed we return it
(defun reached_helper (accessed websites)
    (if (= (get_length accessed)  (get_length (remove-duplicate ( append accessed (get_matches accessed websites) ))))
        accessed
        ( reached_helper (remove-duplicate (append accessed (get_matches accessed websites))) websites )))

; calculates all websites reached by using reached_helper which returns a list of all the sites
; x can reach then remove itself from that list
(defun reached (x L)
    (remove_atom x (reached_helper (list x) L)))



; QUESTION 6 Rank
; Gets the rank of website x
; This is done by counting the rank of a single website by comparing if the website name matches the second of a pair
; and that the initial website linking isnt itself. If so increase rank by one move on to the next website pair
(defun count_rank (x websites)
    (cond
        ( (null ( car websites )) 0 )
        ( (equal x (caar websites)) (count_rank x (cdr websites))  )   
        ( (equal (cadar websites ) x ) (+ 1 (count_rank x (cdr websites)) )  )
        ( t (count_rank x (cdr websites)) )))

; gets the ranking of all websites and their ranks into a list
; This is done by recursivly calling count_rank on each website then returning a list of those (website rank) pairs 
(defun get_rank_list (websites web_links )
    (cond 
        ((null (car websites)) '())
        (t  ( append  (list (cons (car websites) ( list ( count_rank (car websites) web_links ))))
                (get_rank_list (cdr websites) web_links )  ))))

; greater than function used in sort
(defun greaterThan (L1 L2)
    (> (cadr L1 ) (cadr L2) ))

; detaches the second item in a list of pairs
; for example detach_second ( (a b) (c d) (r e)) => (a c r)
( defun detach_second (L) 
    (if (null(cdr L)) 
        (list (caar L)) 
        (cons (caar L) (detach_second (cdr L)) )))

; From a list of website linkages, gets a permutation S such that they are orderd from who is reffered to the most
; This is done by getting a list of website names and their rank number as pairs, then sorts them
; then removes the number so its just a list of website names in order
(defun rank ( S L)
    ( detach_second (sort (get_rank_list S L) 'greaterThan) ) )
    


