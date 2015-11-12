(load 'hw4.l)

(defun test (received expected) (pprint (if (equal received expected) 'ok (list 'ERR 'received received ': expected 'expected))))

; test all-length
(print 'all-length)
(test (all-length '()) 0)
(test (all-length '(2 a n)) 3)
(test (all-length '((r p) a n)) 4)
(test (all-length '((r p) (a n))) 4)
(test (all-length '(p (r p) x (a n))) 6)

; test find-min
(print 'find-min)
(test (find-min '(3 3 3 4 9 7) 0) 0)
(test (find-min '(3 3 3 4 9 7) 9) 3)
(test (find-min '(9845 36 12 22 16) 9845) 12)


; test find-max
(print 'find-max)
(test (find-max '(3 3 3 4 9 7) 0) 9)
(test (find-max '(3 3 3 4 9 7) 29) 29)
(test (find-max '(9845 36 12 22 16) 12) 9845)

; test range
(print 'range)
(test (range '(3 3 3 4 9 7)) '(3 9))
(test (range '(9845 36 12 22 16)) '(12 9845))

; test before
(print 'before)
(test (before '(1 2 3 6 5 0 0 9 11 9) 6 9) '(6 5 0 0 9))
(test (before '(1 2 (3) (6 4) (0 0) 9 (5) 11 9) '(6 4) '(5)) '((6 4) (0 0) 9 (5)))
(test (before '(1 2 3 6 5 0 0 6 9 11 9) 6 6) '(6 5 0 0 6))
(test (before '(1 2 3 6 5 0 0 9 11 9) 6 6) '(6 5 0 0 9 11 9))
