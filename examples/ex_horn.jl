using RadiationPatterns
using CSV, DataFrames

# this file reads a SGH (standard gain horn) radiation pattern and plots it 
data = Matrix(CSV.read("U.csv", DataFrame, header=false)) 

tht = collect(0:180)
phi = collect(0:360)

Pat = Pattern(data, tht, phi)
Pat = direc_ptn(Pat) # transform to directivity pattern
db_ptn!(Pat) # transform to dB scale

fig1 = ptn_3d(Pat, dB = true)
display(fig1)

fig2 = ptn_2d(
    [Pat, Pat]; # comparing with the same pattern
    dims = 1, # along theta
    ind = [1, 91], # compare phi = 0 adn phi = 90 cut
    yrange=[-40, 20], 
    xlabel = "θ (deg)", 
    ylabel = "directivity (dBi)",
    legend = ["E-plane", "H-plane"],
)
display(fig2)