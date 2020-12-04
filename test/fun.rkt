#lang primal-form


(define one?
  (λ (n)
    (equal? n (int 1))))

(define primal-expt
  (λ (p q)
    (cond
      [(zero? q) 1]
      [(one? q) p]
      [else (primal-* p (primal-expt p (sub1 q)))])))

;; have fun waiting for this in "#lang racket"
(primal-expt 50 (int 100))