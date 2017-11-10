"log(x+y) from log(x) and log(y)"
function log_add(lx::Float64, ly::Float64)
    if lx > ly
        return log_add(ly, lx)
    elseif -Inf < lx ≤ ly < Inf
        return ly + log1p(exp(lx - ly))
    else
        return ly
    end
end


"log(1 - exp(-x))"
function log1mexp(x)
    # https://cran.r-project.org/web/packages/Rmpfr/vignettes/log1mexp-note.pdf
    x ≥ 0 || throw(DomainError())
    if x < -log(2)
        log(-expm1(-x))
    else
        log1p(-exp(-x))
    end
end


"log(|x-y|) from log(x) and log(y)"
function log_sub(lx, ly)
    if min(lx, ly) > -Inf
        return max(lx, ly) + log1mexp(abs(lx - ly))
    else
        return max(lx, ly)
    end
end