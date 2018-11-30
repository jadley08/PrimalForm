#lang primal-form

(match 4
  [(fac (primal->integer 2) a b) b]
  [else 'blow-me])
