@test LogNum(5.5, 0) == LogNum()
@test LogNum(-Inf, 0) == LogNum()
@test LogNum(-Inf, 43) == LogNum()

@test iszero(LogNum())
@test iszero(LogNum(0))
@test !iszero(LogNum(1))
@test !iszero(LogNum(-1))

@test isfinite(LogNum(0))
@test isfinite(LogNum(1))
@test isfinite(LogNum(-1))
@test !isfinite(LogNum(Inf))
@test !isfinite(LogNum(-Inf))
@test isinf(LogNum(Inf))
@test !isinf(LogNum(0))

@test isnan(LogNum(NaN))
@test isnan(LogNum(NaN, 1))
@test isnan(LogNum(NaN, -1))
@test !isnan(LogNum(1.))
@test isnan(LogNum(NaN) + LogNum(1))
@test isnan(LogNum(NaN) - LogNum(1))
@test isnan(LogNum(NaN) * LogNum(1))
@test isnan(LogNum(NaN) / LogNum(1))
@test isnan(LogNum(NaN) ^ LogNum(1))

@test convert(Float64, LogNum(1.)) == 1.


for x = -10.:10.
    @test LogNum(x) == LogNum(x) == x
    @test LogNum(x) ≥ LogNum(x) ≥ x
    @test LogNum(x) ≤ LogNum(x) ≤ x
    @test LogNum(x) < LogNum(x + 1)
    @test LogNum(x + 1) > LogNum(x)
end


@test sign(LogNum(1)) == 1
@test sign(LogNum(-42.1)) == -1
@test sign(LogNum(0.)) == 0


@test LogNum(2) > LogNum(1)
@test LogNum(-1) < LogNum(1)
@test LogNum(3.4) ≤ LogNum(3.4)


@test LogNum(-10) ≈ LogNum(-20) + LogNum(10)
@test LogNum(-200) ≈ LogNum(20) * LogNum(-10)
@test LogNum(-30) ≈ LogNum(-10) - LogNum(20)
@test LogNum(-2) ≈ LogNum(20) / LogNum(-10)

@test LogNum(5) - 1 ≈ LogNum(4)
@test 1 - LogNum(5) ≈ LogNum(-4)
@test LogNum(5) + 1 ≈ LogNum(6)
@test 1 + LogNum(5) ≈ LogNum(6)
@test 2 * LogNum(5) ≈ LogNum(10)
@test LogNum(5) * 2 ≈ LogNum(10)
@test LogNum(4) / 2 ≈ LogNum(2)
@test 4 / LogNum(2) ≈ LogNum(2)
@test LogNum(2) > 1
@test 2 > LogNum(1)

@test convert(Float64, LogNum(5)) ≈ 5

@test LogNum(3) * LogNum(-5) ≈ -15

@test exp(LogNum(3)) ≈ exp(3)
@test exp(LogNum(-3)) ≈ exp(-3)

for x = 0.:10.
    @test log(LogNum(x)) ≈ log(x)
end

for x = -10.:10.
    @test convert(Float64, LogNum(x)) ≈ x
    @test abs(LogNum(x)) ≈ abs(x)
    @test exp(LogNum(x)) ≈ exp(x)
    @test sign(LogNum(x)) == sign(x)
end

for x = 0.:5., y = -5.:5.
    if x ≠ 0 || y ≠ 0
        @test isapprox(LogNum(x) ^ LogNum(y), x ^ y; atol=1e-12)
        @test isapprox(LogNum(x) ^ y, x ^ y; atol=1e-12)
        @test isapprox(x ^ LogNum(y), x ^ y; atol=1e-12)
    end
end

for x = -10.:10., y = -10.:10.
    @test LogNum(x) + LogNum(y) ≈ x + y
    @test LogNum(x) - LogNum(y) ≈ x - y
    @test LogNum(x) * LogNum(y) ≈ x * y
    if x ≠ 0 || y ≠ 0
        @test LogNum(x) / LogNum(y) ≈ x / y
    end
end

@test LogNum(5.)^LogNum(2.) ≈ 5.^2.
@test LogNum(5.)^LogNum(-2.) ≈ 5.^-2.
@test LogNum(5.)^LogNum(0) ≈ 1
@test LogNum(0)^LogNum(1) ≈ 0
@test LogNum(0) ^ LogNum(0) == 1
@test LogNum(4) ^ 2 ≈ 4^2