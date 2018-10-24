using Plots
gr()

# spirograph takes three values that have defaults.
# ratio is the radius of larger wheel / radius of smaller wheel (default is 4)
# pen is the position of pen (between 0-1). 0 = center, 1 = edge.
# revolutions is the number of revolutions of smaller wheel
function spirograph(;ratio=4.0, pen=1.0, revolutions=1)
       r = 1; R = r * ratio;
       θ = range(0, stop=revolutions*2*π, length=128*revolutions);
       x = (R-r).*cos.(θ) .+ (r*pen).*cos.(((R+r)/r)*θ);
       y = (R-r).*sin.(θ) .+ (r*pen).*sin.(((R+r)/r)*θ);
       return x, y
end

function drawSpirograph(; ratio=4.0, pen=1.0, revolutions=1)
	x, y = spirograph(ratio=ratio, pen=pen, revolutions=revolutions)
	plot(x, y, size=[500, 450], linecolor=:red)
end

# iterate through these to see different patterns
drawSpirograph(ratio=4.12, pen=0.7, revolutions=25)

drawSpirograph(ratio=0.123, pen=1, revolutions=100)

drawSpirograph(ratio=0.3, pen=1, revolutions=10)

drawSpirograph(ratio=0.33, pen=1, revolutions=100)

drawSpirograph(ratio=4, pen=1, revolutions=1)

drawSpirograph(ratio=9.5, pen=1, revolutions=5)

drawSpirograph(ratio=2.1, pen=1, revolutions=10)

drawSpirograph(ratio=2.7, pen=1, revolutions=10)

drawSpirograph(ratio=3.5, pen=0.3, revolutions=10)
