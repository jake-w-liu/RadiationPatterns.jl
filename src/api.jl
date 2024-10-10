mutable struct Pattern{T1<:Number,T2<:Real}
    U::Union{Array{T1,2},SubArray{T1,2},LinearAlgebra.Transpose{T1}}
    x::Vector{T2}
    y::Vector{T2}
end

"""
plot_rect(
    x,
    y;
    xlabel = "",
    ylabel = "",
    xrange = [0, 0],
    yrange = [0, 0],
    width = 0,
    height = 0,
    mode = "lines",
    color = "",
    name = "",
)
Plots a rectangular (Cartesian) plot.

#### Arguments

- `x`: x-coordinate data (can be vector of vectors)
- `y`: y-coordinate data (can be vector of vectors)
- `xlabel`: Label for the x-axis (default: `""`)
- `ylabel`: Label for the y-axis (default: `""`)
- `xrange`: Range for the x-axis (default: `[0, 0]`)
- `yrange`: Range for the y-axis (default: `[0, 0]`)
- `width`: Width of the plot (default: `0`)
- `height`: Height of the plot (default: `0`)
- `mode`: Plotting mode (default: `"lines"`, can be vector)
- `color`: Color of the plot lines (default: `""`, can be vector)
- `name`: Name of the plot lines (default: `""`, can be vector)
"""
function plot_rect(
    x,
    y;
    xlabel = "",
    ylabel = "",
    xrange = [0, 0],
    yrange = [0, 0],
    width = 0,
    height = 0,
    mode = "lines",
    color = "",
    name = "",
)
    if isa(y, Vector) && eltype(y) <: Vector
        trace = Vector{GenericTrace}(undef, length(y))
        if !(mode isa Vector)
            mode = fill(mode, length(y))
        elseif length(mode) < length(y)
            for _ = 1:length(y)-length(mode)
                push!(mode, "lines")
            end
        end
        if !(color isa Vector)
            color = fill(color, length(y))
        elseif length(color) < length(y)
            for _ = 1:length(y)-length(color)
                push!(color, "")
            end
        end
        if !(name isa Vector)
            name = fill(name, length(y))
        elseif length(name) < length(y)
            for _ = 1:length(y)-length(name)
                push!(name, "")
            end
        end

        if isa(x, Vector) && eltype(x) <: Vector
            for n in eachindex(y)
                trace[n] = scatter(
                    y = y[n],
                    x = x[n],
                    mode = mode[n],
                    line = attr(color = color[n]),
                    name = name[n],
                )
            end
        else
            for n in eachindex(y)
                trace[n] = scatter(
                    y = y[n],
                    x = x,
                    mode = mode[n],
                    line = attr(color = color[n]),
                    name = name[n],
                )
            end
        end
    else
        trace = scatter(y = y, x = x, mode = mode, line = attr(color = color), name = name)
    end
    layout = Layout(
        template = :plotly_white,
        yaxis = attr(
            title_text = ylabel,
            zeroline = false,
            showline = true,
            mirror = true,
            ticks = "outside",
            tick0 = minimum(y),
            automargin = true,
        ),
        xaxis = attr(
            title_text = xlabel,
            zeroline = false,
            showline = true,
            mirror = true,
            ticks = "outside",
            tick0 = minimum(x),
            automargin = true,
        ),
    )
    fig = plot(trace, layout)
    if !all(xrange .== [0, 0])
        update_xaxes!(fig, range = xrange)
    end
    if !all(yrange .== [0, 0])
        update_yaxes!(fig, range = yrange)
    end
    if width > 0
        relayout!(fig, width = width)
    end
    if height > 0
        relayout!(fig, height = height)
    end
    return fig
end

"""
plot_rect(
    y;
    xlabel = "",
    ylabel = "",
    xrange = [0, 0],
    yrange = [0, 0],
    width = 0,
    height = 0,
    mode = "lines",
    color = "",
    name = "",
)
Plots a rectangular (Cartesian) plot (x-axis not specified).

#### Arguments

- `y`: y-coordinate data (can be vector of vectors)
- `xlabel`: Label for the x-axis (default: `""`)
- `ylabel`: Label for the y-axis (default: `""`)
- `xrange`: Range for the x-axis (default: `[0, 0]`)
- `yrange`: Range for the y-axis (default: `[0, 0]`)
- `width`: Width of the plot (default: `0`)
- `height`: Height of the plot (default: `0`)
- `mode`: Plotting mode (default: `"lines"`, can be vector)
- `color`: Color of the plot lines (default: `""`, can be vector)
- `name`: Name of the plot lines (default: `""`, can be vector)
"""
function plot_rect(
    y;
    xlabel = "",
    ylabel = "",
    xrange = [0, 0],
    yrange = [0, 0],
    width = 0,
    height = 0,
    mode = "lines",
    color = "",
    name = "",
)
    if isa(y, Vector) && eltype(y) <: Vector
        trace = Vector{GenericTrace}(undef, length(y))
        x_max = minimum(length.(y))
        x = 0:1:x_max-1
        if !(mode isa Vector)
            mode = fill(mode, length(y))
        elseif length(mode) < length(y)
            for _ = 1:length(y)-length(mode)
                push!(mode, "lines")
            end
        end
        if !(color isa Vector)
            color = fill(color, length(y))
        elseif length(color) < length(y)
            for _ = 1:length(y)-length(color)
                push!(color, "")
            end
        end
        if !(name isa Vector)
            name = fill(name, length(y))
        elseif length(name) < length(y)
            for _ = 1:length(y)-length(name)
                push!(name, "")
            end
        end
        for n in eachindex(y)
            trace[n] = scatter(
                y = y[n],
                x = x,
                mode = mode[n],
                line = attr(color = color[n]),
                name = name[n],
            )
        end
    else
        x_max = length(y)
        x = 0:1:x_max-1
        trace = scatter(y = y, x = x, mode = mode, line = attr(color = color), name = name)
    end
    layout = Layout(
        template = :plotly_white,
        yaxis = attr(
            title_text = ylabel,
            zeroline = false,
            showline = true,
            mirror = true,
            ticks = "outside",
            tick0 = minimum(y),
            automargin = true,
        ),
        xaxis = attr(
            title_text = xlabel,
            zeroline = false,
            showline = true,
            mirror = true,
            ticks = "outside",
            tick0 = minimum(x),
            automargin = true,
        ),
    )
    fig = plot(trace, layout)
    if !all(xrange .== [0, 0])
        update_xaxes!(fig, range = xrange)
    end
    if !all(yrange .== [0, 0])
        update_yaxes!(fig, range = yrange)
    end
    if width > 0
        relayout!(fig, width = width)
    end
    if height > 0
        relayout!(fig, height = height)
    end
    return fig
end

"""
plot_polar(
    theta, r;
    trange = [0, 0],
    rrange = [0, 0],
    width = 0,
    height = 0,
    mode = "lines",
    color = "",
)

Plots a polar plot.

#### Arguments

- `theta`: Angular coordinate data (can be vector of vectors)
- `r`: Radial coordinate data (can be vector of vectors)
- `trange`: Range for the angular axis (default: `[0, 0]`)
- `rrange`: Range for the radial axis (default: `[0, 0]`)
- `width`: Width of the plot (default: `0`)
- `height`: Height of the plot (default: `0`)
- `mode`: Plotting mode (default: `"lines"`, can be vector)
- `color`: Color of the plot lines (default: `""`, can be vector)
- `name`: Name of the plot lines (default: `""`, can be vector)
"""
function plot_polar(
    theta,
    r;
    trange = [0, 0],
    rrange = [0, 0],
    width = 0,
    height = 0,
    mode = "lines",
    color = "",
    name = "",
)
    if isa(r, Vector) && eltype(r) <: Vector
        trace = Vector{GenericTrace}(undef, length(r))
        if !(mode isa Vector)
            mode = fill(mode, length(r))
        elseif length(mode) < length(r)
            for _ = 1:length(r)-length(mode)
                push!(mode, "lines")
            end
        end
        if !(color isa Vector)
            color = fill(color, length(r))
        elseif length(color) < length(r)
            for _ = 1:length(r)-length(color)
                push!(color, "")
            end
        end
        if !(name isa Vector)
            name = fill(name, length(r))
        elseif length(name) < length(r)
            for _ = 1:length(r)-length(name)
                push!(name, "")
            end
        end

        if isa(theta, Vector) && eltype(theta) <: Vector
            for n in eachindex(r)
                trace[n] = scatterpolar(
                    r = r[n],
                    theta = theta[n],
                    mode = mode[n],
                    line = attr(color = color[n]),
                    name = name[n],
                )
            end
        else
            for n in scatterpolar(r)
                trace[n] = scatter(
                    r = r[n],
                    theta = theta,
                    mode = mode[n],
                    line = attr(color = color[n]),
                    name = name[n],
                )
            end
        end
    else
        trace = scatterpolar(
            r = r,
            theta = theta,
            mode = mode,
            line = attr(color = color),
            name = name,
        )
    end

    layout = Layout(
        template = :plotly_white,
        polar = attr(sector = [minimum(theta), maximum(theta)]),
    )
    fig = plot(trace, layout)
    if !all(rrange .== [0, 0])
        update_polars!(fig, radialaxis = attr(range = rrange))
    end
    if !all(trange .== [0, 0])
        update_polars!(fig, attr(sector = trange))
    end
    if width > 0
        relayout!(fig, width = width)
    end
    if height > 0
        relayout!(fig, height = height)
    end
    return fig
end

"""
plot_polar(
    r;
    trange = [0, 0],
    rrange = [0, 0],
    width = 0,
    height = 0,
    mode = "lines",
    color = "",
)

Plots a polar plot (theta-axis not specified).

#### Arguments

- `r`: Radial coordinate data (can be vector of vectors)
- `trange`: Range for the angular axis (default: `[0, 0]`)
- `rrange`: Range for the radial axis (default: `[0, 0]`)
- `width`: Width of the plot (default: `0`)
- `height`: Height of the plot (default: `0`)
- `mode`: Plotting mode (default: `"lines"`, can be vector)
- `color`: Color of the plot lines (default: `""`, can be vector)
- `name`: Name of the plot lines (default: `""`, can be vector)
"""
function plot_polar(
    r;
    trange = [0, 0],
    rrange = [0, 0],
    width = 0,
    height = 0,
    mode = "lines",
    color = "",
    name = "",
)
    if isa(r, Vector) && eltype(r) <: Vector
        theta_max = minimum(length.(y))
        theta = 0:1:theta_max-1
        trace = Vector{GenericTrace}(undef, length(r))
        if !(mode isa Vector)
            mode = fill(mode, length(r))
        elseif length(mode) < length(r)
            for _ = 1:length(r)-length(mode)
                push!(mode, "lines")
            end
        end
        if !(color isa Vector)
            color = fill(color, length(r))
        elseif length(color) < length(r)
            for _ = 1:length(r)-length(color)
                push!(color, "")
            end
        end
        if !(name isa Vector)
            name = fill(name, length(r))
        elseif length(name) < length(r)
            for _ = 1:length(r)-length(name)
                push!(name, "")
            end
        end

        for n in scatterpolar(r)
            trace[n] = scatter(
                r = r[n],
                theta = theta,
                mode = mode[n],
                line = attr(color = color[n]),
                name = name[n],
            )
        end
    else
        theta_max = length(y)
        theta = 0:1:theta_max-1
        trace = scatterpolar(
            r = r,
            theta = theta,
            mode = mode,
            line = attr(color = color),
            name = name,
        )
    end

    layout = Layout(
        template = :plotly_white,
        polar = attr(sector = [minimum(theta), maximum(theta)]),
    )
    fig = plot(trace, layout)
    if !all(rrange .== [0, 0])
        update_polars!(fig, radialaxis = attr(range = rrange))
    end
    if !all(trange .== [0, 0])
        update_polars!(fig, attr(sector = trange))
    end
    if width > 0
        relayout!(fig, width = width)
    end
    if height > 0
        relayout!(fig, height = height)
    end
    return fig
end

"""
plot_holo(
    x,
    y,
    U;
    xlabel = "",
    ylabel = "",
    zrange = [0, 0],
    ref_size = 500,
    colorscale = "Jet",
)

Plots holographic data.

#### Arguments

- 'x': x-axis range
- 'y': x-axis range
- `U`: 2D hologram data
- `xlabel`: Label for the x-axis (default: `""`)
- `ylabel`: Label for the y-axis (default: `""`)
- `zrange`: Range for the z-axis (default: `[0, 0]`)
- `ref_size`: ref size of the plot in pixels (default: `500`)
- `colorscale`: Color scale for the heatmap (default: `"Jet"`)
"""
function plot_holo(
    x,
    y,
    U;
    xlabel = "",
    ylabel = "",
    zrange = [0, 0],
    ref_size = 500,
    colorscale = "Jet",
)
    #calculate figure size
    height = length(y)
    width = length(x)
    ratio = height / (width)
    if width > height
        width = ref_size
        height = round(Int64, width * ratio)
    else
        height = ref_size
        width = round(Int64, height / ratio)
    end
    if height >= width
        width += round(Int, ratio) * 45
    elseif height < width
        height += round(Int, 1/ratio) * 20
    end

    FV = @view U[:, :]
    FV = transpose(FV)
    trace = heatmap(x = x, y = y, z = FV, colorscale = colorscale)
    if !all(zrange .== [0, 0])
        trace.zmin = zrange[1]
        trace.zmax = zrange[2]
    end
    if length(x) > 1
        dx = x[2] - x[1]
    else
        dx = 0
    end
    if length(y) > 1
        dy = y[2] - y[1]
    else
        dy = 0
    end
    if dx == 0 && dy != 0
        dx = dy
    elseif dy == 0 && dx != 0
        dy = dx
    end
    layout = Layout(
        height = height,
        width = width,
        plot_bgcolor = "white",
        scene = attr(aspectmode = "data"),
        xaxis = attr(
            title = xlabel,
            range = [minimum(x) - dx / 2, maximum(x) + dx / 2],
            automargin = true,
            scaleanchor = "y",
        ),
        yaxis = attr(
            title = ylabel,
            range = [minimum(y) - dy / 2, maximum(y) + dy / 2],
            automargin = true,
        ),
        margin = attr(r = 0, b = 0),
    )
    fig = plot(trace, layout)

    return fig
end


"""
plot_holo(
    U;
    xlabel = "",
    ylabel = "",
    zrange = [0, 0],
    ref_size = 500,
    colorscale = "Jet",
)

Plots holographic data.

#### Arguments

- `U`: 2D hologram data
- `xlabel`: Label for the x-axis (default: `""`)
- `ylabel`: Label for the y-axis (default: `""`)
- `zrange`: Range for the z-axis (default: `[0, 0]`)
- `ref_size`: ref size of the plot in pixels (default: `500`)
- `colorscale`: Color scale for the heatmap (default: `"Jet"`)
"""
function plot_holo(
    U;
    xlabel = "",
    ylabel = "",
    zrange = [0, 0],
    ref_size = 500,
    colorscale = "Jet",
)
    x = collect(0:1:size(U, 1)-1)
    y = collect(0:1:size(U, 2)-1)
    height = length(y)
    width = length(x)
    ratio = height / (width)
    if width > height
        width = ref_size
        height = round(Int64, width * ratio)
    else
        height = ref_size
        width = round(Int64, height / ratio)
    end
    if height >= width
        width += round(Int, ratio) * 45
    elseif height < width
        height += round(Int, 1/ratio) * 20
    end

    FV = @view U[:, :]
    FV = transpose(FV)

    trace = heatmap(x = x, y = y, z = FV, colorscale = colorscale)
    if !all(zrange .== [0, 0])
        trace.zmin = zrange[1]
        trace.zmax = zrange[2]
    end
    @all dx dy = 1
    if dx == 0 && dy != 0
        dx = dy
    elseif dy == 0 && dx != 0
        dy = dx
    end
    layout = Layout(
        height = height,
        width = width,
        plot_bgcolor = "white",
        scene = attr(aspectmode = "data"),
        xaxis = attr(
            title = xlabel,
            range = [minimum(x) - dx / 2, maximum(x) + dx / 2],
            automargin = true,
            scaleanchor = "y",
        ),
        yaxis = attr(
            title = ylabel,
            range = [minimum(y) - dy / 2, maximum(y) + dy / 2],
            automargin = true,
        ),
        margin = attr(r = 0, b = 0),
    )
    fig = plot(trace, layout)

    return fig
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
    color::Union{String,Vector{String}} = "",
    name::Union{String,Vector{String}}  = "",
)

Plots a 2D radiation pattern by setting the keywords `ind` and `dim`. For example, setting `dim=1` takes the slice of `U[:, ind]`, and setting `dim=2` takes the slice of `U[ind, :]`. Can be used for comparing two or more patterns also (see the example `ex_basics.jl` and `ex_horn.jl`). When comparing two or more pattern cuts, one can specify different `ind`, `dims`, `mode`, `color` and `name` by setting these keywords as vectors (if not set, default values are used).

#### Arguments

- `Pat`: A `Pattern` or a vector of `Pattern`s
- `ind`: Index to slice the pattern, either `1` or `2` (default: `1`)
- `dims`: Dimension to slice the pattern (default: `1`)
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
- `color`: Color of the plot lines (default: `""`)
- `name`: Name of the plot lines (default: `""`)
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
    color::Union{String,Vector{String}} = "",
    name::Union{String,Vector{String}} = "",
)
    if Pat isa Vector
        if !(mode isa Vector)
            mode = fill("lines", length(Pat))
        elseif length(mode) < length(Pat)
            for _ = 1:length(Pat)-length(mode)
                push!(mode, "lines")
            end
        end
        if !(color isa Vector)
            color = fill("", length(Pat))
        elseif length(color) < length(Pat)
            for _ = 1:length(Pat)-length(color)
                push!(color, "")
            end
        end
        if !(name isa Vector)
            name = fill("", length(Pat))
        elseif length(name) < length(Pat)
            for _ = 1:length(Pat)-length(name)
                push!(name, "")
            end
        end
        if !(ind isa Vector)
            ind = fill(1, length(Pat))
        elseif length(ind) < length(Pat)
            for _ = 1:length(Pat)-length(ind)
                push!(ind, 1)
            end
        end
        if !(dims isa Vector)
            dims = fill(1, length(Pat))
        elseif length(dims) < length(Pat)
            for _ = 1:length(Pat)-length(dims)
                push!(dims, 1)
            end
        end

        cut = Vector{Vector{eltype(Pat[1].U)}}(undef, length(Pat))
        x = Vector{Vector{eltype(Pat[1].x)}}(undef, length(Pat))
        for n in eachindex(Pat)
            if dims[n] == 1
                cut[n] = Pat[n].U[:, ind[n]]
                x[n] = Pat[n].x
            elseif dims[n] == 2
                cut[n] = Pat[n].U[ind, :]
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
        fig = plot_rect(
            x,
            cut;
            xlabel = xlabel,
            ylabel = ylabel,
            xrange = xrange,
            yrange = yrange,
            width = width,
            height = height,
            mode = mode,
            color = color,
            name = name,
        )
    elseif type == "polar"
        fig = plot_polar(
            x,
            cut;
            trange = trange,
            rrange = rrange,
            width = width,
            height = height,
            mode = mode,
            color = color,
            name = name,
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
    ref_size = 500,
    colorscale = "Jet",
)

Plots a holographic (heatmap) radiation pattern. Currently I have issues in setting both the axis ratio and the range of the heatmap plot. In order to have an 1:1 aspect ratio, I have tried to fine tune the width and height of the plot. One can try to adjust the `ref_size` keyword to set the figure size. I hope that more improvements can be made in the future.

#### Arguments

- `Pat`: A `Pattern`
- `xlabel`: Label for the x-axis (default: `""`)
- `ylabel`: Label for the y-axis (default: `""`)
- `zrange`: Range for the z-axis (default: `[0, 0]`)
- `ref_size`: ref size of the plot in pixels (default: `500`)
- `colorscale`: Color scale for the heatmap (default: `"Jet"`)
"""
function ptn_holo(
    Pat::Pattern;
    xlabel::String = "",
    ylabel::String = "",
    zrange::Vector{<:Real} = [0, 0],
    ref_size = 500,
    colorscale = "Jet",
)
    return plot_holo(
        Pat.x,
        Pat.y,
        Pat.U;
        xlabel,
        ylabel,
        zrange,
        ref_size,
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
