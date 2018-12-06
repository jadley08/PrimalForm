#lang racket
(require "to-primal.rkt")
(provide fac
         pow
         to-the)

#|Matching on a specific prime number|#
(define ((factor n) prim)
  (let ([n (int-or-primal->int n)])
    (letrec
        ([helper
          (λ (n)
            (λ (prim)
              (cond
                [(empty? prim) (values 'nope 'nay)]
                [(equal? (caar prim) n)
                 (values n (cdar prim))]
                [else ((helper n) (cdr prim))])))])
      ((helper n) prim))))

(define-match-expander fac
  (λ (stx)
    (syntax-case stx (≫ >>)
      [(_ num ≫ n m) #`(app (factor num) n m)]
      [(_ num >> n m) #`(app (factor num) n m)])))

#|Matching on the power of a num|#
(define ((power m) prim)  
  (let ([m (int-or-primal->int m)])
    (letrec
        ([helper
          (λ (m)
            (λ (prim)
              (cond
                [(empty? prim) (values 'nope 'nay)]
                [(equal? (cdar prim) m)
                 (values (caar prim) m)]
                [else ((helper m) (cdr prim))])))])
      ((helper m) prim))))

(define-match-expander pow
  (λ (stx)
    (syntax-case stx (≫ >>)
      [(_ num ≫ n m) #`(app (power num) n m)]
      [(_ num >> n m) #`(app (power num) n m)])))


#|Matching on both factor and power|#
(define ((n-to-the-m n m) prim)
  (let ([n (int-or-primal->int n)]
        [m (int-or-primal->int m)])
    (letrec
        ([helper
          (λ (n m)
            (λ (prim)
              (cond
                [(empty? prim) (values 'nay 'nope)]
                [(and (equal? (caar prim) n)
                      (equal? (cdar prim) m))
                 (values n m)]
                [else ((n-to-the-m n m) (cdr prim))])))])
      ((helper n m) prim))))

(define-match-expander to-the
  (λ (stx)
    (syntax-case stx (≫ >>)
      [(_ x y ≫ n m) #`(app (n-to-the-m x y) n m)]
      [(_ x y >> n m) #`(app (n-to-the-m x y) n m)])))
