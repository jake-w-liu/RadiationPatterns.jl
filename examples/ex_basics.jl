using RadiationPattern
using MeshGrid

# creating a dipole pattern 
tht = collect(-180:180)
phi = collect(0:180)

_, T = meshgrid(phi, tht) # uses MeshGrid.jl
U = sind.(T).^2
Pat = Pattern(U, tht, phi)

# plot 2D rectangular patterns (plotting Pat.U[:, 1])
fig1 = ptn_2d(Pat; ind = 1, dims = 1, xlabel = "θ (deg)", ylabel = "amplitude", xrange=[0, 90])
display(fig1)

# plot 2D polar patterns (plotting Pat.U[:, 1])
fig2 = ptn_2d(Pat; ind = 1, dims = 1, type = "polar", color = "red")
display(fig2)

# conparison of a consine tapered pattern
fig3 = ptn_2d([Pat, Pattern(cosd.(T) , tht, phi)]; ind = 1, dims = 1, xlabel = "θ (deg)", ylabel = "amplitude", xrange=[0, 90], name = ["dipole", "patch"])
display(fig3)

# conparison of a consine tapered pattern
fig4 = ptn_2d([Pat, Pattern(abs.(cosd.(T)) , tht, phi)]; ind = 1, dims = 1, type = "polar", name = ["dipole", "patch"])
display(fig4)

# creates directivity pattern and transform to dB scale
println("directity of a dipole is $(direc(Pat))") # sould be around 1.5
Dpat = direc_ptn(Pat)
Dpat.U .= 10 .*log10.(Dpat.U)

# plot 3D radiation pattern in dB scale
fig5 = ptn_3d(Dpat; dB = true)
display(fig5)



