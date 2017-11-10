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


"log(1 - e^x)"
log1exp(x) = x > log(2) ? log(-expm1(x)) : log1p(-exp(x))


"log(|x-y|) from log(x) and log(y)"
function log_sub(lx, ly)
    if min(lx, ly) > -Inf
        return max(lx, ly) + log1exp(-abs(lx - ly))
    else
        return max(lx, ly)
    end
end


struct LogNum
    l::Float64 # log of the absolute value
    s::Int # sign

    function LogNum(l::Float64, s::Int)
        s = sign(s)
        if l == -Inf
            s = 0
        elseif s == 0
            l = -Inf
        end
        new(l, s)
    end
end


LogNum() = LogNum(-Inf, 0)
LogNum(x::LogNum) = x
LogNum(x::Real) = LogNum(log(abs(x)), Int(sign(x)))
LogNum(x::Real, s::Real) = LogNum(convert(Float64, x), Int(sign(s)))

Base.convert(::Type{Float64}, x::LogNum) = x.s * exp(x.l)

Base.iszero(x::LogNum) = iszero(x.s)
Base.isfinite(x::LogNum) = x.l < Inf

Base.:(==)(x::LogNum, y::LogNum) = x.s == y.s && x.l == y.l
Base.:(==)(x::LogNum, y::Real) = x == LogNum(y)
Base.:(==)(x::Real, y::LogNum) = LogNum(x) == y

Base.isless(x::LogNum, y::LogNum) = x.s < y.s || x.s == y.s == 1 && x.l < y.l || x.s == y.s == -1 && x.l > y.l
Base.isless(x::Real, y::LogNum) = LogNum(x) < y
Base.isless(x::LogNum, y::Real) = x < LogNum(y)

Base.isapprox(x::LogNum, y::LogNum; atol::Real = 0, rtol = sqrt(eps(Float64))) = x == y || (isfinite(x) && isfinite(y) && abs(x-y) <= atol + rtol*max(abs(x), abs(y)))
Base.isapprox(x::LogNum, y::Real; atol::Real = 0, rtol = sqrt(eps(Float64))) = isapprox(x, LogNum(y); atol=atol, rtol=rtol)
Base.isapprox(x::Real, y::LogNum; atol::Real = 0, rtol = sqrt(eps(Float64))) = isapprox(LogNum(x), y; atol=atol, rtol=rtol)
    
Base.abs(x::LogNum) = LogNum(x.l, 1)
Base.sign(x::LogNum) = x.s
Base.exp(x::LogNum) = LogNum(convert(Float64, x), 1)


function Base.log(x::LogNum)
    x ≥ 0 || throw(DomainError())
    LogNum(log(abs(x.l)), (x - 1).s)
end


function Base.:(+)(x::LogNum, y::LogNum)
    if x.s == y.s
        LogNum(log_add(x.l, y.l), x.s)
    else
        LogNum(log_sub(x.l, y.l), x.l > y.l ? x.s : y.s)
    end
end


Base.:(-)(x::LogNum) = LogNum(x.l, -x.s)
Base.:(-)(x::LogNum, y::LogNum) = x + (-y)
Base.:(*)(x::LogNum, y::LogNum) = LogNum(x.l + y.l, x.s * y.s)
Base.:(/)(x::LogNum, y::LogNum) = iszero(y) ? LogNum(Inf, x.s) : LogNum(x.l - y.l, x.s * y.s)
Base.:(^)(x::LogNum, y::LogNum) = exp(y * log(x))

Base.:(+)(x::LogNum, y::Real) = x + LogNum(y)
Base.:(+)(x::Real, y::LogNum) = LogNum(x) + y

Base.:(-)(x::LogNum, y::Real) = x - LogNum(y)
Base.:(-)(x::Real, y::LogNum) = LogNum(x) - y

Base.:(*)(x::LogNum, y::Real) = x * LogNum(y)
Base.:(*)(x::Real, y::LogNum) = LogNum(x) * y

Base.:(/)(x::LogNum, y::Real) = x / LogNum(y)
Base.:(/)(x::Real, y::LogNum) = LogNum(x) / y

Base.:(^)(x::LogNum, y::Real) = x ^ LogNum(y)
Base.:(^)(x::Real, y::LogNum) = LogNum(x) ^ y