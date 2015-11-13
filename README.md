# LISP Practice

----
## How to run tests
To execute the granular tests provided in `mytest.l`, just execute LISP with `mytest.l` as an argument while in the directory where `mytest.l` and `hw4.l` reside.

```
clisp mytest.l
```

A number of tests were provided by the professor. These can be run in the bourne shell or any of its derivatives:

```
./test.sh
``` 

## Purpose
The purpose of this programming task is to demonstrate (and cultivate) familiarity with LISP programming and with functional programming paradigms.

## Content
The substance of this project resides in `hw4.l`.

This project entails the creation and testing of a number of functions in LISP.

Most notable are functions to:

- implement wildcard pattern matching over lists of atoms
- reproduce higher-order `select` or `collect` and `reject` functions, such as other languages provide (cf. Ruby's `Array#select`)
- find the min and max in a list of numbers
- find all list elements that lie between a pair of elements
