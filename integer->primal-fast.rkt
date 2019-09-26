#lang racket

(require math/number-theory)


(define integer->primal
  (λ (n)
    (letrec
        ([helper
          (λ (n prime acc)
            (cond
              [(equal? 0 n) '(zero)]
              [(equal? 1 n) acc]
              [(< n 0) (helper (* -1 n) prime (cons (cons -1 1) acc))]
              [else
               (if (divides? prime n)
                   (if (and (> (length acc) 0)
                            (equal? (caar acc) prime))
                       (helper (/ n prime)
                               prime
                               (cons (cons prime (add1 (cdar acc)))
                                     (cdr acc)))
                       (helper (/ n prime)
                               prime
                               (cons (cons prime 1)
                                     acc)))
                   (helper n (next-prime prime) acc))]))])
      (reverse (helper n 2 '())))))