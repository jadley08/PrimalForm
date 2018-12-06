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

#### No kidding operator !t
Usage of this operator disables checking when making a primal number.
Increases efficiency for not having to check primality.
Relies on user not making an error.

```racket
(!t x)
(!t x y)
(!t x : y)
(!t x ^ y)
(!t x ^ y w)
(!t x ^ y : w)
(!t x ^ y : w ^ z)
(!t x ^ y w ^ z)
(!t ...)
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
```racket
[(fac num >> a b) body] ;; Binds a and b if num is a factor in the thing matched
[(pow num >> a b) body] ;; Binds a and b if there is a factor raised to the num power
[(to-the num1 num2 >> a b) body] ;; Binds a and b if num1 is a factor raised to the num2 power


## Implemented Functions
```racket
primal-+
primal--
primal-add1
primal-sub1
primal->integer
integer->primal
primal-divisible?
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
```


## Future Implementation

### Variables in primal number construction
Want to allow expressions that evaluate to valid integers or naturals to be allowed in primal number construction as described in Data Type.
```racket
(define x 5)
(define y 2)
(x ^ y)
```

### Modulo
Want to define at the top of the file the integers we will be using mod n.

### Print nice representation, not implementation

### Efficiency
