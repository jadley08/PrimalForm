#lang primal-form

(require rackunit)

(check-equal?
 (match 30
   [(fac 3 ≫ a b) b]
   [else "Fail"])
 (primal->integer 1))

(check-equal?
 (match 30
   [(fac 7 ≫ a b) b]
   [else "Fail"])
 "Fail")

(check-equal?
 (match 20
   [(pow 1 ≫ a b) a]
   [else "Fail"])
 (primal->integer 5))

(check-equal?
 (match 20
   [(pow 2 ≫ a b) a]
   [else "Fail"])
 (primal->integer 2))

(check-equal?
 (match 20
   [(pow 3 ≫ a b) a]
   [else "Fail"])
 "Fail")

(check-equal?
 (match 20
   [(to-the 5 1 ≫ a b) a]
   [else "Fail"])
 (primal->integer 5))

(check-equal?
 (match 52
   [(and (to-the 2 2 ≫ a b) (to-the 13 1 ≫ c d))
    (integer->primal (+ a b c d))]
   [else 'AAAAA])
 18)

(check-equal?
 (match 52
   [(and (to-the 13 2 ≫ a b) (to-the 13 1 ≫ c d))
    (integer->primal (+ a b c d))]
   [else 'AAAAA])
 'AAAAA)
