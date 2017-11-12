export log_add, log_sub, log1mexp, log1pexp


"log(x+y) from log(x) and log(y)"
function log_add(lx, ly)
    if lx > ly
        return log_add(ly, lx)
    elseif -Inf < lx ≤ ly < Inf
        return ly + log1p(exp(lx - ly))
    else
        return ly
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


"log(1 - exp(-x)), x ≥ 0"
function log1mexp(x)
    # https://cran.r-project.org/web/packages/Rmpfr/vignettes/log1mexp-note.pdf, Eq. 7
    x ≥ 0 || throw(DomainError())
    if x ≤ log(2)
        log(-expm1(-x))
    else
        log1p(-exp(-x))
    end
end


"log(1 + exp(x))"
function log1pexp(x)
    # https://cran.r-project.org/web/packages/Rmpfr/vignettes/log1mexp-note.pdf, Eq. 10
    if x ≤ -37
        exp(x)
    elseif -37 < x ≤ 18
        log1p(exp(x))
    elseif 18 < x ≤ 33.3
        x + exp(-x)
    else
        x
    end
end
