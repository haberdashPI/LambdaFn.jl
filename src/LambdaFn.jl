module LambdaFn
export @λ
using MacroTools: postwalk
using Printf

macro λ(body)
    args = Vector{Symbol}()
    implicit::Union{Missing,Bool} = missing

    body = postwalk(body) do expr
        if expr isa Symbol
            sym = string(expr)
            if sym == "_"
                if ismissing(implicit)
                    implicit = true
                elseif !implicit
                    error("Cannot use both implicit (_) and explicit (_1) "*
                          "arguments in the same @λ body.")
                end

                expr = gensym(string("_",length(args)+1))
                push!(args,expr)
                expr
            elseif startswith(sym,"_")
                if ismissing(implicit)
                    implicit = false
                elseif implicit
                    error("Cannot use both implicit (_) and explicit (_1) "*
                          "arguments in the same @λ body.")
                end

                if expr ∉ args
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

    quote
        function lambda($(map(esc,args)...))
            $(esc(body))
        end
    end
end

end # module
