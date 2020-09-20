### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ ad2f45dc-fa9c-11ea-1915-61fccda8541e
using Colors, Plots, Polynomials, Images, ImageView, PlutoUI, LinearAlgebra, DSP, AbstractFFTs, Interpolations, CoordinateTransformations, Statistics

# ╔═╡ e445c072-fb4c-11ea-14d8-8dcf5289d14f
md"""
### References
* [fourier series harmonic approximation](https://dspillustrations.com/pages/posts/misc/fourier-series-and-harmonic-approximation.html)
"""

# ╔═╡ fa1673aa-fa9c-11ea-1200-316f7ef2a7a8
function imagesc(x; degree=1, colorScheme="oranges")
	# using Polynomials, Colors
	# Blues, Greens, Grays, Oranges, Purples, Reds
	xvec = sort(vec(x))
	p = fit(convert.(Float64, xvec), 1:length(xvec), degree)
	
	y1 = floor.(Int, p.(x))
	y = (y1 .- minimum(y1)) .+ 1
	
	cmap = colormap(colorScheme, maximum(y))
	yvec = [cmap[i] for i in y]
	
	if ndims(x) == 2
		out = reshape(yvec, size(x))
	else
		out = reshape(yvec, (1, length(yvec)))
	end
	
	return out
end

# ╔═╡ 69f8c0e2-fa9f-11ea-319e-fb543cdce8eb
outer(v, w) = [x*y for x in v, y in w]

# ╔═╡ a70b08be-fa9d-11ea-3a00-e9c997cd9fb0
@bind n Slider(2:100, default=10)

# ╔═╡ bf4f3868-faa0-11ea-2398-ffdd90a6cd4d
@bind k Slider(0:25, default=10)

# ╔═╡ 9cd71b4e-fa9f-11ea-3626-9930097687f5
begin
	d1 = outer(1:n, 1:n);
	d2 = d1 .+ k*randn(n, n);
end;

# ╔═╡ 1700b040-faa0-11ea-038e-2b805e10bd10
imagesc([d1 d2])

# ╔═╡ a05d96fc-faaa-11ea-1743-e1cd4d1337be
θ = range(-π, π, length=1024)

# ╔═╡ 62a209fa-fac4-11ea-3861-4999811ba678
r = DSP.Windows.hanning(1024)

# ╔═╡ b6a52078-fac4-11ea-042d-39539a00c325
x = r .* cos.(θ)

# ╔═╡ cd198c04-fac4-11ea-1e98-d3ea7d987d4a
y = r .* sin.(θ)

# ╔═╡ d4340bfe-fac4-11ea-3097-fdac1a2f794c
scatter(x, y)

# ╔═╡ afd190f6-fac4-11ea-1d43-d3f5f762572d
function fourierSeries(period, N)
	T = length(period)
	tt = collect(range(1, T, step=1))
	result = Array{Float64,2}(undef, N+1, 2)
	for n in 1:N+1
		an = sum(2/T .* (period .* cos.(2*π*n*tt/T)))
        bn = sum(2/T .* (period .* sin.(2*π*n*tt/T)))
		result[n,1] = an
		result[n,2] = bn
	end
	
	return result
end

# ╔═╡ ec2e6c32-fb45-11ea-3aa6-5fbc364d65aa
function reconstruct(P, anbn)
	result = 0
	t = collect(1:P)
	for n in 1:length(anbn[:,1])
		if n == 1
			anbn[n,1] = anbn[n,1]/2
		end
		result = result .+ anbn[n,1] .* cos.(2*π*n .* t/P) + anbn[n,2] .* sin.(2*π*n .* t/P)
	end
	return result
end

# ╔═╡ 8684d4e4-fae0-11ea-3f5b-35bb56f2245c
begin
	func1(t) = Float64.(abs.((t.%1).-0.25) .< 0.25) - Float64.(abs.((t.%1).-0.75) .< 0.25)
	func2(t) = t .% 1
	func3(t) = Float64.(abs.((t.%1).-0.5) .< 0.25) + 8 .* (abs.((t.%1).-0.5)) .* (abs.((t.%1).-0.5).<0.25)
	func4(t) = ((t.%1).-0.5).^2
end

# ╔═╡ ca2fedc8-fae0-11ea-02d0-99eca6ea8998
Fs = 10000

# ╔═╡ c4818c30-fae0-11ea-1584-c3ef3f06d883
t = collect(range(0, 1, step=1/Fs))

# ╔═╡ 1e90f210-fb45-11ea-3e76-15ff13c97c27
fourierSeries(func1(t), 10)

# ╔═╡ 096f6f22-fae1-11ea-321c-070b146e5a38
plot(t, func1(t))

# ╔═╡ 62f06ade-fae2-11ea-3cd1-65bf6e99b737
plot(t, func2(t))

# ╔═╡ 674a1240-fae2-11ea-3fbf-f9e5a401890c
plot(t, func3(t))

# ╔═╡ 6b9cb8a2-fae2-11ea-1245-5179aef0fb4f
plot(t, func4(t))

# ╔═╡ 7bc28862-fb49-11ea-3a89-8df4ea631218
fi = func3(t)

# ╔═╡ 3381dd16-fade-11ea-329f-e576edd15341
F = fourierSeries(fi, 5)

# ╔═╡ 650123ce-fb47-11ea-2b95-25d6f1fa666f
typeof(F)

# ╔═╡ 14225b74-fae0-11ea-02ab-3357c3cf8482
scatter(F)

# ╔═╡ 0fa6c9fe-fae0-11ea-1f12-39aa30bfd045
fo = reconstruct(length(t), F)

# ╔═╡ 54464120-fb49-11ea-148a-8b0e38c24058
plot([fi, fo])

# ╔═╡ b15e4618-fb4a-11ea-3833-95e7025ea329
θ2 = range(-π, π, length=length(fi))

# ╔═╡ f1c4cd12-fb4a-11ea-32fa-2707c027195e
xi = (10 .+ fo) .* cos.(θ2)

# ╔═╡ 1fce282a-fb4b-11ea-2c5a-c741af47d0c4
yi = (10 .+ fo) .* sin.(θ2)

# ╔═╡ 28ba625a-fb4b-11ea-0d76-71fcc77f49f2
plot(xi, yi)

# ╔═╡ 9107ffda-fb68-11ea-0a89-05643af7247e
squareShapeX = [-1 .* ones(10); range(-1, 1, length=20); ones(20); range(1, -1, length=20); -1 .* ones(10)]

# ╔═╡ 658e316a-fb6a-11ea-3516-dd016af1c1c1
squareShapeY = [range(0, -1, length=10); -1 .* ones(20); range(-1, 1, length=20); ones(20); range(1, 0, length=10)]

# ╔═╡ 7a70d3d2-fb6a-11ea-0655-ddf3a7d7a2a6
plot(squareShapeX, squareShapeY)

# ╔═╡ 87e45fc8-fb6a-11ea-3907-872386e8586e
squareShapeR = [sqrt(squareShapeX[p]^2+squareShapeY[p]^2) for p in 1:length(squareShapeX)]

# ╔═╡ c53af814-fb6a-11ea-2489-2b71390f055c
squareShapeθ = [acos(squareShapeX[p]/squareShapeR[p]) for p in 1:length(squareShapeX)]

# ╔═╡ 69076680-fb6b-11ea-17cc-d938ec0ad0b8
extrema(squareShapeθ)

# ╔═╡ f7f3a59c-fb6c-11ea-388f-1f180370668b
squareShapeθ[1:length(squareShapeθ)÷2] .*= -1

# ╔═╡ 7a65778a-fb7c-11ea-1dae-e731e02270f4
plot(squareShapeθ)

# ╔═╡ 87c98b1e-fb7c-11ea-1f99-73519c7a073f
plot(squareShapeR .* cos.(squareShapeθ), squareShapeR .* sin.(squareShapeθ))

# ╔═╡ 912de89e-fb7c-11ea-2a1c-61ae7ae9b5bb
squareShapeθi = range(-π, π, length=1024)

# ╔═╡ f2849a48-fb7c-11ea-3d93-b7236c841b16
squareShapeRi = LinearInterpolation(squareShapeθ, squareShapeR).(squareShapeθi)

# ╔═╡ 0a1cfa24-fb7d-11ea-3a45-e125ae7e59c0
plot(squareShapeRi .* cos.(squareShapeθi), squareShapeRi .* sin.(squareShapeθi))

# ╔═╡ 149ae8b0-fb7d-11ea-2c3a-0582d66a4a60
squaredHarmonics = fourierSeries(squareShapeRi, 10)

# ╔═╡ 50fb7ff6-fb7d-11ea-1bb1-737fb34df467
squareShapeRiRecon = reconstruct(length(squareShapeRi), squaredHarmonics)

# ╔═╡ 7b5ac25e-fb7d-11ea-34d9-0dd23e65290c
plot([squareShapeRiRecon .+ mean(squareShapeRi), squareShapeRi])

# ╔═╡ f3473052-fb7d-11ea-1f56-7b0c95747fce
squareShapeRiRecon .+= mean(squareShapeRi)

# ╔═╡ e559d29c-fb7d-11ea-3c57-c56ab51c9d2b
begin
	plot(squareShapeRi .* cos.(squareShapeθi), squareShapeRi .* sin.(squareShapeθi))
	plot!(squareShapeRiRecon .* cos.(squareShapeθi), squareShapeRiRecon .* sin.(squareShapeθi))
end

# ╔═╡ Cell order:
# ╠═ad2f45dc-fa9c-11ea-1915-61fccda8541e
# ╟─e445c072-fb4c-11ea-14d8-8dcf5289d14f
# ╠═fa1673aa-fa9c-11ea-1200-316f7ef2a7a8
# ╠═69f8c0e2-fa9f-11ea-319e-fb543cdce8eb
# ╠═a70b08be-fa9d-11ea-3a00-e9c997cd9fb0
# ╠═bf4f3868-faa0-11ea-2398-ffdd90a6cd4d
# ╠═9cd71b4e-fa9f-11ea-3626-9930097687f5
# ╠═1700b040-faa0-11ea-038e-2b805e10bd10
# ╠═a05d96fc-faaa-11ea-1743-e1cd4d1337be
# ╠═62a209fa-fac4-11ea-3861-4999811ba678
# ╠═b6a52078-fac4-11ea-042d-39539a00c325
# ╠═cd198c04-fac4-11ea-1e98-d3ea7d987d4a
# ╠═d4340bfe-fac4-11ea-3097-fdac1a2f794c
# ╠═afd190f6-fac4-11ea-1d43-d3f5f762572d
# ╠═ec2e6c32-fb45-11ea-3aa6-5fbc364d65aa
# ╠═8684d4e4-fae0-11ea-3f5b-35bb56f2245c
# ╠═ca2fedc8-fae0-11ea-02d0-99eca6ea8998
# ╠═c4818c30-fae0-11ea-1584-c3ef3f06d883
# ╠═1e90f210-fb45-11ea-3e76-15ff13c97c27
# ╠═096f6f22-fae1-11ea-321c-070b146e5a38
# ╠═62f06ade-fae2-11ea-3cd1-65bf6e99b737
# ╠═674a1240-fae2-11ea-3fbf-f9e5a401890c
# ╠═6b9cb8a2-fae2-11ea-1245-5179aef0fb4f
# ╠═7bc28862-fb49-11ea-3a89-8df4ea631218
# ╠═3381dd16-fade-11ea-329f-e576edd15341
# ╠═650123ce-fb47-11ea-2b95-25d6f1fa666f
# ╠═14225b74-fae0-11ea-02ab-3357c3cf8482
# ╠═0fa6c9fe-fae0-11ea-1f12-39aa30bfd045
# ╠═54464120-fb49-11ea-148a-8b0e38c24058
# ╠═b15e4618-fb4a-11ea-3833-95e7025ea329
# ╠═f1c4cd12-fb4a-11ea-32fa-2707c027195e
# ╠═1fce282a-fb4b-11ea-2c5a-c741af47d0c4
# ╠═28ba625a-fb4b-11ea-0d76-71fcc77f49f2
# ╠═9107ffda-fb68-11ea-0a89-05643af7247e
# ╠═658e316a-fb6a-11ea-3516-dd016af1c1c1
# ╠═7a70d3d2-fb6a-11ea-0655-ddf3a7d7a2a6
# ╠═87e45fc8-fb6a-11ea-3907-872386e8586e
# ╠═c53af814-fb6a-11ea-2489-2b71390f055c
# ╠═69076680-fb6b-11ea-17cc-d938ec0ad0b8
# ╠═f7f3a59c-fb6c-11ea-388f-1f180370668b
# ╠═7a65778a-fb7c-11ea-1dae-e731e02270f4
# ╠═87c98b1e-fb7c-11ea-1f99-73519c7a073f
# ╠═912de89e-fb7c-11ea-2a1c-61ae7ae9b5bb
# ╠═f2849a48-fb7c-11ea-3d93-b7236c841b16
# ╠═0a1cfa24-fb7d-11ea-3a45-e125ae7e59c0
# ╠═149ae8b0-fb7d-11ea-2c3a-0582d66a4a60
# ╠═50fb7ff6-fb7d-11ea-1bb1-737fb34df467
# ╠═7b5ac25e-fb7d-11ea-34d9-0dd23e65290c
# ╠═f3473052-fb7d-11ea-1f56-7b0c95747fce
# ╠═e559d29c-fb7d-11ea-3c57-c56ab51c9d2b
