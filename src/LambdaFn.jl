module LambdaFn
export @λ
using MacroTools: prewalk, @capture
using Printf

@enum BodyType Implicit Numbered Named
bodytype(sym) = 
    sym == "_" ? Implicit :
    occursin(r"^_[0-9]+",sym) ? Numbered :
    occursin(r"^_[[:alnum:]_]+",sym) ? Named :
    missing

btype_str(bt,arg) = bt == Implicit ? "_" : string(arg)

macro λ(body)
    args = Vector{Symbol}()
    found_symbols = Dict{Symbol,Symbol}()
    btype::Union{Missing,BodyType} = missing

    body = prewalk(body) do expr
        if @capture(expr,@λ(body__))
            macroexpand(__module__,expr,recursive=true)
        elseif expr isa Symbol
            sym = string(expr)
            newbtype = bodytype(sym)
            if !ismissing(newbtype)
                if ismissing(btype)
                    btype = newbtype
                elseif btype != newbtype
                    error("Anonymous lambda function can have all implicit ",
                          "(_), all numbered (_1) or all named (_a) arguments.",
                          "You cannot mix these types. But we found two types",
                          " of symbols: `$(sym)` and ",
                          "`$(btype_str(btype,args[end]))`.")
                end
                if btype == Implicit
                    expr = gensym(string("_",length(args)+1))
                    push!(args,expr)
                elseif expr ∉ keys(found_symbols)
                    gens = gensym(expr)
                    found_symbols[expr] = gens

                    expr = gens
                    push!(args,gens)
                else
                    expr = found_symbols[expr]
                end

                expr
            else
                expr
            end
        else
            expr
        end
    end

    if ismissing(btype)
        quote 
            function lambda()
                $(esc(body))
            end
        end
    else
        if btype == Numbered
            symbols = Dict((parse(Int,match(r"_([0-9]+)",string(x))[1]) => x 
                            for x in args)...)
            if minimum(keys(symbols)) < 1
                error("Numbered arguments in lambda function must be ≥ 1.")
            end

            args = map(1:maximum(keys(symbols))) do num
                get(symbols,num,gensym(string("_",num)))
            end
        end

        quote
            function lambda($(map(esc,args)...))
                $(esc(body))
            end
        end
    end
end

end # module
