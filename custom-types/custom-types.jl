#!/usr/local/bin/julia
# this code is for learning purposes
# borrowed from: https://www.youtube.com/watch?v=Cj6bjqS5otM

# define custom data type
struct Dual <: Real
    Val::Float64
    Adj::Float64
end

# extend base methods
Base.show(io::IO, x::Dual) = print(io, "$(x.Val) + $(x.Adj)ϵ")
Base.convert(::Type{Dual}, x::Real) = Dual(x, 0)
Base.convert(::Type{Dual}, x::Dual) = x
Base.promote_rule(::Type{Float64}, ::Type{Dual}) = Dual
Base.promote_rule(::Type{Int64}, ::Type{Dual}) = Dual
Base.promote_rule(::Type{Int32}, ::Type{Dual}) = Dual

import Base: +, -, /, *, abs, <, ==, <=
+(x::Dual, y::Dual) = Dual(x.Val + y.Val, x.Adj + y.Adj)
-(x::Dual) = Dual(-x.Val, -y.Val)
-(x::Dual, y::Dual) = x + -y
*(x::Dual, y::Dual) = Dual(x.Val * y.Val, x.Val * y.Adj + y.Val * x.Adj)
/(x::Dual, y::Dual) = Dual(x.Val / y.Val, x.Adj / y.Val - (x.Val * y.Adj) / y.Val^2)
abs(x::Dual) = x.Val > 0 ? x : -x
==(x::Dual, y::Dual) = x.Val == y.Val && x.Adj == y.Adj
<(x::Dual, y::Dual) = x.Val == y.Val ? x.Adj < y.Adj : x.Val < y.Val
<=(x::Dual, y::Dual) = x < y || x == y

import Base.log
log(x::Dual) = Dual(log(x.Val), x.Adj / x.Val);
