using DifferentialEquations
using ParameterizedFunctions
using Plots
gr()

f = @ode_def BallBounce begin
  dy =  v
  dv = -g
end g

function condition(u,t,integrator) # Event when event_f(u,t) == 0
  u[1]
end

function affect!(integrator)
  integrator.u[2] = -0.9*integrator.u[2]
end

cb = ContinuousCallback(condition,affect!)

u0 = [50.0,0.0]
tspan = (0.0,50.0)
p = 9.8
prob = ODEProblem(f,u0,tspan,p)
sol = solve(prob,Tsit5(),callback=cb)
plot(sol)

t = range(0, stop=50, length=1024)
y = similar(t)

for i in 1:length(t)
  u = sol(t[i])
  y[i] = u[1]
end

plot(t, y)
