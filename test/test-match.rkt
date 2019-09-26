#lang racket
(require "../match.rkt")

18
(match 9
  [(raised-two a) a]
  [a a])

