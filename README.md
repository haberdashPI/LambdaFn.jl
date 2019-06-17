# LambdaFn

[![Build Status](https://travis-ci.org/haberdashPI/LambdaFn.jl.svg?branch=master)](https://travis-ci.org/haberdashPI/LambdaFn.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/haberdashPI/LambdaFn.jl?svg=true)](https://ci.appveyor.com/project/haberdashPI/LambdaFn-jl)
[![Codecov](https://codecov.io/gh/haberdashPI/LambdaFn.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/haberdashPI/LambdaFn.jl)

This small package provides an alternative syntax for anonymous functions,
using `_` as a placeholder for each argument OR variables prefixed with `_` to
indicate the arguments. For example:

```julia
using LambdaFn

@λ(_ + _) # == (x,y) -> x+y
@λ(_a*_b + _a) # == (a,b) -> a*b + a
filter(@λ(_.value > 10),data) # == filter(x -> x.value > 10,data)
```

This syntax resembles the syntax in [this
proposal](https://github.com/JuliaLang/julia/pull/24990), and would be
replaced by such a feature. This package is simply a convienient way to use
such an underscore syntax in cases where it is more readable than the default
syntax. (Note however that it can take just as many, or more characters as the
standard anonymous function syntax).
