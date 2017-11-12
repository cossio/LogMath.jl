export LogNum


struct LogNum{T}
    l::T # log of the absolute value
    s::Int # sign

    function LogNum{T}(l::T, s::Int) where T
        s = sign(s)
        if isinf(l) && l < 0
            s = 0
        elseif s == 0
            l = -inf(T)
        end
        new(l, s)
    end
end


LogNum(l::T, s::Int) where T = LogNum{T}(l, s)
LogNum() = LogNum(-Inf, 0)
LogNum(x::LogNum) = x
LogNum(x::Real) = LogNum(log(abs(x)), Int(sign(x)))

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
        LogNum(logadd(x.l, y.l), x.s)
    else
        LogNum(logsub(x.l, y.l), x.l > y.l ? x.s : y.s)
    end
end


function Base.:(/)(x::LogNum, y::LogNum)
    if iszero(x) && iszero(y)
        throw(DomainError())
    elseif iszero(y)
        LogNum(Inf, x.s)
    else
        LogNum(x.l - y.l, x.s * y.s)
    end
end


Base.:(-)(x::LogNum) = LogNum(x.l, -x.s)
Base.:(-)(x::LogNum, y::LogNum) = x + (-y)
Base.:(*)(x::LogNum, y::LogNum) = LogNum(x.l + y.l, x.s * y.s)
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