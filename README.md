# LambdaFn

[![Build Status](https://travis-ci.org/haberdashPI/LambdaFn.jl.svg?branch=master)](https://travis-ci.org/haberdashPI/LambdaFn.jl)
[![Codecov](https://codecov.io/gh/haberdashPI/LambdaFn.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/haberdashPI/LambdaFn.jl)

This small package provides an alternative syntax for writing anonymous functions. It allows the use of three types of function arguments within the body of a call to `@λ`:

1. Implicit - each `_` is replaced with a new function argument
2. Numbered - each `_[n]` is replaced with the nth argument to the function
3. Named - each `_[name]` is replace with an argument named `name`, and they occur in the function argument list in the same order they appear in the function body.

## Examples
```julia
using LambdaFn

@λ(_ + _) # == (x,y) -> x+y
@λ(_a*_b + _a) # == (a,b) -> a*b + a
@λ(_2 - _1) # == (_1,_2) -> _2 - _1
@λ(_1 - _3) # == (_1,_2,_3) -> _1 - _3
filter(@λ(_.value > 10),data) # == filter(x -> x.value > 10,data)
1:10 |> @λ(filter(@λ(_ > 3),_)) == 4:10
```

Note that the three types of arguments cannot be mixed: `@λ(_1 + _)` throws an error.

This macro resembles the syntax in [this proposal](https://github.com/JuliaLang/julia/pull/24990), and I basically made this package because I got tired of waiting for that feature. The macro is a little more verbose than the proposed syntax change to julia, but I've grown to like the extra options it allows. I also like that it still has an explicit boundary around the body of the anonymous function, an issue that really complicates use of a bare `_` as an anonymous function argument.