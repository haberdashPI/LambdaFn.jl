using LambdaFn
using Test

@testset "LambdaFn.jl" begin
    @test @λ(_ + _)(1,2) == 3
    @test @λ(_a + _b*_a)(3,2) == 9
    @test_throws Exception @eval(@λ(_ + _1))
end
