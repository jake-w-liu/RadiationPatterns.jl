using Pkg, Revise
Pkg.activate(".")
using RadiationPatterns

using LinearAlgebra
using MeshGrid

x = 1:10
y = 1:20

Y, X = meshgrid(y, x)
A = @view Y[1:2, 1:3]
A = transpose(A)

ya = collect(x[1:2])
xa = collect(y[1:3])

Pattern(A, xa, ya)
