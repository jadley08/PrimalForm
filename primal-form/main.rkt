#lang racket

  
(require (for-syntax syntax/parse racket/syntax "./to-primal.rkt")
         "./match.rkt"
         "./to-primal.rkt"
         syntax/parse
         racket/syntax)
  
(provide (except-out (all-from-out racket)
                     #%datum)
         (rename-out [dat #%datum])
         (all-from-out "./match.rkt")
         primal-+ primal--
         primal-add1 primal-sub1
         primal->integer integer->primal
         intersection ∩
         union ∪
         primal-/
         primal-*
         primal-zero?
         primal?
         primal=?
         cardinality
         disjoint?
         partition?
         #%app
         ^ neg ¬ zero :)
  
(define ^ '^)
(define neg 'neg)
(define ¬ '¬)
(define zero 'zero)
(define : ':)

(define-syntax (dat stx)
  (syntax-parse stx
    [(_ . n:integer)
     (with-syntax ([pn (integer->primal (syntax-e #'n))])
       #''pn)]
    [(_ . e) #''e]))

(define-syntax (#%app stx)
  (syntax-parse stx #:literals (zero)
    [(_ zero) #'(list zero)]
    [(_ n rest ...)
     #:when (number? (syntax-e #'n))
     #'(base-normalize (parse-primal #'(n rest ...)))] ;here we can find a way to pass stx to parse-primal to preserve source location
    [(_ n more rest ...)
     #:when (or (equal? 'neg (syntax-e #'n))
                (equal? '¬   (syntax-e #'n)))
     (if (or (equal? 'neg (syntax-e #'more))
             (equal? '¬   (syntax-e #'more)))
         (raise-syntax-error #f "expected only 1 negative identifier" stx) ; #'(more ...)
         #'(cons (cons -1 1) (#%app more rest ...)))]
    [(_) #''()]
    [(_ e args ...) #'(#%plain-app e args ...)]))

(define parse-primal
  (λ (stx)
    (syntax-parse stx #:literals (: ^)
      [(colon rest ...)
       #:when (equal? ': (syntax-e #'colon))
       (raise-syntax-error #f "bad syntax at : " #'colon)]
      [()
       '()]
      [(p)
       (if (natural-prime? (syntax-e #'p))
           (list (cons (syntax-e #'p) 1))
           (raise-syntax-error #f "expected a natural prime number" #'p))]
      [(p ^ n : rest ...)
       (parse-primal #'(p ^ n rest ...))]
      [(p : n rest ...)
       (if (natural-prime? (syntax-e #'n))
           (parse-primal #'(p n rest ...))
           (raise-syntax-error #f "expected a natural prime number" #'n))]
      [(p ^ n1 n2 rest ...)
       #:when (and (natural-prime? (syntax-e #'p))
                   (natural-prime? (syntax-e #'n2))
                   (>= (syntax-e #'p) (syntax-e #'n2)))
       (raise-syntax-error #f (format "expected ~s < ~s" (syntax-e #'p) (syntax-e #'n2)) #'n2)];would like to highlight both p and n2, don't know how
      [(p n rest ...)
       #:when (and (natural-prime? (syntax-e #'p))
                   (natural-prime? (syntax-e #'n))
                   (>= (syntax-e #'p) (syntax-e #'n)))
       (raise-syntax-error #f (format "expected ~s < ~s" (syntax-e #'p) (syntax-e #'n)) #'n)];would like to highlight both p and n, don't know how
      [(p ^ n rest ...)
       (if (natural-prime? (syntax-e #'p))
           (if (natural? (syntax-e #'n))
               (cons (cons (syntax-e #'p) (syntax-e #'n)) (parse-primal #'(rest ...)))
               (raise-syntax-error #f "expected a natural number" #'n))
           (raise-syntax-error #f "expected a natural prime number" #'p))]
      [(p n rest ...)
       (if (natural-prime? (syntax-e #'p))
           (if (or (equal? ': (syntax-e #'n))
                   (natural? (syntax-e #'n)))
               (cons (cons (syntax-e #'p) 1) (parse-primal #'(n rest ...)))
               (raise-syntax-error #f (format "expected one of (:, ^, natural number) in ~s" (syntax->datum #'n)) #'n))
           (raise-syntax-error #f (format "expected a natural prime number at ~s" (syntax->datum #'p)) #'p))]
      [_ (raise-syntax-error #f (format "no matchin clause for ~s in parse-primal" (syntax->datum stx)) stx)])))

;; assumes primal number is already in primal form, just removes (1 ^ _)
(define base-normalize
  (λ (ls)
    (cond
      [(null? ls) '()]
      [(primal-zero? ls) (zero)]
      [(equal? 1 (caar ls)) (cdr ls)]
      [else ls])))

;; takes an unsorted primal number
;; returns an ordered primal number with (1 ^ _) removed
(define normalize
  (λ (ls)
    (letrec ([helper (λ (ls)
                       (cond
                         [(null? ls) '()]
                         [(primal-zero? ls) (zero)]
                         [(equal? 1 (caar ls)) (cdr ls)]
                         [else (cons (car ls) (normalize (cdr ls)))]))])
      (begin
        (helper (sort ls (λ (e1 e2) (<= (car e1) (car e2)))))))))




;                                                                
;                                                                
;                         ;                                      
;                         ;                                      
;                         ;                                      
;   ;;                    ;                                      
;   ;;     ;              ;                                      
;   ;;     ;              ;                                      
;   ;;     ;              ;                                      
;   ;;     ;     ;;;;     ;    ;;;;;;     ;;;;     ;        ;;;; 
;    ;  ;;;;    ;;  ;     ;    ;;    ;   ;;  ;     ;   ;;  ;;    
;    ;;;;  ;    ;    ;    ;   ;;     ;   ;    ;    ;  ;   ;      
;    ;;    ;   ;    ;;    ;    ;     ;  ;    ;;    ; ;;   ;      
;    ;     ;   ;;;;;      ;    ;    ;   ;;;;;      ;;;     ;;    
;    ;     ;   ;          ;    ;    ;   ;          ;;        ;;  
;    ;     ;   ;      ;   ;    ;   ;    ;      ;    ;          ; 
;    ;     ;    ;   ;;    ;    ;;;;      ;   ;;     ;          ; 
;    ;           ;;;;          ;          ;;;;      ;     ;;  ;; 
;    ;                          ;                          ;;;;  
;                               ;                                
;                               ;                                
;                               ;                                
(define not-div-by-any_or-mem
  (λ (n ls)
    (cond
      [(null? ls) #t]
      [(equal? n (car ls)) #t]
      [(divisible? n (car ls)) #f]
      [else (not-div-by-any_or-mem n (cdr ls))])))

(define cardinality
  (λ (fact)
    (if (primal-zero? fact)
        (integer->primal 0)
        (integer->primal (length fact)))))

(define disjoint?
  (λ (fact1 fact2)
    (equal? (zero) (cardinality (intersection fact1 fact2)))))







(define primal=?
  (λ (p1 p2)
    (equal? (primal->integer p1) (primal->integer p2))))

(define divisible?
  (λ (a b)
    (integer? (/ a b))))

(define contains-v
  (λ (fact num)
    (cond
      [(null? fact) 0]
      [else (if (eqv? num (car (car fact)))
                (cdr (car fact))
                (contains-v (cdr fact) num))])))


;                         ;                                                    ;                           
;                         ;                                                    ;                           
;     ;;;;                ;                                                    ;     ;                     
;       ;                 ;;                                                   ;;                          
;       ;                 ;;;                                                  ;;;                         
;       ;     ;         ;;;;                                                 ;;;;                  ;       
;       ;     ;   ;;      ;;     ;;;;     ;        ;;;;    ;;;;      ;;;;      ;;    ;      ;;;;   ;   ;;  
;       ;     ;   ; ;     ;;    ;;  ;     ;   ;;  ;;      ;;  ;     ;   ;;     ;;    ;    ;;    ;  ;   ; ; 
;       ;     ;  ;  ;     ;;    ;    ;    ;  ;   ;        ;    ;    ;    ;     ;;    ;   ;;     ;  ;  ;  ; 
;       ;     ; ;   ;      ;   ;    ;;    ; ;;   ;       ;    ;;   ;            ;    ;  ;;      ;  ; ;   ; 
;       ;      ;;   ;      ;   ;;;;;      ;;;     ;;     ;;;;;     ;            ;    ;  ;       ;   ;;   ; 
;       ;      ;    ;      ;   ;          ;;        ;;   ;         ;            ;    ;  ;       ;   ;    ; 
;       ;      ;    ;      ;   ;      ;    ;          ;  ;      ;  ;     ;      ;    ;  ;      ;    ;    ; 
;       ;;;    ;    ;      ;    ;   ;;     ;          ;   ;   ;;    ;   ;       ;    ;  ;      ;    ;    ; 
;       ;;     ;    ;      ;     ;;;;      ;     ;;  ;;    ;;;;      ;;;        ;    ;   ;    ;     ;    ; 
;     ;;                                          ;;;;                                    ;;;;             
(define ∩
  (λ args
    (apply intersection args)))
(define intersection
  (λ args
    (cond
      [(< (length args) 2) (car args)]
      [(eqv? (length args) 2) (intersection-helper (car args) (cadr args))]
      [else
       (apply intersection (intersection-helper (car args) (cadr args)) (cddr args))])))

(define intersection-helper
  (λ (fact1 fact2)
    (cond
      [(or (primal-zero? fact1)
           (primal-zero? fact2)) (zero)]
      [(null? fact1) '()]
      [else (let* ([fact1-a (car (car fact1))]
                   [fact1-d (cdr (car fact1))]
                   [v (contains-v fact2 fact1-a)]
                   [min-v (min fact1-d v)]
                   [almost (intersection-helper (cdr fact1) fact2)])
              (if (eqv? min-v 0)
                  almost
                  (cons (cons fact1-a min-v) almost)))])))

                                     
;                                               
;                         ;                     
;    ;      ;                                   
;    ;      ;                                   
;    ;      ;   ;                       ;       
;    ;      ;   ;   ;;    ;      ;;;;   ;   ;;  
;    ;      ;   ;   ; ;   ;    ;;    ;  ;   ; ; 
;    ;      ;   ;  ;  ;   ;   ;;     ;  ;  ;  ; 
;    ;;     ;   ; ;   ;   ;  ;;      ;  ; ;   ; 
;    ;;    ;;    ;;   ;   ;  ;       ;   ;;   ; 
;     ;    ;     ;    ;   ;  ;       ;   ;    ; 
;     ;   ;;     ;    ;   ;  ;      ;    ;    ; 
;     ;  ;;      ;    ;   ;  ;      ;    ;    ; 
;      ;;;       ;    ;   ;   ;    ;     ;    ; 
;                              ;;;;             
(define ∪
  (λ args
    (apply union args)))
(define union
  (λ args
    (cond
      [(< (length args) 2) '()]
      [(eqv? (length args) 2) (union-helper (car args) (cadr args))]
      [else
       (apply union (union-helper (car args) (cadr args)) (cddr args))])))

(define union-helper
  (λ (fact1 fact2)
    (cond
      [(or (null? fact1)
           (primal-zero? fact1)) fact2]
      [(or (null? fact2)
           (primal-zero? fact2)) fact1]
      [(null? fact1) fact2]
      [(< (caar fact2) (caar fact1))
       (union-helper fact2 fact1)]
      [(eqv? (caar fact1) (caar fact2))
       (cons (cons (caar fact1) (max (cdar fact1) (cdar fact2)))
             (union-helper (cdr fact1) (cdr fact2)))]
      [else (cons (car fact1)
                  (union-helper (cdr fact1) fact2))])))



;                                                                         
;                                   ;                                 ;   
;                      ;            ;                                 ;   
;                      ;            ;                                 ;   
;     ;;;;;            ;            ;;                                ;;  
;    ;;                ;            ;;;                               ;;; 
;    ;                 ;          ;;;;                              ;;;;  
;   ;        ;     ;   ;    ;;;     ;;    ;         ;;;     ;;;;      ;;  
;   ;        ;     ;    ;  ;   ;    ;;    ;   ;;  ;;   ;   ;   ;;     ;;  
;    ;;      ;     ;    ;;;    ;    ;;    ;  ;         ;   ;    ;     ;;  
;     ;;;;   ;     ;    ;;     ;     ;    ; ;;         ;  ;            ;  
;        ;;  ;    ;;    ;      ;     ;    ;;;       ;; ;  ;            ;  
;   ;     ;  ;    ;;    ;     ;      ;    ;;      ;;  ;;  ;            ;  
;   ;     ;  ;   ;;;    ;    ;       ;     ;      ;   ;;  ;     ;      ;  
;   ;    ;   ;  ;  ;    ;   ;        ;     ;      ;  ; ;   ;   ;       ;  
;    ;;;;    ;  ;  ;     ;;;         ;     ;      ;;;  ;    ;;;        ;  
;             ;;   ;
(define primal-/
  (λ (fact1 fact2)
    (cond
      [(primal-zero? fact1) (zero)]
      [(primal-zero? fact2) fact1]
      [(null? fact1) '()]
      [(< (caar fact2) (caar fact1))
       (primal-/ fact1 (cdr fact2))]
      [(eqv? (caar fact1) (caar fact2))
       (let ([v (- (cdar fact1) (cdar fact2))])
         (if (<= v 0)
             (primal-/ (cdr fact1) (cdr fact2))
             (cons (cons (caar fact1) v)
                   (primal-/ (cdr fact1) (cdr fact2)))))]
      [else (cons (car fact1) (primal-/ (cdr fact1) fact2))])))


                                                                       
;                                 ;           ;                           
;                                 ;           ;                           
;    ;;;;;;;                      ;     ;     ;     ;                     
;   ;;;    ;;                     ;;          ;;                          
;   ;;      ;                     ;;;         ;;;                         
;    ;      ;                   ;;;;        ;;;;                  ;       
;    ;     ;;    ;;;    ;         ;;    ;     ;;    ;      ;;;;   ;   ;;  
;    ;     ;   ;;   ;   ;   ;;    ;;    ;     ;;    ;    ;;    ;  ;   ; ; 
;    ;   ;;         ;   ;  ;      ;;    ;     ;;    ;   ;;     ;  ;  ;  ; 
;    ;;;;           ;   ; ;;       ;    ;      ;    ;  ;;      ;  ; ;   ; 
;    ;           ;; ;   ;;;        ;    ;      ;    ;  ;       ;   ;;   ; 
;    ;         ;;  ;;   ;;         ;    ;      ;    ;  ;       ;   ;    ; 
;    ;;        ;   ;;    ;         ;    ;      ;    ;  ;      ;    ;    ; 
;    ;;        ;  ; ;    ;         ;    ;      ;    ;  ;      ;    ;    ; 
;    ;;        ;;;  ;    ;         ;    ;      ;    ;   ;    ;     ;    ; 
;    ;;                                                  ;;;;             
(define partition?
  (λ facts
    (let* ([fact (car facts)]
           [parts (cdr facts)]
           [add-parts (apply primal-* parts)])
      (equal? fact add-parts))))

                           
;                       ;          ; 
;                       ;          ; 
;                       ;          ; 
;                       ;          ; 
;         ;             ;          ; 
;        ;;             ;          ; 
;        ; ;            ;          ; 
;       ;  ;       ;;;  ;     ;;;  ; 
;       ;  ;      ;  ;; ;    ;  ;; ; 
;      ;   ;     ;     ;;   ;     ;; 
;      ;;;;;;   ;       ;  ;       ; 
;     ;     ;   ;       ;  ;       ; 
;     ;     ;   ;      ;;  ;      ;; 
;    ;      ;   ;     ;;;  ;     ;;; 
;    ;      ;   ;;   ;; ;  ;;   ;; ; 
;   ;;            ;;;   ;    ;;;   ; 
;   ;                   ;          ;
(define primal-*
  (λ args
    (cond
      [(< (length args) 2) '()]
      [(equal? (length args) 2) (add-helper (car args) (cadr args))]
      [else
       (apply primal-* (add-helper (car args) (cadr args)) (cddr args))])))

(define add-helper
  (λ (fact1 fact2)
    (cond
      [(null? fact1) fact2]
      [(null? fact2) fact1]
      [(< (caar fact2) (caar fact1)) (add-helper fact2 fact1)]
      [(equal? (caar fact1) (caar fact2))
       (append (list (cons (caar fact1) (+ (cdar fact1) (cdar fact2))))
               (add-helper (cdr fact1) (cdr fact2)))]
      [else (append (list (car fact1))
                    (add-helper (cdr fact1) fact2))])))

;                                                                                             
;                                                                                             
;                                              ;          ;                                   
;                                              ;          ;                                   
;                                              ;          ;                    ;              
;                                              ;          ;                    ;              
;                                              ;          ;                    ;              
;                                              ;          ;                    ;              
;                                              ;          ;                    ;            ; 
;       ;                        ;;;      ;;;  ;     ;;;  ;    ;;;;  ;     ;   ;    ;;;    ;; 
;       ;                      ;;   ;    ;  ;; ;    ;  ;; ;   ;;     ;     ;    ;  ;   ;  ; ; 
;       ;       ;;                  ;   ;     ;;   ;     ;;  ;       ;     ;    ;;;    ;  ; ; 
;    ;;;;;;;;   ;;;;;;;;;;;         ;  ;       ;  ;       ;  ;       ;     ;    ;;     ;    ; 
;       ;                        ;; ;  ;       ;  ;       ;   ;;     ;    ;;    ;      ;    ; 
;       ;                      ;;  ;;  ;      ;;  ;      ;;     ;;   ;    ;;    ;     ;     ; 
;       ;                      ;   ;;  ;     ;;;  ;     ;;;       ;  ;   ;;;    ;    ;      ; 
;       ;                      ;  ; ;  ;;   ;; ;  ;;   ;; ;       ;  ;  ;  ;    ;   ;       ; 
;       ;                      ;;;  ;    ;;;   ;    ;;;   ;  ;;  ;;  ;  ;  ;     ;;;        ; 
;                                              ;          ;   ;;;;    ;;   ;                 
(define primal-+
  (λ args
    (integer->primal (foldr + 0 (map primal->integer args)))))

(define primal--
  (λ args
    (integer->primal (foldr - 0 (map primal->integer args)))))

(define primal-add1
  (λ (p) (integer->primal (add1 (primal->integer p)))))

(define primal-sub1
  (λ (p) (integer->primal (sub1 (primal->integer p)))))

                                             
;              ;                                
;              ;                                
;              ;                                
;              ;                                
;              ;                                
;              ;                                
;              ;             ;            ;;;;  
;      ;  ;    ;      ;;;    ;   ;;     ;;    ; 
;      ;;;;;   ;    ;;   ;   ;   ; ;   ;;     ; 
;    ;;;  ;    ;         ;   ;  ;  ;   ;      ; 
;      ;  ;    ;         ;   ; ;   ;  ;      ;; 
;      ; ;     ;      ;; ;    ;;   ;  ;      ;; 
;     ;; ;;;   ;    ;;  ;;    ;    ;  ;     ; ; 
;   ;;;;;;     ;    ;   ;;    ;    ;  ;;   ;  ; 
;     ;  ;     ;    ;  ; ;    ;    ;    ;;;   ; 
;     ;  ;          ;;;  ;    ;    ;          ; 
;                                        ;    ; 
;                                        ;    ; 
;                                         ;;  ; 
;                                           ;;;

(module reader syntax/module-reader
  primal-form/main)