#lang racket

(provide (all-defined-out))
#;
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

(define primal->integer
  (λ (fact)
    (cond
      [(null? fact) 1]
      [(primal-zero? fact) 0]
      [else (* (expt (caar fact) (cdar fact)) (primal->integer (cdr fact)))])))

(define primal-zero?
  (λ (p)
    (equal? p (list 'zero))))

(define primal?
  (λ (fact)
    (if (list? fact)
        (letrec ([helper (λ (fact last)
                           (cond
                             [(null? fact) #t]
                             [(primal-zero? fact) #t]
                             [(equal? -1 (caar fact))
                              (if (not (equal? -1 last))
                                  (and (equal? 1 (cdar fact))
                                       (helper (cdr fact) -1))
                                  #f)]
                             [else (and (natural-prime? (caar fact))
                                        (> (caar fact) last)
                                        (natural? (cdar fact))
                                        (helper (cdr fact) (caar fact)))]))])
          (helper fact 0))
        #f)))

(define natural-prime?
  (λ (num)
    (letrec ([helper
              (λ (num num-root cur)
                (cond
                  [(> cur num-root) #t]
                  [else (and (not (divisible? num cur))
                             (helper num num-root (add1 cur)))]))])
      (and (natural? num)
           (or (< num 3)
               (helper num (sqrt num) 2))))))

(define (int-or-primal->int n)
  (if (integer? n)
      n
      (primal->integer n)))


;---------------------------
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