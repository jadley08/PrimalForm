#lang primal-form

;; --------------
;; Helpers

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

(define gcd=1
  (λ (n m)
    (empty? (∩ n m))))

(define get-e
  (λ (φ-n)
    (letrec ([helper
              (λ (m)
                (cond
                  [(gcd=1 m φ-n) m]
                  [else (helper (primal-add1 m))]))])
      (helper 3))))

(define euclidean
  (λ (φ-n e)
    103  ;; temporary
    ))

(define primal-^
  (λ (n m)
    (cond
      [(equal? (int 0) m) 1]
      [else (primal-* n (primal-^ n (sub1 m)))])))


;; --------------
;; Center Constants

(define prime-p (!t 11))
(define prime-q (!t 13))

(define n (!t 11 : 13))
(define φ-n (φ n))
;; e*d = 1 mod (φ n)
(define e (get-e φ-n))
(define d (euclidean φ-n e))

(define public-key (cons n (primal->integer e)))
(define private-key (primal->integer d))


;; --------------
;; Encryption
(define n^ (car public-key))
(define e^ (cdr public-key))

(define m (random (int 3) (primal->integer (φ n^))))

; c ≡ m^e (mod n), compute c
(define c (integer->primal (modulo (expt m e^) (primal->integer n^))))


;; --------------
;; Decryption

(define n^^ (car public-key))
(define e^^ (cdr public-key))
(define d^^ private-key)

; c^d ≡ m (mod n), compute m
(define c^d (primal-^ c d^^))
(define m^ (modulo (primal->integer c^d) (primal->integer n^^)))

(equal? m m^)









