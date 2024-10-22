module RadiationPatterns

using PlotlyJS
using PlotlyGeometries
using MeshGrid
using Trapz
using LinearAlgebra
using BatchAssign
using Infiltrator

export Pattern
export plot_rect, plot_polar, plot_holo
export ptn_2d, ptn_3d
export ptn_holo
export direc_ptn, direc
export db_ptn, db_ptn!

include("api.jl")

end
