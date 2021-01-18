function network_viz(Ws, bs, x, y; textsize = 8)
    L = length(Ws) + 1
    widths = [size(Ws[1], 2); [length(b) for b in bs]]
    layers = [[(i,
                j-widths[i]/2) for j in 1:widths[i]] for i in 1:L]
    xlims = (0.5, L+0.5)
    ylims = (-maximum(widths)/2+0.5, maximum(widths)/2+0.5)
    p = plot(legend = false, frame = :none, size = (600, 350), xlims = xlims, ylims = ylims)
    for i in 1:L-1
        for j in 1:widths[i]
            for k in 1:widths[i+1]
                plot!(p, [(layers[i][j][1] + (1 < i < L ? 0.25 : 0), layers[i][j][2]), 
                        (layers[i+1][k][1] + (1 < i+1 < L ? -0.25 : 0), layers[i+1][k][2])], 
                       linewidth = abs(Ws[i][k,j]), 
                       linecolor = Ws[i][k,j] > 0 ? :DarkGreen : :DarkOrange)
            end
        end
    end
    K(x) = x > 0 ? x : 0.0
    activations = [x]
    preactivations = [x]
    for i in 1:L-1
        push!(preactivations, Ws[i]*activations[end]+bs[i])
        push!(activations, K.(preactivations[end]))
    end
    for (j, layer, preactivation_vector, activation_vector) in 
                                zip(1:L, layers, preactivations, activations)
        #scatter!(layer, color = :MidnightBlue, ms = 18)
        if 1 < j < L
            for neuron in layer
                pill!(p, neuron)
            end
        else
            scatter!(p, layer, ms = 18, color = j == 1 ? :DarkGray : :MidnightBlue)
        end
        for (neuron, preactivation, activation) in 
                            zip(layer, preactivation_vector, activation_vector)
            if 1 < j < L
                annotate!(p, [(neuron[1]+0.15, neuron[2], text(disp(activation), textsize, :white))])
            end
            annotate!(p ,[(neuron[1] - (1 < j < L ? 0.15 : 0), 
                           neuron[2], text(disp(preactivation), textsize, :white))])
        end
    end
    scatter!(p, [(5.25,1.5)], ms = 18, color = :DarkGray, xlims = (0.5, 6.5))
    annotate!(p, [(5.25,1.5,text(disp(y), 8, :white))])
    scatter!(p, [(5.5,0.5)], ms = 18, color = :DarkRed, xlims = (0.5, 6.5))
    annotate!(p, [(5.5,0.5,text(disp((activations[end][1] - y)^2), 8, :white))])
    p
end

disp(x) = string(round(x, digits=1))

function pill!(p, pair)
    a,b = pair
    ϵ = 0.2
    w = 0.6ϵ
    h = 1.5ϵ
    plot!(p, [[(a + w, b - h), (a, b - h), (a, b + h), (a + w, b + h)]; 
            [(a + w + ϵ*cos(t), b + h*sin(t)) for t in range(-π/2,π/2,length=100)]], seriestype = :shape)
    plot!(p, [[(a - w, b - h), (a, b - h), (a, b + h), (a - w, b + h)]; 
            [(a - w + ϵ*cos(t), b + h*sin(t)) for t in range(-π/2,-3π/2,length=100)]], seriestype = :shape)
    plot!(p, [(a, b - h),(a, b + h)], linecolor = :white)
end

arch = [4, 8, 6, 8, 1]
using Random; Random.seed!(1)
Ws = [randn(arch[i+1], arch[i])/2 for i in 1:length(arch)-1]
bs = [randn(arch[i+1])/2 for i in 1:length(arch)-1]
x₁ = randn(arch[1])
x₂ = randn(arch[1])