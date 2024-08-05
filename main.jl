using Pkg, Revise
Pkg.activate(".")

using RadiationPattern
using MeshGrid

tht = -180:180
phi = 0:180

P, T = meshgrid(phi, tht)
U = sind.(T).^2
Pat = Pattern(U, collect(tht), collect(phi))

fig1 = ptn_2d(Pat; ind = 1, dims = 1, xlabel = "θ (deg)", ylabel = "amplitude", xrange=[0, 90])
display(fig1)

fig2 = ptn_2d(Pat; ind = 1, dims = 1, type = "polar")
display(fig2)

Dpat = direc_ptn(Pat)
Dpat.U .= 10 .*log10.(Dpat.U)

fig3 = ptn_3d(Dpat; dB = true)
display(fig3)