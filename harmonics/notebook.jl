### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 824aedd0-f9ac-11ea-3165-ebeb9fdd3b09
using Images, ImageView

# ╔═╡ 0fc5fa8c-fa0d-11ea-034c-db157acf15af
using Polynomials

# ╔═╡ 6dc6e762-fa77-11ea-0d41-c1b4d72bdbd8
using Plots

# ╔═╡ b1eac74a-fa7c-11ea-0eee-0b53bb1c9c1d
using Colors

# ╔═╡ c37cb624-f9ac-11ea-0daf-b7bc0b6d1472
RGBA(0.1, 0.2, 0.3)

# ╔═╡ e881937e-f9ac-11ea-2e14-1f134825a637
im = [RGBA(x, y, x+y) for x in 0:0.1:1, y in 0:0.1:1]

# ╔═╡ 54b42fac-f9ad-11ea-0bce-c3e1d1a29432
im2 = [RGBA(x, y, x*y) for x in 0:0.1:1, y in 0:0.01:1]

# ╔═╡ d00e11bc-f9ae-11ea-16d3-ef144122f406
download("https://upload.wikimedia.org/wikipedia/commons/2/21/Matlab_Logo.png", "matlab.png")

# ╔═╡ 204a0a0c-f9af-11ea-0014-79d4501290f2
matlab = load("matlab.png")

# ╔═╡ 175fd906-f9af-11ea-303a-334574d331f6
typeof(matlab)

# ╔═╡ b0aa5454-f9b1-11ea-0d10-33669f6cf285
im4 = rand(RGBA{Normed{UInt8,8}}, 10, 10)

# ╔═╡ 27d43112-f9b2-11ea-17cc-bf3f7030d266
im5 = [RGBA{N0f8}(x, y, x*y, 1) for x in 0:0.1:1, y in 0:0.1:1]

# ╔═╡ 96d7db0a-f9b3-11ea-11c3-bb1b76a980f6
r = rand(10, 10)

# ╔═╡ 9f4a8cc2-f9b3-11ea-3dac-614a0b0320a5
im6 = RGBA{N0f8}.(r, r, r, 1)

# ╔═╡ 10e3be12-f9b4-11ea-3a51-b19321b1f843
cc = distinguishable_colors(128)

# ╔═╡ 57ce0f26-fa09-11ea-0610-fbb4bc94dd1d
im7 = rand(cc, 30, 30)

# ╔═╡ 7febeadc-fa09-11ea-3bda-bb10872c4d57
minimum(r)

# ╔═╡ 4c43bb5a-fa0c-11ea-0559-31edbcd3645c
maximum(r)

# ╔═╡ 555eb38a-fa0c-11ea-3c4d-f95bfa1733f3
rn = (r .- minimum(r)) ./ maximum(r) .* 100

# ╔═╡ e8614c1c-fa0c-11ea-1243-9b7ed1c375f6
typeof(rn)

# ╔═╡ bcf73472-fa75-11ea-22f1-6dde1e46620c
x = randn(100)

# ╔═╡ d215755a-fa75-11ea-320b-735ab1aec0b4
(minimum(x), maximum(x))

# ╔═╡ b9249cd6-fa77-11ea-18d5-a1db0f50742a
sort!(x)

# ╔═╡ f061476c-fa77-11ea-31a9-3b9f1a863575
plot(x, 1:100)

# ╔═╡ 0848650e-fa78-11ea-1fb8-59b6af077bae
p = fit(x, 1:100, 1)

# ╔═╡ 7558fe6a-fa78-11ea-0c6b-5faddf40231a
begin
	plot(x, 1:100)
	plot!(x, p.(x))
end

# ╔═╡ b6e2237a-fa78-11ea-04b6-05a49f435964
y = p.(x)

# ╔═╡ bd5db5de-fa78-11ea-001e-21490c4c711c
z = y .- minimum(y) .+ 1

# ╔═╡ 383fa76c-fa79-11ea-2378-3722e5ce0291
typeof(z)

# ╔═╡ 3ed9f992-fa79-11ea-2167-b5a5ca4dcc69
z2 = floor.(Int, z)

# ╔═╡ b4ed8ebe-fa79-11ea-1abc-0bbdbea3e8f7
z3 = z2 .% length(cc)

# ╔═╡ fbb7910a-fa79-11ea-1d35-71d87f0492d7
minimum(randn(100, 2))

# ╔═╡ 1282faaa-fa7a-11ea-3ba6-fda9e8dcc55a
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

# ╔═╡ c27ff9cc-fa7b-11ea-33cc-15f52adca017
xc = randn(100, 100)

# ╔═╡ 8fb6caf2-fa7e-11ea-00bf-55ec70c3668e
c1 = colorant"gray"

# ╔═╡ 9d7fe204-fa7e-11ea-327c-53ac099b2962
c2 = colorant"orange"

# ╔═╡ a7198722-fa7e-11ea-0cc0-4f45c1445729
range(c1, c2, length=10)

# ╔═╡ fbc2cf70-fa7e-11ea-200e-4b357fc9773f
range(HSV(0,1,1), stop=HSV(-360,1,1), length=10)

# ╔═╡ af71951a-fa7f-11ea-0e84-e330431ae5bc
cmap = colormap("blues", 100)

# ╔═╡ e6080fb6-fa7f-11ea-1225-c997aab9ce8e
typeof(cmap)

# ╔═╡ f5a71faa-fa7f-11ea-3acb-3ddcd2b876db
imagesc(randn(10, 100), colorScheme="oranges")

# ╔═╡ 3b65d764-fa82-11ea-281d-b9904004b39a
outer(v, w) = [x*y for x in v, y in w]

# ╔═╡ 5b3009b8-fa82-11ea-0337-59053f0a5af5
imagesc(outer(1:10, 1:10))

# ╔═╡ 51bca786-fa82-11ea-137c-51da859e657e
imagesc(randn(10, 10))

# ╔═╡ Cell order:
# ╠═824aedd0-f9ac-11ea-3165-ebeb9fdd3b09
# ╠═c37cb624-f9ac-11ea-0daf-b7bc0b6d1472
# ╠═e881937e-f9ac-11ea-2e14-1f134825a637
# ╠═54b42fac-f9ad-11ea-0bce-c3e1d1a29432
# ╠═d00e11bc-f9ae-11ea-16d3-ef144122f406
# ╠═204a0a0c-f9af-11ea-0014-79d4501290f2
# ╠═175fd906-f9af-11ea-303a-334574d331f6
# ╠═b0aa5454-f9b1-11ea-0d10-33669f6cf285
# ╠═27d43112-f9b2-11ea-17cc-bf3f7030d266
# ╠═96d7db0a-f9b3-11ea-11c3-bb1b76a980f6
# ╠═9f4a8cc2-f9b3-11ea-3dac-614a0b0320a5
# ╠═10e3be12-f9b4-11ea-3a51-b19321b1f843
# ╠═57ce0f26-fa09-11ea-0610-fbb4bc94dd1d
# ╠═7febeadc-fa09-11ea-3bda-bb10872c4d57
# ╠═4c43bb5a-fa0c-11ea-0559-31edbcd3645c
# ╠═555eb38a-fa0c-11ea-3c4d-f95bfa1733f3
# ╠═e8614c1c-fa0c-11ea-1243-9b7ed1c375f6
# ╠═0fc5fa8c-fa0d-11ea-034c-db157acf15af
# ╠═bcf73472-fa75-11ea-22f1-6dde1e46620c
# ╠═d215755a-fa75-11ea-320b-735ab1aec0b4
# ╠═6dc6e762-fa77-11ea-0d41-c1b4d72bdbd8
# ╠═b9249cd6-fa77-11ea-18d5-a1db0f50742a
# ╠═f061476c-fa77-11ea-31a9-3b9f1a863575
# ╠═0848650e-fa78-11ea-1fb8-59b6af077bae
# ╠═7558fe6a-fa78-11ea-0c6b-5faddf40231a
# ╠═b6e2237a-fa78-11ea-04b6-05a49f435964
# ╠═bd5db5de-fa78-11ea-001e-21490c4c711c
# ╠═383fa76c-fa79-11ea-2378-3722e5ce0291
# ╠═3ed9f992-fa79-11ea-2167-b5a5ca4dcc69
# ╠═b4ed8ebe-fa79-11ea-1abc-0bbdbea3e8f7
# ╠═fbb7910a-fa79-11ea-1d35-71d87f0492d7
# ╠═1282faaa-fa7a-11ea-3ba6-fda9e8dcc55a
# ╠═c27ff9cc-fa7b-11ea-33cc-15f52adca017
# ╠═b1eac74a-fa7c-11ea-0eee-0b53bb1c9c1d
# ╠═8fb6caf2-fa7e-11ea-00bf-55ec70c3668e
# ╠═9d7fe204-fa7e-11ea-327c-53ac099b2962
# ╠═a7198722-fa7e-11ea-0cc0-4f45c1445729
# ╠═fbc2cf70-fa7e-11ea-200e-4b357fc9773f
# ╠═af71951a-fa7f-11ea-0e84-e330431ae5bc
# ╠═e6080fb6-fa7f-11ea-1225-c997aab9ce8e
# ╠═f5a71faa-fa7f-11ea-3acb-3ddcd2b876db
# ╠═3b65d764-fa82-11ea-281d-b9904004b39a
# ╠═5b3009b8-fa82-11ea-0337-59053f0a5af5
# ╠═51bca786-fa82-11ea-137c-51da859e657e
