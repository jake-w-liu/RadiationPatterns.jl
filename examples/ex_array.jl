using RadiationPatterns
using MeshGrid

# this examples plots the 3D 8 by 8 array factor with scanned beam

tht = collect(0:90)
phi = collect(0:360)
P, T = meshgrid(phi, tht)

A = zeros(ComplexF64, length(tht), length(phi))
psix = -pi / 5
psiy = -0
for m = 0:7, n = 0:7
    A .+=
        cosd.(T) .* exp.(1im * m * (pi .* (sind.(T) .* cosd.(P)) .+ psix)) .*
        exp.(1im * n * (pi .* (sind.(T) .* sind.(P)) .+ psiy))
end

Pat = Pattern(abs2.(A), tht, phi)
Pat = direc_ptn(Pat) # transform to directivity pattern
db_ptn!(Pat) # transform to dB scale

fig1 = ptn_3d(Pat, dB = true)
display(fig1)

fig2 = ptn_2d(Pat; yrange=[-45, 25], xlabel = "θ (deg)", ylabel = "directivity (dBi)")
display(fig2)

