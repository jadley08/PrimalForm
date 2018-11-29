#lang racket

(provide integer->primal)

(define integer->primal
  (λ (n)
    (if (< n 0)
        (cons (cons -1 1) (integer->primal (* -1 n)))
        (letrec
            ([helper
              (λ (n cur primes res)
                (cond
                  [(zero? n) (list 'zero)]
                  [(zero? (sub1 n)) res]
                  [(and (equal? n cur)
                        (null? res))
                   (cons (cons n 1) '())]
                  [(equal? n cur)
                   (if (equal? cur (caar res))
                       (cons (cons (caar res)
                                   (add1 (cdar res)))
                             (cdr res))
                       (cons (cons n 1) res))]
                  [(not-div-by-any_or-mem cur primes)
                   (cond
                     [(and (divisible? n cur)
                           (null? res))
                      (helper (/ n cur) cur (cons cur primes) (cons (cons cur 1) '()))]
                     [(divisible? n cur)
                      (let ([res^ (if (equal? cur (caar res))
                                      (cons (cons (caar res)
                                                  (add1 (cdar res)))
                                            (cdr res))
                                      (cons (cons cur 1) res))])
                        (helper (/ n cur) cur (cons cur primes) res^))]
                     [else (helper n (add1 cur) (cons cur primes) res)])]
                  [else (helper n (add1 cur) primes res)]))])
          (reverse (helper n 2 '(2) '()))))))

(define not-div-by-any_or-mem
  (λ (n ls)
    (cond
      [(null? ls) #t]
      [(equal? n (car ls)) #t]
      [(divisible? n (car ls)) #f]
      [else (not-div-by-any_or-mem n (cdr ls))])))

(define divisible?
  (λ (a b)
    (integer? (/ a b))))
