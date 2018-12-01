#lang primal-form

(require rackunit)


(define one (primal->integer 1))


;;------------------------------------------------------
(define φ
  (λ (p)
    (letrec ([helper
              (λ (p)
                (cond
                  [(null? p) one]
                  [else (* (expt (caar p) (sub1 (cdar p)))
                           (sub1 (caar p))
                           (helper (cdr p)))]))])
      (integer->primal (helper p)))))

(check-equal? (φ 352) 160)
(check-equal? (φ 68359375) 46875000)
(check-equal? (φ 667) 616)
(check-equal? (φ 1764) 504)
(check-equal? (φ 1763) 1680)


;;------------------------------------------------------
(define gcd ∩)


;;------------------------------------------------------
;LCM
(define lcm
  (λ (p1 p2)
    (cond
      [(null? p1) p2]
      [(equal? (caar p1) (caar p2))
       (cons (cons (caar p1) (max (cdar p1) (cdar p2)))
             (lcm (cdr p1) (cdr p2)))]
      [(< (caar p1) (caar p2))
       (cons (car p1) (lcm (cdr p1) p2))]
      [else (cons (car p2) (lcm p1 (cdr p2)))])))


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