using Plots
gr()

function pattern(θ)
    t = range(0, step=θ, length=800)
    r = range(0, stop=1, length=length(t))
    x = r.*cos.(t)
    y = r.*sin.(t)
    scatter(x, y, size=(500,450), legend=false, xlims=[-1, 1], ylims=[-1, 1])
end

θf = 2.39996322972865332 # golden ratio
for θ in range(0, stop=θf, length=1024)
    display(pattern(θ))
    sleep(0.1)
end
