#!/usr/bin/env julia
# color chart: http://juliagraphics.github.io/Colors.jl/stable/namedcolors/

using Plots
using Statistics
using Colors

gr()

n = 5;
x = 50 .* rand(n) .- 25;
y = 30 .* rand(n) .- 15;

px = x;
py = y;

t = range(-π, π, length = 100)
plot(
    0,
    0,
    legend = :none,
    aspect_ratio = :equal,
    border = :none,
    axis = nothing,
    background_color = :white,
    xlim = [-25, 25],
    ylim = [-15, 15],
)

function foo(x, y, px, py)
    for i = 1:n
        d = (x[i] .- px[i+1:end]) .^ 2 + (y[i] .- py[i+1:end]) .^ 2
        r = sqrt(min(d...)) - 0.4

        if r < 0
            r = 0
        end

        cx = x[i] .+ r .* cos.(t)
        cy = y[i] .+ r .* sin.(t)

        px = [px; cx]
        py = [py; cy]

        plot!(
            cx,
            cy,
            legend = :none,
            aspect_ratio = :equal,
            grid = false,
            border = :none,
            axis = nothing,
            lw = 0.5,
            color = :grey66,
        )
    end
    return px, py
end

function foo2(px, py)
    for i = 1:200
        x = 50 .* rand(n) .- 25
        y = 30 .* rand(n) .- 15
        px, py = foo(x, y, px, py)
    end
end

px, py = foo(x, y, px, py)

foo2(px, py)

display(plot!(
    0,
    0,
    legend = :none,
    aspect_ratio = :equal,
    border = :none,
    axis = nothing,
))
savefig("circles.svg")
savefig("circles.png")
