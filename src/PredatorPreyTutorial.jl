module PredatorPreyTutorial

using Agents
using Random
# using InteractiveDynamics
using CairoMakie

include("agents.jl")
include("actions.jl")
include("model.jl")


# offset(a) = a isa Sheep ? (-0.1, -0.1*rand()) : (+0.1, +0.1*rand())
# ashape(a) = a isa Sheep ? :circle : :utriangle
# acolor(a) = a isa Sheep ? RGBAf(1.0, 1.0, 1.0, 0.8) : RGBAf(0.2, 0.2, 0.3, 0.8)

# grasscolor(model) = model.countdown ./ model.regrowth_time

# heatkwargs = (colormap = [:brown, :green], colorrange = (0, 1))

# plotkwargs = (;
#     ac = acolor,
#     as = 25,
#     am = ashape,
#     offset,
#     scatterkwargs = (strokewidth = 1.0, strokecolor = :black),
#     heatarray = grasscolor,
#     heatkwargs = heatkwargs,
# )

sheepwolfgrass = initialize_model()

sheep(a) = a isa Sheep
wolf(a) = a isa Wolf
count_grass(model) = count(model.fully_grown)

sheepwolfgrass = initialize_model()
steps = 1000
adata = [(sheep, count), (wolf, count)]
mdata = [count_grass]
adf, mdf = run!(sheepwolfgrass, sheepwolf_step!, grass_step!, steps; adata, mdata)

# Plots

function plot_population_timeseries(adf, mdf)
    figure = Figure(resolution = (600, 400))
    ax = figure[1, 1] = Axis(figure; xlabel = "Step", ylabel = "Population")
    sheepl = lines!(ax, adf.step, adf.count_sheep, color = :cornsilk4)
    wolfl = lines!(ax, adf.step, adf.count_wolf, color = RGBAf(0.2, 0.2, 0.3))
    grassl = lines!(ax, mdf.step, mdf.count_grass, color = :green)
    figure[1, 2] = Legend(figure, [sheepl, wolfl, grassl], ["Sheep", "Wolves", "Grass"])
    figure
end

plot_population_timeseries(adf, mdf)


# Stable Scenario

stable_params = (;
    n_sheep = 140,
    n_wolves = 20,
    dims = (30, 30),
    Δenergy_sheep = 5,
    sheep_reproduce = 0.31,
    wolf_reproduce = 0.06,
    Δenergy_wolf = 30,
    seed = 71758,
)

sheepwolfgrass = initialize_model(;stable_params...)
adf, mdf = run!(sheepwolfgrass, sheepwolf_step!, grass_step!, 2000; adata, mdata)

plot_population_timeseries(adf, mdf)

sheepwolfgrass = initialize_model(;stable_params...)


end
