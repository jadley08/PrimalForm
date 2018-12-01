# PrimalForm
Authors: **Jacob Adley** (jadley08), **Lalo Viduarri** (eduvidau)


## Description
Racket domain specific language that uses integers in their prime factorization form.


## Goal


## Setup Instructions
1. Download the primal-form directory and all of its contents.
2. Use ``raco pkg install`` to install the directory as a package.
3. Language line at top of file should be ``#lang primal-form``.
4. Good to go!


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

#### No kidding operator !
Usage of this operator disables checking when making a primal number.
Increases efficiency for not having to check primality.
Relies on user not making an error.

```racket
(! x)
(! x y)
(! x : y)
(! x ^ y)
(! x ^ y w)
(! x ^ y : w)
(! x ^ y : w ^ z)
(! x ^ y w ^ z)
(! ...)
```

#### The int operator
Use this operator applied to a number and returns the normal base 10 representation of the number such as in regular Racket.
Does not perform any prime factorization computation.

``x ∈ ℤ``
```racket
(int x)
  → x
```


### Match


## Future Implementation

### Variables in primal number construction
Want to allow expressions that evaluate to valid integers or naturals to be allowed in primal number construction as described in Data Type.
```racket
(define x 5)
(define y 2)
(x ^ y)
```

### Print nice representation, not implementation

### Efficiency
