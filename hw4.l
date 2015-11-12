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
(defun before (lst start finish)
	(if (equal start (car lst))
		(cons start (until (cdr lst) finish))
		(before (cdr lst) start finish)))

; Support function for before. Returns a list containing all elements from the beginning of lst to finish (inclusive).
(defun until (lst finish)
	(cond 
		((null lst) nil) ; empty list
		((equal (car lst) finish) (list finish)) ; matches finish
		(t (cons (car lst) (until (cdr lst) finish))))) ; recurse

; If only the first argument appears in the list, before returns a list containing all the elements from the
; first occurrence of the first argument to the end of the list.
; 
; Write a function split-if that returns a list into two parts. It takes two arguments: a function (f) and
; a list. All members for which f is true go into one list, and the rest go into another list.
; (defun split-if)

; Write a function group that takes arguments: a list l and a number n. It returns a new list in which the
; elements of l are grouped into sublists of length n. The remainder is put in a final sublist.
; Write a function mostn that takes two arguments: a function f and a list l. It returns a list of all elements
; for which the function yields the highest score (along with the score itself), where score the value returned
; from the given function:
	; > (mostn #’length ’((a b) (a b c) (a) (e f g)))
	; ( ((A B C) (E F G)) 3)
; (defun group)

; Write a function match that compares a pattern and an assertion. When a pattern containing no special
; atoms is compared to an assertion, the two match only if they are exactly the same, with each corresponding
; position occupied by the same atom.
; (defun match (pattern assertion)
	; )

; Define a function match-var that extends match. The function match-var takes patterns con-
; taining pattern variables and matches them against assertions and assigns values to variables.
; (defun match-var (pattern assertion)
	; )
