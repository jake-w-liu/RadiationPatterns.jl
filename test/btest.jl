using RadiationPatterns
using MeshGrid
using BenchmarkTools
using PlotlySupply
using JLD

function run_benchmark(n::Int)
	tht = collect(0:1:n)
	phi = collect(0:1:360)

	_, T = meshgrid(phi, tht)
	A = sind.(T)

	bench = @benchmark plot_test($A, $tht, $phi)
	t = median(bench).time/10^6
	mem = median(bench).memory/10^6

	return t, mem
end

function run_benchmark_plotly(n::Int) ## estiation of the ptn_3d function in RadiationPatterns
	tht = collect(0:1:n)
	phi = collect(0:1:360)

	_, T = meshgrid(phi, tht)
	A = sind.(T)

	bench = @benchmark plot_test_plotly($A)
	t = median(bench).time/10^6
	mem = median(bench).memory/10^6

	return t, mem
end

function plot_test(A, tht, phi)
	Pat = Pattern(A .^ 2, tht, phi)
	return ptn_3d(Pat)
end

function plot_test_plotly(A) ## estiation of the plot function in PlotlyJS

	trace = surface(x = A, y = A, z = A, surfacecolor = A, colorscale = "Jet")
	layout = Layout(
		scene = attr(
			xaxis = attr(visible = false, showgrid = false),
			yaxis = attr(visible = false, showgrid = false),
			zaxis = attr(visible = false, showgrid = false),
			aspectmode = "data",
		),
		coloraxis = attr(cmax = maximum(A), cmin = minimum(A)),
		template = :plotly_white,
	)
	return plot(trace, layout)
end

np = 10:10:180
bt = zeros(length(np))
bmem = zeros(length(np))
bt_plotly = zeros(length(np))
bmem_plotly = zeros(length(np))

count = 1
for m in np
	bt[count], bmem[count] = run_benchmark(m)
	bt_plotly[count], bmem_plotly[count] = run_benchmark_plotly(m)
	
	println("Completed for m = $m")
	global count += 1
end
save("benchmark_result.jld", "bt", bt, "bmem", bmem, "bt_plotly", bt_plotly, "bmem_plotly", bmem_plotly)

fig1 = plot_scatter(np, [bt, bt_plotly],
	xlabel = "Number of Theta Points",
	ylabel = "Time (ms)",
	title = "Benchmarking Time",
    legend = ["ptn_3d (RadiationPatterns)", "plot (PlotlyJS)"],
    dash=["", "dash"],
    )
display(fig1)

fig2 = plot_scatter(np, [bmem, bmem_plotly],
	xlabel = "Number of Theta Points",
	ylabel = "Ｍemory (MB)",
	title = "Allocated Memory",
    legend = ["ptn_3d (RadiationPatterns)", "plot (PlotlyJS)"],
    dash=["", "dash"],
    )
display(fig2)

println("Done")




