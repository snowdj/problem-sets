n = 200
X = [rand(n,2); [0.5 0] .+ rand(n, 2)]
y = repeat(["red", "blue"], inner = n)
function gini(x, op) 
    inds = op.(X[:,1], x)
    n = count(inds)
    n_red = count(inds .& (y .== "red"))
    n_blue = count(inds .& (y .== "blue"))
    1 - (n_red/n)^2 - (n_blue/n)^2
end
prop(x, op) = count(op.(X[:,1], x))/size(X,1)
loss(x) = count(X[:,1] .< x)/n * gini(x, <) + count(X[:,1] .> x)/n * gini(x, >)
function threshold_visualization(x)
    p = scatter(X[1:n,1], X[1:n,2], size = (600,400), ratio = 1, color = :red, label = "")
    scatter!(p,X[n+1:end,1], X[n+1:end,2], color = :blue, label = "")
    vline!(p,[x], xlims = (0,3), fontfamily = "Palatino", label = "")
    annotate!(p,[(2.2,0.25,"Gini impurity left: $(round(gini(x, <);digits=2))")])
    annotate!(p,[(2.2,0.1,"Gini impurity right: $(round(gini(x, >);digits=2))")])
    annotate!(p,[(2.2,-0.1,"proportion left: $(round(prop(x, <);digits=2))")])
    annotate!(p,[(2.2,-0.25,"proportion right: $(round(prop(x, >);digits=2))")])
    scatter!(p,[(x, prop(x, <) * gini(x, <) + prop(x, >) * gini(x, >) - 0.5)], color = :green, label = "")
    plot!(p,-0:0.01:1.5, t -> prop(t, <) * gini(t, <) + prop(t, >) * gini(t, >) - 0.5, color = :green, label = "loss")
    plot!(p,-0:0.01:1.5, t -> prop(t, <) * gini(t, <) - 0.65, color = :pink, label="")
    plot!(p,-0:0.01:1.5, t -> prop(t, >) * gini(t, >) - 0.65, color = :lightblue, label="")
    p
end


function gini_draw(n_red_left, n_red_right, n_blue_left, n_blue_right)
    plot(;legend=false, frame = :none, fontfamily = "Palatino")
    annotate!([(-0.25,0.5,text("split:",10))])
    plot!([0, 1, 1, 0, 0], [0, 0, 1, 1, 0], color = :black)
    plot!(1.5 .+ [0, 1, 1, 0, 0], [0, 0, 1, 1, 0], color = :black)
    scatter!([(rand(),rand()) for i in 1:n_red_left], color = :red)    
    scatter!([(1.5+rand(),rand()) for i in 1:n_red_right], color = :red)
    scatter!([(rand(),rand()) for i in 1:n_blue_left], color = :blue)    
    scatter!([(1.5+rand(),rand()) for i in 1:n_blue_right], color = :blue)
end


function gini_split(n_red, n_blue)
    n_red_left = rand(1:n_red)
    n_red_right = n_red - n_red_left
    n_blue_left = rand(1:n_blue)
    n_blue_right = n_blue - n_blue_left
    n_red_left, n_red_right, n_blue_left, n_blue_right
end

function impurity_score(n_red_left, n_left, n_red_right, n_right)
    gini_impurity(p) = 1 - p^2 - (1-p)^2
    p_left, p_right = [n_left, n_right]/(n_left + n_right)
    p_left * gini_impurity(n_red_left / n_left) + p_right * gini_impurity(n_red_right / n_right)
end
    
function gini_game(n)
    global score_report = ""
    n_red, n_blue = rand(1:n, 2)
    n_red_left = rand(1:n_red)
    plots, splits = [], []
    for _ in 1:2
        push!(splits,gini_split(n_red, n_blue))
        push!(plots,gini_draw(splits[end]...))
    end
    for i in 1:2
        n_red_left, n_red_right, n_blue_left, n_blue_right = splits[i]
        score = impurity_score(n_red_left, n_red_left + n_blue_left,
                               n_red_right, n_red_right + n_blue_right)
        score_report *= "loss for row $i: $score\n"
    end
    plot(plots..., layout = (2,1), size = (400, 400), ratio = 1)
end


