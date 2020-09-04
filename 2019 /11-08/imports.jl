using Plots, SymPy, Distributions, DataStructures, Test, LaTeXStrings, Interact
mycgrad = cgrad([:MidnightBlue, :LightSeaGreen, :Yellow, :Tomato])
gr(fontfamily = "Palatino", fillcolor = mycgrad, linecolor = mycgrad);