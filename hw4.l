; The lisp function length counts the number of elements in the top level of a list. Write a function,
; all-length, that takes a list and counts the number of atoms that occur in a list at all levels.
(defun all-length (lst)
	(cond
		((null lst)  0)
		((atom lst)  1)
		((listp lst) (+ (all-length (car lst)) (all-length (cdr lst))))))

; Define a function range that takes a list of numbers (with at least one element) and returns a list of
; length 2 of the smallest and largest numbers.
(defun range (lst)
	(list (find-min lst (car lst)) (find-max lst (car lst))))

; Takes a list of numbers and an element (treated as if it were a member of that list).
; Returns the min value of the list (or the argument min).
(defun find-min (lst min)
	(if (null lst)
		min
		(find-min ; recurse
			(cdr lst)
			(if (< min (car lst)) min (car lst))))) ; min < lst[0] ? min : lst[0]

(defun find-max (lst max)
	(if (null lst)
		max
		(find-max ; recurse
			(cdr lst)
			(if (> max (car lst)) max (car lst))))) ; max > lst[0] ? max : lst[0]

; Write a function before that searches a list and returns a list of all elements in between the first two
; arguments (inclusive).
; 
; If only the first argument appears in the list, before returns a list containing all the elements from the
; first occurrence of the first argument to the end of the list.
(defun before (start finish lst)
	(if (equal start (car lst))
		(cons start (until (cdr lst) finish))
		(before start finish (cdr lst))))

; Support function for before. Returns a list containing all elements from the beginning of lst to finish (inclusive).
(defun until (lst finish)
	(cond 
		((null lst) nil) ; empty list
		((equal (car lst) finish) (list finish)) ; matches finish
		(t (cons (car lst) (until (cdr lst) finish))))) ; recurse

; Write a function split-if that returns a list into two parts. It takes two arguments: a function (f) and
; a list. All members for which f is true go into one list, and the rest go into another list.
(defun split-if (f lst)
	(list (filter (lambda (x) (not (funcall f x))) lst) (filter f lst)))

; Support function for split-if. Returns a list containing all elements of lst for which function f returns truthy.
(defun filter (f lst)
	(cond
		((null lst) nil) ; input is empty: return empty
		((funcall f (car lst)) (cons (car lst) (filter f (cdr lst))))
		(t (filter f (cdr lst)))))

; Write a function group that takes arguments: a list l and a number n. It returns a new list in which the
; elements of l are grouped into sublists of length n. The remainder is put in a final sublist.
(defun group (lst n)
	(group-rec n lst nil))

; Support for group. 
(defun group-rec (n src dst)
	(if (null src) dst
		(let ((accumulate_return (accumulate-n n src nil)))
			(group-rec n (car accumulate_return) (append dst (cdr accumulate_return))))))

(defun accumulate-n (n src dst)
	(if (or (null src) (eq n 0))
		(list src dst)
		(accumulate-n (1- n) (cdr src) (append dst (list (car src))))))


; Write a function mostn that takes two arguments: a function f and a list l. It returns a list of all elements
; for which the function yields the highest score (along with the score itself), where score the value returned
; from the given function:
	; > (mostn #’length ’((a b) (a b c) (a) (e f g)))
	; ( ((A B C) (E F G)) 3)
(defun mostn (f l)
	(mostn-helper f l dst hiscore))

; Support mostn. Does all the heavy lifting.
(defun mostn-helper (f src dst hiscore)
	(if (null src) (list dst hiscore)
		(let* ((item (car src)) (itemscore (funcall f item)))
			(cond
				((> itemscore hiscore) ; change hiscore, replace dst
					(mostn-helper f (cdr src) (list item) itemscore))
				((= itemscore hiscore)
					(mostn-helper f (cdr src) (append dst (list item)) hiscore))
				(t
					(mostn-helper f (cdr src) dst hiscore))
			))))

; Write a function match that compares a pattern and an assertion. When a pattern containing no special
; atoms is compared to an assertion, the two match only if they are exactly the same, with each corresponding
; position occupied by the same atom.
(defun match (pattern assertion)
	(cond
		((and (null pattern) (null assertion)) t) ; end of pattern and assertion
		((or (null pattern) (null assertion)) nil) ; end of pattern XOR assertion
		((or ; match one atom (? or actual value)
			(eql (car pattern) '?) ; single-atom wildcard
			(eql (car pattern) (car assertion))) ; assertion matches pattern for current atom
				(match (cdr pattern) (cdr assertion)))
		((eql (car pattern) '!) ; multi-atom wildcard
			(or
				(match (cdr pattern) (cdr assertion))
				(match pattern (cdr assertion))))
		(t nil)))

; Define a function match-var that extends match. The function match-var takes patterns con-
; taining pattern variables and matches them against assertions and assigns values to variables.
(defun match-var (pattern assertion &optional aggregation)
	(cond
		((and (null pattern) (null assertion)) t) ; if we've reached the end of both pattern and assertion, we have a match
		((or (null pattern) (null assertion)) nil) ; if pattern XOR assertion has ended, they are not a match
		((eql (car pattern) (car assertion)) ; if assertion matches pattern for current atom, normal recursion
			(match-var (cdr pattern) (cdr assertion)))
		((listp (car pattern)) ; pattern item is a list (which represents a wildcard)
			(cond
				((eql (caar pattern) '?) ; single-atom wildcard: normal recursion; set variable if recursion returns true
					(and (match-var (cdr pattern) (cdr assertion)) ; test for further (entire) match
						(match-var-set pattern assertion aggregation) ; set variable
						t)) ; evaluate to true for return value
				((eql (caar pattern) '!) ; multi-atom wildcard: try normal recursion; fallback to recursion that only unshifts the assertion; set variable if recursion returns true
					(or
						(and (match-var (cdr pattern) (cdr assertion)) ; test for further (entire) match
							(match-var-set pattern assertion aggregation) ; set variable
							t) ; evaluate to true for return value
						(match-var pattern (cdr assertion) (append aggregation (list (car assertion))))))
				(t nil)))))

(defun match-var-set (pattern assertion aggregation)
	(set (cadar pattern)
		(if aggregation
			(append aggregation (list (car assertion)))
			(car assertion))))