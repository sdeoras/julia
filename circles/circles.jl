#!/usr/bin/env julia

using Plots
using Statistics

gr()

n = 5;
x = 30 .* rand(n) .- 15;
y = 30 .* rand(n) .- 15;

px = x;
py = y;

t = range(-π, π, length = 100)
plot(0, 0, legend = :none, aspect_ratio = :equal, border = nothing, axis = nothing)

function foo(x, y, px, py)
    for i = 1:n
        d = (x[i] .- px[i+1:end]) .^ 2 + (y[i] .- py[i+1:end]) .^ 2
        r = sqrt(min(d...)) - 0.001
        cx = x[i] .+ r .* cos.(t)
        cy = y[i] .+ r .* sin.(t)

        px = [px; cx]
        py = [py; cy]

        plot!(cx, cy, legend = :none, aspect_ratio = :equal, grid = false, border = nothing, axis = nothing)
    end
    return px, py
end

function foo2(px, py)
    for i = 1:40
        x = 30 .* rand(n) .- 15
        y = 30 .* rand(n) .- 15
        px, py = foo(x, y, px, py)
    end
end

px, py = foo(x, y, px, py)

foo2(px, py)

display(plot!(0, 0, legend = :none, aspect_ratio = :equal, border = nothing, axis = nothing))
savefig("circles.svg")
