#lang primal-form

;; Key Generation
(define φ
  (λ (p)
    (letrec ([helper
              (λ (p)
                (cond
                  [(null? p) (int 1)]
                  [else (* (expt (caar p) (sub1 (cdar p)))
                           (sub1 (caar p))
                           (helper (cdr p)))]))])
      (integer->primal (helper p)))))

(define primal-^
  (λ (n m)
    (cond
      [(equal? (int 0) m) 1]
      [else (primal-* n (primal-^ n (sub1 m)))])))

(define prime-p (!t 17))
(define prime-q (!t 19))

(define n     (!t 17 : 19))
(define int-n (primal->integer n))
(define e (int 2))
(define d (int 3))

(define public-key  (cons n e))
(define private-key (cons n d))

;; Encryption
(define m (random (int 2) int-n))

; c ≡ m^e (mod n), compute c
(define m^e (integer->primal (modulo (expt m e) int-n)))
(define c (primal-+ m^e (primal-* n (integer->primal (random (int 2) (int 20))))))

;; Decryption
; c^d ≡ m (mod n), compute m
; know: e, m, n
; don't know: d, m, p, q
; know c, n

(define φ-n (φ n))

; both prime so we know relatively prim
(define e^ (caar  φ-n))
(define d^ (caadr φ-n))

(define c^d (primal-^ c d^))
(modulo (primal->integer c^d) (primal->integer n))









