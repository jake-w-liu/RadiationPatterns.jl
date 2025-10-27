mutable struct Pattern{T1<:Number,T2<:Real}
    U::Union{Array{T1,2},SubArray{T1,2},LinearAlgebra.Transpose{T1}}
    x::Vector{T2}
    y::Vector{T2}
end


"""
ptn_2d(
    Pat::Union{Pattern,Vector{<:Pattern}};
    ind::Union{Int,Vector{Int}} = 1,
    dims::Union{Int,Vector{Int}} = 1,
    type::String = "normal",
    xlabel::String = "",
    ylabel::String = "",
    xrange::Vector{<:Real} = [0, 0],
    yrange::Vector{<:Real} = [0, 0],
    trange::Vector{<:Real} = [0, 0],
    rrange::Vector{<:Real} = [0, 0],
    width::Real = 0,
    height::Real  = 0,
    mode::Union{String,Vector{String}} = "lines",
    dash::Union{String,Vector{String}} = "",
    color::Union{String,Vector{String}} = "",
    legend::Union{String,Vector{String}}  = "",
)

Plots a 2D radiation pattern by setting the keywords `ind` and `dim`. For example, setting `dim=1` takes the slice of `U[:, ind]`, and setting `dim=2` takes the slice of `U[ind, :]`. Can be used for comparing two or more patterns also (see the example `ex_basics.jl` and `ex_horn.jl`). When comparing two or more pattern cuts, one can specify different `ind`, `dims`, `mode`, `color` and `legend` by setting these keywords as vectors (if not set, default values are used).

#### Arguments

- `Pat`: A `Pattern` or a vector of `Pattern`s
- `ind`: Index to slice the pattern (default: `1`)
- `dims`: Dimension to slice the pattern, either `1` or `2` (default: `1`)
- `type`: Plot type, either `"normal"` or `"polar"` (default: `"normal"`)
- `xlabel`: Label for the x-axis (default: `""`)
- `ylabel`: Label for the y-axis (default: `""`)
- `xrange`: Range for the x-axis (default: `[0, 0]`)
- `yrange`: Range for the y-axis (default: `[0, 0]`)
- `trange`: Range for the angular axis (default: `[0, 0]`)
- `rrange`: Range for the radial axis (default: `[0, 0]`)
- `width`: Width of the plot (default: `0`)
- `height`: Height of the plot (default: `0`)
- `mode`: Plotting mode (default: `"lines"`)
- `dash`: Dash setting (default: `""`)
- `color`: Color of the plot lines (default: `""`)
- `legend`: Legend of the plot lines (default: `""`)
"""
function ptn_2d(
    Pat::Union{Pattern,Vector{<:Pattern}};
    ind::Union{Int,Vector{Int}} = 1,
    dims::Union{Int,Vector{Int}} = 1,
    type::String = "normal",
    xlabel::String = "",
    ylabel::String = "",
    xrange::Vector{<:Real} = [0, 0],
    yrange::Vector{<:Real} = [0, 0],
    trange::Vector{<:Real} = [0, 0],
    rrange::Vector{<:Real} = [0, 0],
    width::Real = 0,
    height::Real = 0,
    mode::Union{String,Vector{String}} = "lines",
    dash::Union{String,Vector{String}} = "",
    color::Union{String,Vector{String}} = "",
    legend::Union{String,Vector{String}} = "",
)
    if Pat isa Vector
        indV = ones(Int, length(Pat))
        dimsV = ones(Int, length(Pat))
        if !(ind isa Vector)
            fill!(indV, ind)
        else
            for n in eachindex(ind)
                indV[n] = ind[n]
            end
        end
        if !(dims isa Vector)
            fill!(dimsV, dims)
        else
            for n in eachindex(dims)
                dimsV[n] = dims[n]
            end
        end

        cut = Vector{Vector{eltype(Pat[1].U)}}(undef, length(Pat))
        x = Vector{Vector{eltype(Pat[1].x)}}(undef, length(Pat))
        for n in eachindex(Pat)
            if dimsV[n] == 1
                cut[n] = Pat[n].U[:, indV[n]]
                x[n] = Pat[n].x
            elseif dimsV[n] == 2
                cut[n] = Pat[n].U[indV[n], :]
                x[n] = Pat[n].y
            else
                println("dims should be 1 or 2.")
                return nothing
            end
        end
    else
        if dims == 1
            cut = Pat.U[:, ind]
            x = Pat.x
        elseif dims == 2
            cut = Pat.U[ind, :]
            x = Pat.y
        else
            println("dims should be 1 or 2.")
            return nothing
        end
    end
    if type == "normal"
        fig = plot_scatter(
            x,
            cut;
            xlabel = xlabel,
            ylabel = ylabel,
            xrange = xrange,
            yrange = yrange,
            width = width,
            height = height,
            mode = mode,
            dash = dash,
            color = color,
            legend = legend,
        )
    elseif type == "polar"
        fig = plot_scatterpolar(
            x,
            cut;
            trange = trange,
            rrange = rrange,
            width = width,
            height = height,
            mode = mode,
            dash = dash,
            color = color,
            legend = legend,
        )
    else
        println("type should be \"normal\" or \"polar\".")
        return nothing
    end

    return fig
end

"""
ptn_3d(Pat::Pattern; dB::Bool = false, thr::Real = -50)

Plots a 3D radiation pattern. In 3D cases, `Pat.x` should be `theta` values in degrees, and `Pat.y` should be `phi` values in degrees. If dB scale is used for the data, please set the keyword `dB` to `true`. A threadsold value `thr` (max difference from the maximum value of the pattern) is used in case that `-Inf` appears in the dB scale data.

#### Arguments

- `Pat`: A `Pattern`
- `dB`: Boolean to plot if the pattern is in decibels (default: `false`)
- `thr`: Threshold value for the plot if dB is true (default: `-50`)
"""
function ptn_3d(Pat::Pattern; dB::Bool = false, thr::Real = -50)
    if thr >= 0
        thr = -50  # default
    end
    A_plt = copy(Pat.U)
    if dB
        A_plt[A_plt.<maximum(A_plt)+thr] .= thr
        S = copy(A_plt)
        A_plt .= A_plt .- minimum(A_plt)
    else
        S = A_plt
    end
    tht = Pat.x
    phi = Pat.y
    P, T = meshgrid(phi, tht)
    Zd = A_plt .* cosd.(T)
    Xd = A_plt .* sind.(T) .* cosd.(P)
    Yd = A_plt .* sind.(T) .* sind.(P)
    trace = surface(x = Xd, y = Yd, z = Zd, surfacecolor = S, colorscale = "Jet")
    layout = Layout(
        scene = attr(
            xaxis = attr(visible = false, showgrid = false),
            yaxis = attr(visible = false, showgrid = false),
            zaxis = attr(visible = false, showgrid = false),
            aspectmode = "data",
        ),
        coloraxis = attr(cmax = maximum(A_plt), cmin = minimum(A_plt)),
        template = :plotly_white,
    )
    fig = plot(trace, layout)
    r = maximum(A_plt) * 1.05
    add_ref_axes!(fig, [0, 0, 0], r)

    return fig
end

"""
ptn_holo(
    Pat::Pattern;
    xlabel::String = "",
    ylabel::String = "",
    zrange::Vector{<:Real} = [0, 0],
    colorscale = "Jet",
)

Plots a holographic (heatmap) radiation pattern. Currently I have issues in setting both the axis ratio and the range of the heatmap plot. In order to have an 1:1 aspect ratio, I have tried to fine tune the width and height of the plot. 

#### Arguments

- `Pat`: A `Pattern`
- `xlabel`: Label for the x-axis (default: `""`)
- `ylabel`: Label for the y-axis (default: `""`)
- `zrange`: Range for the z-axis (default: `[0, 0]`)
- `colorscale`: Color scale for the heatmap (default: `"Jet"`)
"""
function ptn_holo(
    Pat::Pattern;
    xlabel::String = "",
    ylabel::String = "",
    zrange::Vector{<:Real} = [0, 0],
    colorscale = "Jet",
)
    return plot_heatmap(
        Pat.x,
        Pat.y,
        Pat.U;
        xlabel,
        ylabel,
        zrange,
        colorscale,
    )
end

"""
direc_ptn(Pat::Pattern)

Calculate the directivity pattern of a radiation pattern. `Pat.x` should be `theta` values in degrees, and `Pat.y` should be `phi` values in degrees.  

#### Arguments

- `Pat`: A `Pattern`

#### Returns

A `Pattern` representing the directivity.
"""
function direc_ptn(Pat::Pattern)
    F = Pat.U
    tht = Pat.x
    phi = Pat.y
    Ptot = trapz((tht * pi / 180, phi * pi / 180), F .* abs.(sin.(tht * pi / 180)))
    D = F * 4 * pi / Ptot
    return Pattern(D, tht, phi)
end

"""
direc(Pat::Pattern)

Calculates the directivity of a radiation pattern. `Pat.x` should be `theta` values in degrees, and `Pat.y` should be `phi` values in degrees.  

#### Arguments

- `Pat`: A `Pattern`

#### Returns

The directivity value.
"""
function direc(Pat::Pattern)
    return maximum(direc_ptn(Pat).U)
end

"""
db_ptn(Pat::Pattern, topower=false)

Transform Pattern object to dB Pattern, return a new Pattern object.

#### Arguments

- `Pat`: A `Pattern`
- `topower`: if `ture`, then uses 20log10(.), otherwise 10log10(.).

#### Returns

The dB Pattern object.
"""
function db_ptn(Pat::Pattern, topower=false)
    if !topower
        return Pattern(10 .* log10.(abs.(Pat.U)), Pat.x, Pat.y)
    else
        return Pattern(20 .* log10.(abs.(Pat.U)), Pat.x, Pat.y)
    end
end

"""
db_ptn!(Pat::Pattern, topower=false)

Transform Pattern object to dB Pattern.

#### Arguments

- `Pat`: A `Pattern`
- `topower`: if `ture`, then uses 20log10(.), otherwise 10log10(.).

"""
function db_ptn!(Pat::Pattern, topower=false)
    if !topower
        Pat.U = 10 .* log10.(abs.(Pat.U))
    else
        Pat.U = 20 .* log10.(abs.(Pat.U))
    end
end

