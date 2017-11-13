export LogNum


struct LogNum{T}
    l::T # log of the absolute value
    s::Int # sign

    function LogNum{T}(l::T, s::Int) where T
        s = sign(s)
        if isnan(l)
            s = 1
        elseif isinf(l) && l < 0
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


function LogNum(x::T) where T
    if isnan(x)
        LogNum(T(NaN), 1)
    else
        LogNum(log(abs(x)), sign(x) ≥ 0 ? 1 : -1)
    end
end


function Base.convert(::Type{T}, x::LogNum{T})::T where T 
    x.s * exp(x.l)
end


function Base.convert(::Type{LogNum{T}}, x::T)::LogNum{T} where T
    LogNum(x)
end

Base.promote_rule(::Type{T}, ::Type{LogNum{T}}) where T = LogNum{T}


function Base.zero(::Type{LogNum{T}})::LogNum{T} where T
    LogNum(zero(T))
end


function Base.one(::Type{LogNum{T}})::LogNum{T} where T
    LogNum(one(T))
end


Base.zero(x::LogNum{T}) where T = zero(LogNum{T})
Base.one(x::LogNum{T}) where T = one(LogNum{T})

Base.iszero(x::LogNum) = iszero(x.s)
Base.isfinite(x::LogNum) = x.l < Inf
Base.isinf(x::LogNum) = x.l == Inf
Base.isnan(x::LogNum) = isnan(x.l)

#Base.:(==)(x::LogNum, y::LogNum) = x.s == y.s && x.l == y.l
Base.:(==)(x::LogNum, y::Real) = x == LogNum(y)
Base.:(==)(x::Real, y::LogNum) = LogNum(x) == y

Base.isless(x::LogNum, y::LogNum) = !isnan(x) && !isnan(y) && (x.s < y.s || x.s == y.s == 1 && x.l < y.l || x.s == y.s == -1 && x.l > y.l)
Base.isless(x::Real, y::LogNum) = LogNum(x) < y
Base.isless(x::LogNum, y::Real) = x < LogNum(y)

Base.isapprox(x::LogNum, y::LogNum; atol::Real = 0, rtol = sqrt(eps(Float64))) = x == y || (isfinite(x) && isfinite(y) && abs(x-y) <= atol + rtol*max(abs(x), abs(y)))
Base.isapprox(x::LogNum, y::Real; atol::Real = 0, rtol = sqrt(eps(Float64))) = isapprox(x, LogNum(y); atol=atol, rtol=rtol)
Base.isapprox(x::Real, y::LogNum; atol::Real = 0, rtol = sqrt(eps(Float64))) = isapprox(LogNum(x), y; atol=atol, rtol=rtol)

Base.abs(x::LogNum) = LogNum(x.l, 1)
Base.sign(x::LogNum) = x.s


function Base.exp(x::LogNum{T})::LogNum{T} where T
    LogNum(convert(T, x), 1)
end


function Base.log(x::LogNum{T})::LogNum{T} where T
    if isnan(x) 
        LogNum(T(NaN))
    elseif x < 0 
        throw(DomainError())
    else
        LogNum(log(abs(x.l)), (x - 1).s)
    end
end


function Base.:(+)(x::LogNum{T}, y::LogNum{T})::LogNum{T} where {T}
    if isnan(x) || isnan(y)
        LogNum(T(NaN))
    elseif x.s == y.s
        LogNum(logadd(x.l, y.l), x.s)
    else
        LogNum(logsub(x.l, y.l), x.l > y.l ? x.s : y.s)
    end
end


Base.:(+)(x::LogNum, y::Real) = x + LogNum(y)
Base.:(+)(x::Real, y::LogNum) = LogNum(x) + y
Base.:(-)(x::LogNum) = LogNum(x.l, -x.s)
Base.:(-)(x::LogNum, y::LogNum) = x + (-y)
Base.:(-)(x::LogNum, y::Real) = x - LogNum(y)
Base.:(-)(x::Real, y::LogNum) = LogNum(x) - y


function Base.:(/)(x::LogNum{T}, y::LogNum{T})::LogNum{T} where {T}
    if isnan(x) || isnan(y) || iszero(x) && iszero(y)
        LogNum(T(NaN))
    elseif iszero(y)
        LogNum(T(Inf), x.s)
    else
        LogNum(x.l - y.l, x.s * y.s)
    end
end


Base.:(/)(x::LogNum, y::Real) = x / LogNum(y)
Base.:(/)(x::Real, y::LogNum) = LogNum(x) / y


function Base.:(*)(x::LogNum{T}, y::LogNum{T})::LogNum{T} where T
    LogNum(x.l + y.l, x.s * y.s)
end


Base.:(*)(x::LogNum, y::Real) = x * LogNum(y)
Base.:(*)(x::Real, y::LogNum) = LogNum(x) * y


function Base.:(^)(x::LogNum{T}, y::LogNum{T})::LogNum{T} where T
    if iszero(x) && iszero(y)
        LogNum(one(x))
    else
        exp(y * log(x))
    end
end


Base.:(^)(x::LogNum, y::AbstractFloat) = x ^ LogNum(y)
Base.:(^)(x::Real, y::LogNum) = LogNum(x) ^ y