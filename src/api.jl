mutable struct Pattern{T1,T2}
    U::Array{T1,2}
    x::Vector{T2}
    y::Vector{T2}
end

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
            mode = fill("lines", length(y))
        elseif length(mode) < length(y)
            for _ = 1:length(y)-length(mode)
                push!(mode, "lines")
            end
        end
        if !(color isa Vector)
            color = fill("", length(y))
        elseif length(color) < length(y)
            for _ = 1:length(y)-length(color)
                push!(color, "")
            end
        end
        if !(name isa Vector)
            name = fill("", length(y))
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
            mode = fill("lines", length(r))
        elseif length(mode) < length(r)
            for _ = 1:length(r)-length(mode)
                push!(mode, "lines")
            end
        end
        if !(color isa Vector)
            color = fill("", length(r))
        elseif length(color) < length(r)
            for _ = 1:length(r)-length(color)
                push!(color, "")
            end
        end
        if !(name isa Vector)
            name = fill("", length(r))
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
    height::Real  = 0,
    mode::Union{String,Vector{String}} = "lines",
    color::Union{String,Vector{String}} = "",
    name::Union{String,Vector{String}}  = "",
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

function ptn_holo(
    Pat::Pattern;
    xlabel::String = "",
    ylabel::String = "",
    zmax::Real = 1,
    zmin::Real = -1,
    max_pixel = 550,
    colorscale = "Jet",
)
    #calculate figure size
    height = length(Pat.y)
    width = 1.1 * length(Pat.x)
    ratio = height / width
    if width > height
        width = max_pixel
        height = round(Int64, width * ratio)
    else
        height = max_pixel
        width = round(Int64, height / ratio)
    end
    width += 20

    trace =
        heatmap(x = U.x, y = U.y, z = U, zmax = zmax, zmin = zmin, colorscale = colorscale)
    layout = Layout(
        height = height,
        width = width,
        plot_bgcolor = "white",
        scene = attr(aspectmode = "data"),
        xaxis = attr(
            title = xlabel,
            range = [minimum(Pat.x), maximum(Pat.x)],
            autorange = false,
            ticks = "outside",
            tickmode = "auto",
            automargin = true,
        ),
        yaxis = attr(
            title = ylabel,
            range = [minimum(Pat.y), maximum(Pat.y)],
            autorange = false,
            ticks = "outside",
            tickmode = "auto",
            automargin = true,
        ),
    )
    fig = plot(trace, layout)
    display(fig)

    return fig
end

function ptn_3d(
    Pat::Pattern; 
    dB::Bool = false, 
    thr::Real = -50
)
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
    trace = surface(
        x = Xd,
        y = Yd,
        z = Zd,
        surfacecolor = S,
        # colorbar = attr(title = "dB"),
        colorscale = "Jet",
    )
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

function direc_ptn(Pat::Pattern)
    F = Pat.U / maximum(Pat.U)
    tht = Pat.x
    phi = Pat.y
    _, T = meshgrid(phi, tht)

    Ptot = trapz((tht * pi / 180, phi * pi / 180), F .* abs.(sin.(T * pi / 180)))
    D = F * 4 * pi / Ptot
    return Pattern(D, tht, phi)
end

function direc(Pat::Pattern)
    F = Pat.U / maximum(Pat.U)
    tht = Pat.x
    phi = Pat.y
    _, T = meshgrid(phi, tht)

    Ptot = trapz((tht * pi / 180, phi * pi / 180), F .* abs.(sin.(T * pi / 180)))
    return maximum(F * 4 * pi / Ptot)
end
