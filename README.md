# LambdaFn

[![Build Status](https://travis-ci.org/haberdashPI/LambdaFn.jl.svg?branch=master)](https://travis-ci.org/haberdashPI/LambdaFn.jl)
[![Codecov](https://codecov.io/gh/haberdashPI/LambdaFn.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/haberdashPI/LambdaFn.jl)

This small package provides an alternative syntax for anonymous functions. 
It allows the use of three types of function arguments:

1. Implicit - each `_` is replaced with a new symbol
2. Numbered - each `_[n]` is replaced with the nth argument to the function
3. Named - each `_[name]` is replace with an argument named `name`.

```julia
using LambdaFn

@λ(_ + _) # == (x,y) -> x+y
@λ(_a*_b + _a) # == (a,b) -> a*b + a
@λ(_2 - _1) # == (_1,_2) -> _2 - _1
@λ(_1 - _3) # == (_1,_2,_3) -> _1 - _3
filter(@λ(_.value > 10),data) # == filter(x -> x.value > 10,data)
```

Note that the types cannot be mixed: `@λ(_1 + _)` throws an error.

This syntax resembles the syntax in [this
proposal](https://github.com/JuliaLang/julia/pull/24990), and would largely
be replaced by such a feature.
