#lang primal-form

(require rackunit)


(define one (primal->integer 1))


;;------------------------------------------------------
(define ϕ
  (λ (p)
    (letrec ([helper
              (λ (p)
                (cond
                  [(null? p) one]
                  [else (* (expt (caar p) (sub1 (cdar p)))
                           (sub1 (caar p))
                           (helper (cdr p)))]))])
      (integer->primal (helper p)))))

(check-equal? (ϕ 352) 160)
(check-equal? (ϕ 68359375) 46875000)
(check-equal? (ϕ 667) 616)
(check-equal? (ϕ 1764) 504)
(check-equal? (ϕ 1763) 1680)


;;------------------------------------------------------
(define gcd ∩)


;;------------------------------------------------------
;LCM


;;------------------------------------------------------
;prime?
(define prime?
 (λ (p)
   (let ([c (cardinality p)])
     (or (equal? c 0)
         (and (equal? c 1)
              (equal? (cdar p) one))))))

(check-true (prime? 7))
(check-false (prime? 8))