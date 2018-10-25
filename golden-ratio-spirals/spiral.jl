using Plots
gr()

# pattern takes angle of shift θ
# and makes a spiral polar plot.
function pattern(θ::Float64)
    t = range(0, step=θ, length=800)
    r = range(0, stop=1, length=length(t))
    x = r.*cos.(t)
    y = r.*sin.(t)
    return (x, y)
end

function drawSpirals(data, title)
    x, y = data
    scatter(x, y, size=(500,450), legend=false, xlims=[-1, 1], ylims=[-1, 1], title=title)
end

#
# given a line broken down into two parts 'a' and 'b'
#    |---------------|------|
#            a           b
# ϕ = a/b iff a/b == (a+b)/a
# ϕ is called golden ratio and can be solved quadratically
# ϕ = (1 + √5)/2
#
# applying the golden ratio to lengths of two arcs in a circle
# θ = 2π(1-1/ϕ) = 2π(2-ϕ) = 2π/ϕ^2 = π(3-√5)
# Ref: https://en.wikipedia.org/wiki/Golden_angle
#

θ = π*(3-√5) # golden angle
drawSpirals(pattern(θ), "golden ratio")

drawSpirals(pattern(rand()), "a rand number")

drawSpirals(pattern(rand()), "a rand number")

drawSpirals(pattern(rand()), "a rand number")

drawSpirals(pattern(rand()), "a rand number")

drawSpirals(pattern(rand()), "a rand number")

drawSpirals(pattern(rand()), "a rand number")

drawSpirals(pattern(rand()), "a rand number")

