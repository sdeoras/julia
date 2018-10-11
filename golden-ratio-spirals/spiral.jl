using Plots
gr()

# pattern takes angle of shift θ
# and makes a spiral polar plot.
function pattern(θ::Float64, title::String="")
    t = range(0, step=θ, length=800)
    r = range(0, stop=1, length=length(t))
    x = r.*cos.(t)
    y = r.*sin.(t)
    scatter(x, y, size=(500,450), legend=false, xlims=[-1, 1], ylims=[-1, 1], title=title)
end

#==
given a line broken down into two parts 'a' and 'b'
    |---------------|------|
            a           b
ϕ = a/b iff a/b == (a+b)/a
ϕ is called golden ratio and can be solved quadratically
ϕ = (1 + √5)/2

applying the golden ratio to lengths of two arcs in a circle
θ = 2π(1-1/ϕ) = 2π(2-ϕ) = 2π/ϕ^2 = π(3-√5)
Ref: https://en.wikipedia.org/wiki/Golden_angle
==#

g = π*(3-√5) # golden angle
n = 1024 # number of steps to go from 2 to g
for (i,θ) in enumerate(range(2, stop=g, length=n))
    display(pattern(θ, string(lpad("$i", 4), "/", lpad("$n", 4))))
end
