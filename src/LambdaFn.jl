module LambdaFn
export @λ
using MacroTools: postwalk
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
    btype::Union{Missing,BodyType} = missing

    body = postwalk(body) do expr
        if expr isa Symbol
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
                elseif expr ∉ args
                    push!(args,expr)
                end

                expr
            else
                expr
            end
        else
            expr
        end
    end

    if btype == Numbered
        numbers = map(x -> parse(Int,match(r"_([0-9]+)",string(x))[1]),args)
        args = map(x -> Symbol("_",x),minimum(numbers):maximum(numbers))
    end

    quote
        function lambda($(map(esc,args)...))
            $(esc(body))
        end
    end
end

end # module
