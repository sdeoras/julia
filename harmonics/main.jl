#!/usr/bin/env julia
using VegaLite, VegaDatasets, DataFrames, Query
println("loaded packages")

cars = dataset("cars")

cars |> @select(:Acceleration, :Name) |> collect

struct OneHot <: AbstractVector{Int}
    n::Int
    k::Int
end

Base.size(x::OneHot) = (x.n,)
Base.getindex(x::OneHot, i::Int) = Int(i == x.k)

x = OneHot(10, 3)
println(sizeof(x))
println(sizeof(collect(x)))

y = ones(Int, 10)

p = parse(Int64, "FF", base=16)
s = string(p, base=10, pad=0)

t = time()

function distance(x₁, y₁, x₂, y₂)
    return sqrt((x₁ - x₂)^2 + (y₁ - y₂)^2)
end

println(distance(1, 1, 2, 2))

using Plots
plot(randn(100, 1))

y = factorial(big(21))

function myfactorial(n::Int)
    if n == 0
        return UInt64(1)
    else
        r = myfactorial(n-1)
        return UInt64(n) * r
    end
end

y = myfactorial(21)
myfactorial(90)

outer(n, m) = [x*y for x in n, y in m]

z = outer(1:10, 1:10)
sizeof(z)
