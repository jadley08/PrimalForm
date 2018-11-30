#lang racket
(require "to-primal.rkt")

#|Matching on a specific prime number|#

(define ((factor n) prim)
  (cond
    [(empty? prim) (values 'nope 'nay)]
    [(equal? (caar prim) n)
     (values n (cdar prim))]
    [else ((factor n) (cdr prim))]))

(define-match-expander fac
  (λ (stx)
    (syntax-case stx ()
      [(_ num n m) #`(app (factor num) n m)])))

#|Matching on the power of a num|#
(define ((power m) prim)
  (cond
    [(empty? prim) (values 'nope 'nay)]
    [(equal? (cdar prim) m)
     (values (caar prim) m)]
    [else ((power m) (cdr prim))]))

(define-match-expander pow
  (λ (stx)
    (syntax-case stx ()
      [(_ num n m) #`(app (power num) n m)])))

(define ((n-to-the-m n m) prim)
  (cond
    [(empty? prim) (values 'nay 'nope)]
    [(and (equal? (caar prim) n)
          (equal? (cdar prim) m))
     (values n m)]
    [else ((n-to-the-m n m) (cdr prim))]))


;;APP-patteg

#|Test to see how it all is gonna go down|#

(define (to-the-2 prim)
  (match prim
    [(cons (cons a 2) rest) a]
    [(cons a d) (to-the-2 d)]
    [else 'blah]
    ))

(define-match-expander ^2
  (λ (stx)
    (syntax-case stx ()
      [(_ a) #'(app to-the-2 a)])))

(define (test a)
  (match a
    [(^2 a) #:when (number? a) a]
    [else 'nay]))
