# PrimalForm
### Authors: Jacob Adley, Lalo Viduarri

Racket domain specific language that uses integers in their prime factorization form.

## Description

## Goal

## Syntax

### Data Type
For directly inputting integers in their primal form:
**Literals**: ``^  :  (  )``
**Variables**: ``x, w ∈ ℤ; y, z ∈ ℕ``

```racket
(x)
(x y)
(x : y)
(x ^ y)
(x ^ y w)
(x ^ y : w)
(x ^ y : w ^ z)
(x ^ y w ^ z)
```

The : is an optional separator of primal divisors of input number.
The ^ denotes exponentiation from one integer to a Natural.

### Match
