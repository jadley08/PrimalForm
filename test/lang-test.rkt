#lang primal-form

(require rackunit)


;new data type tests
(check-equal? (¬ 2 ^ 4 3 5)
              '((-1 . 1) (2 . 4) (3 . 1) (5 . 1)))
(check-equal? (¬ 2 ^ 4 : 3 : 5)
              '((-1 . 1) (2 . 4) (3 . 1) (5 . 1)))
(check-exn exn:fail? (λ () (¬ 2 ^ 4 5 3)))
(check-exn exn:fail? (λ () (¬ 2 ^ 4 : 3 : 5 :)))
(check-exn exn:fail? (λ () (¬ 2 ^ 4 : 3 : 5 :)))
(check-exn exn:fail? (λ () (¬ 7 : ^ 2)))
(check-exn exn:fail? (λ () (3 3)))
(check-exn exn:fail? (λ () (3 3 5)))
(check-exn exn:fail? (λ () (3 : 3)))
(check-exn exn:fail? (λ () (3 : 3 : 5)))
(check-exn exn:fail? (λ () (3 : 3 5)))
(check-exn exn:fail? (λ () (3 ^ 2 : 3)))
(check-exn exn:fail? (λ () (3 ^ 2 : 3 5)))
(check-exn exn:fail? (λ () (3 ^ 2 : 3 : 5)))
(check-exn exn:fail? (λ () (3 : 3 ^ 2)))
(check-exn exn:fail? (λ () (3 : 3 ^ 2 5)))
(check-exn exn:fail? (λ () (3 : 3 ^ 2 : 5)))
(check-exn exn:fail? (λ () (3 ^ 2 : 3 ^ 2)))
(check-exn exn:fail? (λ () (3 ^ 2 : 3 ^ 2 5)))
(check-exn exn:fail? (λ () (3 ^ 2 : 3 ^ 2 : 5)))
(check-equal? (7)
              '((7 . 1)))
(check-equal? (¬ 7)
              '((-1 . 1) (7 . 1)))


;primal?
(check-true (primal? (zero)))
(check-true (primal? ()))
(check-true (primal? (1 ^ 7)))
(check-true (primal? (2 ^ 5 : 3 ^ 90)))
(check-false (primal? (list (cons 3 90) (cons 2 5))))
(check-true (primal? (2 ^ 5 : 3 ^ 90)))
(check-exn exn:fail? (λ () (primal? (2 ^ 5 : 4 ^ 90))))

;primal-zero?
(check-true (primal-zero? (zero)))
(check-false (primal-zero? ()))
(check-false (primal-zero? (1 ^ 1)))
(check-false (primal-zero? (1 ^ 7)))
(check-false (primal-zero? (3 ^ 7)))

;primal=?
(check-true (primal=? (2 ^ 1 : 3 ^ 2 : 7 ^ 1)
                      (2 : 3 ^ 2 : 7)))
(check-true (primal=? (1 ^ 7 : 2 ^ 1 : 3 ^ 2 : 7 ^ 1)
                      (2 ^ 1 : 3 ^ 2 : 7 ^ 1)))
(check-false (primal=? (1 ^ 7 : 2 ^ 1 : 3 ^ 2 : 7 ^ 1)
                       (2 ^ 1 : 3 : 7 ^ 1)))

;integer->primal
(check-equal? 0
              (zero))
(check-equal? 1
              ())
(check-equal? 2
              (2))
(check-equal? 3
              (3))
(check-equal? 4
              (2 ^ 2))
(check-equal? 5
              (5))
(check-equal? 6
              (2 : 3))
(check-equal? 256
              (2 ^ 8))
(check-equal? 120
              (2 ^ 3 : 3 : 5))
(check-equal? 720
              (2 ^ 4 : 3 ^ 2 : 5))
(check-equal? 999
              (3 ^ 3 : 37))
(check-equal? 9999
              (3 ^ 2 : 11 : 101))

;disjoint
(check-true (disjoint? (2 ^ 1 : 3 ^ 2 : 7 ^ 1)
                       (13 ^ 1 : 17 ^ 3 : 23 ^ 78)))
(check-true (disjoint? (13 ^ 1 : 17 ^ 3 : 23 ^ 78)
                       (2 ^ 1 : 3 ^ 2 : 7 ^ 1)))
(check-false (disjoint? (3 ^ 43 : 13 ^ 1 : 17 ^ 3 : 23 ^ 78)
                        (2 ^ 1 : 3 ^ 2 : 7 ^ 1)))
(check-false (disjoint? (2 ^ 1 : 3 ^ 2 : 7 ^ 1)
                        (3 ^ 43 : 13 ^ 1 : 17 ^ 3 : 23 ^ 78)))

;cardinality
(check-equal? (cardinality (zero))
              0)
(check-equal? (cardinality ())
              0)
(check-equal? (cardinality (1 ^ 1))
              0)
(check-equal? (cardinality (1 ^ 7))
              0)
(check-equal? (cardinality (2 ^ 1 : 3 ^ 2 : 7 ^ 1))
              3)

;intersection
(check-equal? (intersection (2 ^ 4 : 3 ^ 7)
                            (2 ^ 1 : 3 ^ 2 : 7 ^ 1))
              '((2 . 1) (3 . 2)))
(check-equal? (∩ (2 ^ 4 : 3 ^ 7)
                 (2 ^ 1 : 3 ^ 2 : 7 ^ 1))
              '((2 . 1) (3 . 2)))
(check-equal? (∩ (2 ^ 4 : 3 ^ 7)
                 (2 ^ 1 : 3 ^ 2 : 7 ^ 1)
                 (3 ^ 1 : 7 ^ 13))
              '((3 . 1)))
(check-equal? (∩ (2 ^ 1 : 3 ^ 2 : 7 ^ 1) (13 ^ 1 : 17 ^ 3 : 23 ^ 78))
              '())
(check-equal? (∩ (zero) (zero))
              (zero))
(check-equal? (∩ (3 ^ 7) (zero))
              (zero))
(check-equal? (∩ (zero) (3 ^ 7))
              (zero))

;union
(check-equal? (union (2 ^ 4 : 3 ^ 5)
                     (7 ^ 3))
              '((2 . 4) (3 . 5) (7 . 3)))
(check-equal? (∪ (2 ^ 4 : 3 ^ 5)
                 (7 ^ 3))
              '((2 . 4) (3 . 5) (7 . 3)))
(check-equal? (union (7 ^ 3)
                     (2 ^ 4 : 3 ^ 5))
              '((2 . 4) (3 . 5) (7 . 3)))
(check-equal? (∪ (7 ^ 3)
                 (2 ^ 4 : 3 ^ 5))
              '((2 . 4) (3 . 5) (7 . 3)))
(check-equal? (∪ (7 ^ 3)
                 (2 ^ 4 : 3 ^ 5)
                 (2 ^ 13 : 3 ^ 5 : 11 ^ 2))
              '((2 . 13) (3 . 5) (7 . 3) (11 . 2)))
(check-equal? (∪ (zero) (zero))
              (zero))
(check-equal? (∪ (3 ^ 7) (zero))
              (3 ^ 7))
(check-equal? (∪ (zero) (3 ^ 7))
              (3 ^ 7))

;subtraction
(check-equal? (primal-/ (1 ^ 3) (1 ^ 4))
              '())
(check-equal? (primal-/ (1 ^ 3) (1 ^ 4))
              '())
(check-equal? (primal-/ (2 ^ 2 : 3 ^ 2)
                  (2 ^ 2 : 3 ^ 2))
              '())
(check-equal? (primal-/ (1 ^ 7 : 3 ^ 4 : 7 ^ 3) (1 ^ 6 : 3 ^ 2 : 7 ^ 4))
              '((3 . 2)))
(check-equal? (primal-/ (1 ^ 7 : 3 ^ 4 : 7 ^ 3) (1 ^ 6 : 3 ^ 2 : 7 ^ 4))
              '((3 . 2)))
(check-equal? (primal-/ (zero) (zero))
              (zero))
(check-equal? (primal-/ (3 ^ 7) (zero))
              (3 ^ 7))
(check-equal? (primal-/ (zero) (3 ^ 7))
              (zero))

;add
(check-equal? (primal-* (1 ^ 7) (2 ^ 3 : 11 ^ 3) (5 ^ 1))
              '((2 . 3) (5 . 1) (11 . 3)))
(check-equal? (primal-* (2 ^ 3 : 11 ^ 3) ())
              (2 ^ 3 : 11 ^ 3))
(check-equal? (primal-* () (2 ^ 3 : 11 ^ 3))
              (2 ^ 3 : 11 ^ 3))
(check-equal? (primal-* 1 2)
              2)

;partition
(check-true (partition? (2 ^ 7 : 3 ^ 7) (3 ^ 3) (2 ^ 7 : 3 ^ 4)))
(check-false (partition? (¬ 2 ^ 7 : 3 ^ 7) (3 ^ 3) (2 ^ 7 : 3 ^ 4)))
(check-true (partition? (¬ 2 ^ 7 : 3 ^ 7) (3 ^ 3) (¬ 2 ^ 7 : 3 ^ 4)))
(check-true (partition? (¬ 2 ^ 7 : 3 ^ 7) (3 ^ 3) (¬ 2 ^ 7 : 3 ^ 4)))
(check-false (partition? (¬ 2 ^ 7 : 3 ^ 7) (¬ 3 ^ 3) (¬ 2 ^ 7 : 3 ^ 4)))
(check-false (partition? (2 ^ 7 : 3 ^ 7) (3 ^ 2) (2 ^ 7 : 3 ^ 4)))

;normal racket stuff still works
(check-equal? ((λ () 42)) '((2 . 1) (3 . 1) (7 . 1)))

;!
(check-equal? (! 1234567890987654321)
              '((1234567890987654321 . 1)))
(check-equal? (! ¬ 2)
              '((-1 . 1) (2 . 1)))
(check-equal? (! 11 22 33 : 44 55 ^ 66 77 ^ 88 : 99)
              '((11 . 1) (22 . 1) (33 . 1) (44 . 1) (55 . 66) (77 . 88) (99 . 1)))
