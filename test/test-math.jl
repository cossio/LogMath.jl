@test inf(1.) == inf(Float64) == Inf
@test inf(Float16(1.)) == inf(Float16) == Inf16
@test_throws InexactError inf(Int)

for x = 0.:0.1:10.
    @test log1mexp(x) ≈ log(1 - exp(-x))
end

for x = -100.:0.
    @test log1pexp(x) ≈ log(1 + exp(x)) atol=1e-14
end

for x = 0.:100.
    @test log1pexp(x) ≈ x + log(exp(-x) + 1) atol=1e-14
end

for x = 0.:10., y = 0.:10.
    @test logadd(log(x), log(y)) ≈ log(x + y)
    @test logsub(log(x), log(y)) ≈ log(abs(x - y)) atol=1e-14
end


for x = 0.:10., y = 0.:10., z = 0.:10.
    @test logadd(log(x), log(y), log(z)) ≈ log(x + y + z)
end


for rep = 1 : 100
    x = 10rand(10)
    lx = log.(x)
    if logadd(lx...) ≈ log(sum(x))
        @test true
        @test logadd(lx[1],lx[2],lx[3],lx[4],lx[5],lx[6],lx[7],lx[8],lx[9],lx[10]) ≈ log(sum(x))
    else
        println("logadd reduce test failed, with x=$x")
        @test false
    end
end
