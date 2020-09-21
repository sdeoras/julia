### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

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

# ╔═╡ 315269fa-fc2f-11ea-1627-6516612d6e40
md"""
## Cartesian and Polar Coordinates
Define types for capturing cartesian and polar coordinates and also the functions
for converting from one type to the other
"""

# ╔═╡ e1845bee-fc2f-11ea-037c-51e8f87d5b64
md"""
```julia
PointXY(x::Float64, y::Float64)
PointRT(t::Float64, r::FLoat64)
Cart2Pol(point::PointXY) returns PointRT
Pol2Cart(point::PointRT) returns PointXY
ToMatrix(points::Array{PointXY,1}) returns Array{Float64,1}
ToMatrix(points::Array{PointRT,1}) returns Array{Float64,1}
```
"""

# ╔═╡ 5d40a36e-fc12-11ea-3315-af8b6707c005
abstract type Point end

# ╔═╡ a1122986-fc0e-11ea-221f-07661d625120
struct PointXY <: Point
	x::Float64
	y::Float64
end

# ╔═╡ 17768a5e-fc0f-11ea-1714-a57a1e60688c
struct PointRT <: Point
	t::Float64
	r::Float64
end

# ╔═╡ 206d052a-fc0f-11ea-3fb1-8fca4102e048
function Cart2Pol(point::PointXY) # returns PointRT
	return PointRT(atan(point.y, point.x), sqrt(point.x^2 + point.y^2))
end

# ╔═╡ fc1f5284-fc10-11ea-330b-9774fa4e24ec
function Pol2Cart(point::PointRT) # returns PointXY
	return PointXY(point.r * cos(point.t), point.r * sin(point.t))
end

# ╔═╡ c42c83d2-fc11-11ea-2f54-3fa05e98c488
begin
	
function ToMatrix(points::Array{PointRT,1}) # returns Array{Float64,2}
	out = Array{Float64,2}(undef, length(points), 2)
	if length(points) == 0
		return out
	end
	
	for i in 1:length(points)
		out[i,1] = points[i].t
		out[i,2] = points[i].r
	end
	
	return out
end
	
function ToMatrix(points::Array{PointXY,1}) # returns Array{Float64,2}
	out = Array{Float64,2}(undef, length(points), 2)
	if length(points) == 0
		return out
	end
	
	for i in 1:length(points)
		out[i,1] = points[i].x
		out[i,2] = points[i].y
	end
	
	return out
end
	
end

# ╔═╡ 42992932-fc35-11ea-330d-6bd171dd6755
function Interpolate(points::Array{PointRT,1}; N::Int=-1) # returns Array{PointRT,1}
	if N <= 0
		N = length(points)
	end
	
	t = [points[i].t for i in 1:length(points)]
	r = [points[i].r for i in 1:length(points)]
	tInterpol = range(minimum(t), maximum(t), length=N)
	rInterpol = LinearInterpolation(t, r).(tInterpol)
	pointsInterpol = [PointRT(tInterpol[i], rInterpol[i]) for i in 1:N]
	return pointsInterpol
end

# ╔═╡ 1f336092-fc11-11ea-377f-dbc84398ac15
θ = range(-π, π, length=128)

# ╔═╡ 595a2372-fc11-11ea-0f20-8b94910bed42
r = ones(length(θ))

# ╔═╡ 66fa3916-fc11-11ea-26a7-73a42ef0e1f7
pointsRT = [PointRT(θ[i], r[i]) for i in 1:length(θ)]

# ╔═╡ a12c72fe-fc11-11ea-2e3c-05489c8541f5
pointsXY = Pol2Cart.(pointsRT)

# ╔═╡ abe34daa-fc30-11ea-2e46-f94160ca7d81
points = ToMatrix(pointsXY)

# ╔═╡ 06098f2e-fc31-11ea-00d3-51dc2481e795
plot(points[:,1], points[:,2])

# ╔═╡ a0f6dafa-fc31-11ea-103e-2536d823c42d
pointsRTRegen = Cart2Pol.(pointsXY)

# ╔═╡ 60bc6a94-fc32-11ea-0309-298649f8b9f1
pointsRTArray = ToMatrix(pointsRTRegen)

# ╔═╡ 04ac15dc-fc33-11ea-1585-45c021af97e8
md"""
Plot below shows that the `θ` computed after transforming from cartesian to polar
is exactly the same as original `θ` and between `-π` to `π`
"""

# ╔═╡ 7e246674-fc32-11ea-1d8a-79daf2dda484
plot([θ, pointsRTArray[:,1]])

# ╔═╡ d519d7da-fb94-11ea-3697-c7441d63357a
md"""
### Harmonics
`Harmonics(signal, N)` returns `N` harmonics for signal which is assumed
to be over one cycle and equally time spaced.
```text
# generate θ ranging over one cycle
begin
	θ = range(-π, π, length=128)
	y = 10 .* cos.(5 .* θ) .+ 7 .* cos.(10 .* θ .+ π/6)
	plot(θ, y)
end
```
Then compute 10 harmonics for such data
```julia
F = Harmonics(y, 10)
```
"""

# ╔═╡ afd190f6-fac4-11ea-1d43-d3f5f762572d
function Harmonics(signal::Array{Float64,1}, N::Int)
	T = length(signal)
	t = collect(range(1, T, step=1))
	
	result = Array{Float64,2}(undef, N+1, 2)
	
	for n in 1:N+1
		an = sum(2/T .* (signal .* cos.(2*π*n*t/T)))
        bn = sum(2/T .* (signal .* sin.(2*π*n*t/T)))
		result[n,1] = an
		result[n,2] = bn
	end
	
	return result
end

# ╔═╡ 527d624e-fb97-11ea-13f1-97f18e2360da
md"""
Generate(F, N) reconstructs the signal using harmonics in F. It will
generate an output of length N
"""

# ╔═╡ ec2e6c32-fb45-11ea-3aa6-5fbc364d65aa
function Generate(F::Array{Float64,2}, N::Int; offset::Float64=0.0)
	result = 0
	t = collect(1:N)
	for n in 1:length(F[:,1])
		an = F[n,1]
		bn = F[n,2]
		if n == 1
			an = an/2
		end
		result = result .+ an .* cos.(2*π*n .* t/N) + bn .* sin.(2*π*n .* t/N)
	end
	
	if offset != 0
		result .+= offset
	end
	
	return result
end

# ╔═╡ 509ac730-fc43-11ea-390f-db3e29dbb740
function HarmonicRegen(points::Array{PointRT,1}; numHarmonics::Int=10, N::Int=-1)
	if N <= 0
		N = length(points)
	end
	
	pointsInterpol = Interpolate(points, N=N)
	
	F = Harmonics([pointsInterpol[i].r for i in 1:N], numHarmonics)
	
	offset = mean([pointsInterpol[i].r for i in 1:N])
	
	r = Generate(F, N, offset=offset)
	
	out = Array{PointRT,1}(undef, N)
	for i in 1:N
		out[i] = PointRT(pointsInterpol[i].t, r[i])
	end
	
	return out
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
Harmonics(func1(t), 10)

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
F = Harmonics(fi, 5)

# ╔═╡ 650123ce-fb47-11ea-2b95-25d6f1fa666f
typeof(F)

# ╔═╡ 14225b74-fae0-11ea-02ab-3357c3cf8482
scatter(F)

# ╔═╡ 0fa6c9fe-fae0-11ea-1f12-39aa30bfd045
fo = Generate(F, length(t), offset=mean(fi))

# ╔═╡ 54464120-fb49-11ea-148a-8b0e38c24058
plot([fi, fo])

# ╔═╡ b766b1ba-fb97-11ea-2444-b9d24f380150
md"""
## Approximate square shape with harmonics
"""

# ╔═╡ 288afba2-fc48-11ea-17d9-e1af0fabbcf7
function PlotHarmonics(x::Array{Float64,1}, y::Array{Float64,1})
	squareShapeXY = [PointXY(x[i], y[i]) for i in 1:length(x)]
	
	squareShapeRT = Cart2Pol.(squareShapeXY)
	
	plot(ToMatrix(squareShapeXY)[:,1], ToMatrix(squareShapeXY)[:,2])

	squareShapeRTRegen = HarmonicRegen(squareShapeRT, numHarmonics=1, N=1024)
	squareShapeXYRegen = Pol2Cart.(squareShapeRTRegen)
	plot!(ToMatrix(squareShapeXYRegen)[:,1], ToMatrix(squareShapeXYRegen)[:,2])
	
	squareShapeRTRegen = HarmonicRegen(squareShapeRT, numHarmonics=2, N=1024)
	squareShapeXYRegen = Pol2Cart.(squareShapeRTRegen)
	plot!(ToMatrix(squareShapeXYRegen)[:,1], ToMatrix(squareShapeXYRegen)[:,2])

	squareShapeRTRegen = HarmonicRegen(squareShapeRT, numHarmonics=5, N=1024)
	squareShapeXYRegen = Pol2Cart.(squareShapeRTRegen)
	plot!(ToMatrix(squareShapeXYRegen)[:,1], ToMatrix(squareShapeXYRegen)[:,2])

	squareShapeRTRegen = HarmonicRegen(squareShapeRT, numHarmonics=10, N=1024)
	squareShapeXYRegen = Pol2Cart.(squareShapeRTRegen)
	plot!(ToMatrix(squareShapeXYRegen)[:,1], ToMatrix(squareShapeXYRegen)[:,2])

	squareShapeRTRegen = HarmonicRegen(squareShapeRT, numHarmonics=20, N=1024)
	squareShapeXYRegen = Pol2Cart.(squareShapeRTRegen)
	plot!(ToMatrix(squareShapeXYRegen)[:,1], ToMatrix(squareShapeXYRegen)[:,2])

	squareShapeRTRegen = HarmonicRegen(squareShapeRT, numHarmonics=100, N=1024)
	squareShapeXYRegen = Pol2Cart.(squareShapeRTRegen)
	plot!(ToMatrix(squareShapeXYRegen)[:,1], ToMatrix(squareShapeXYRegen)[:,2])
end

# ╔═╡ 298b36b4-fc45-11ea-3518-ef93ed876520
begin
	squareShapeX = [-1 .* ones(10); range(-1, 1, length=20); ones(20); range(1, -1, length=20); -1 .* ones(10)]
	squareShapeY = [range(-0.0001, -1, length=10); -1 .* ones(20); range(-1, 1, length=20); ones(20); range(1, 0, length=10)]
	PlotHarmonics(squareShapeX, squareShapeY)
end

# ╔═╡ Cell order:
# ╠═ad2f45dc-fa9c-11ea-1915-61fccda8541e
# ╟─e445c072-fb4c-11ea-14d8-8dcf5289d14f
# ╠═fa1673aa-fa9c-11ea-1200-316f7ef2a7a8
# ╟─315269fa-fc2f-11ea-1627-6516612d6e40
# ╟─e1845bee-fc2f-11ea-037c-51e8f87d5b64
# ╠═5d40a36e-fc12-11ea-3315-af8b6707c005
# ╠═a1122986-fc0e-11ea-221f-07661d625120
# ╠═17768a5e-fc0f-11ea-1714-a57a1e60688c
# ╠═206d052a-fc0f-11ea-3fb1-8fca4102e048
# ╠═fc1f5284-fc10-11ea-330b-9774fa4e24ec
# ╠═c42c83d2-fc11-11ea-2f54-3fa05e98c488
# ╠═42992932-fc35-11ea-330d-6bd171dd6755
# ╠═1f336092-fc11-11ea-377f-dbc84398ac15
# ╠═595a2372-fc11-11ea-0f20-8b94910bed42
# ╠═66fa3916-fc11-11ea-26a7-73a42ef0e1f7
# ╠═a12c72fe-fc11-11ea-2e3c-05489c8541f5
# ╠═abe34daa-fc30-11ea-2e46-f94160ca7d81
# ╠═06098f2e-fc31-11ea-00d3-51dc2481e795
# ╠═a0f6dafa-fc31-11ea-103e-2536d823c42d
# ╠═60bc6a94-fc32-11ea-0309-298649f8b9f1
# ╟─04ac15dc-fc33-11ea-1585-45c021af97e8
# ╠═7e246674-fc32-11ea-1d8a-79daf2dda484
# ╟─d519d7da-fb94-11ea-3697-c7441d63357a
# ╠═afd190f6-fac4-11ea-1d43-d3f5f762572d
# ╟─527d624e-fb97-11ea-13f1-97f18e2360da
# ╠═ec2e6c32-fb45-11ea-3aa6-5fbc364d65aa
# ╠═509ac730-fc43-11ea-390f-db3e29dbb740
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
# ╠═b766b1ba-fb97-11ea-2444-b9d24f380150
# ╠═288afba2-fc48-11ea-17d9-e1af0fabbcf7
# ╠═298b36b4-fc45-11ea-3518-ef93ed876520
