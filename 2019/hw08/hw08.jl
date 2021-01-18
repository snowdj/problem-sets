function lagrange_example()
    xgrid = ygrid = -5:0.01:5
    p = contour(xgrid, ygrid, (x,y) -> x^2 + y^2, 
                aspect_ratio = 1, size = (400,400), 
                colorbar = false)
    contour!(p, xgrid, ygrid, (x,y) -> x + y, 
             levels = [5], legend = false)
    plot!(p, [(5,0),(5,5),(0,5),(5,0)], seriestype=:shape, 
              fillcolor = :purple, fillopacity = 0.2, linewidth = 0)
    p
end

function minimax_example()
    b, c, d, w = 0.2, 0.55, 0.8, 0.1
    p = plot([(0,0), (1,0), (1,1), (0,1)], seriestype = :shape, fillopacity = 0.3)
    plot!(p,[(0,b),(c,b),(c,d-w),(1,d-w),(1,d),(c-w,d),(c-w,d-w),(c-w,b+w),(0,b+w)], 
            seriestype = :shape, fillopacity = 0.7, fontfamily = "Palatino")
    plot!(p, [(0.75, 0), (0.85, 0), (0.85, 0.4), (0.75, 0.4)], 
              seriestype = :shape, primary = false, fillopacity = 0.7)
    plot!(p, [(0.15, 1), (0.25, 1), (0.25, 0.6), (0.15, 0.6)], 
              seriestype = :shape, primary = false, fillopacity = 0.7)
    plot!(p, xlims = (0,1), ylims = (0,1), size = (400,400), legend = false)
    p
end

"""
Simulate a dataset with two classes and train a
support vector classifier on those data
"""
function simulate_and_train(;sample_size=100, dim=20, μ=1.0, kernel=LIBSVM.Kernel.Linear, C=100.0)
    n = sample_size ÷ 2
    X = [randn(n, dim); randn(n, dim) .+ μ*ones(1, dim)]
    y = repeat([-1, 1], inner = n)
    X, y, svmtrain(X', y, kernel = kernel, cost = C);
end

"""
Determine whether the classes are separable in the β direction
"""
function separated(X, y, β)
    ŷ = X * β
    maximum(ŷ[y .== 1]) < minimum(ŷ[y .== -1])
end

"""
Generate `num_rums` data sets of size `sample_size`, 
and return two vectors: one containing the number of 
support vectors, and one containing Bools which 
indicate whether the data were linearly separable.
"""
function count_support_vectors(;num_runs=100, sample_size=100, dim=20, μ=1, C=100.0)
    sep_values = []
    SV_counts = []
    for _ in 1:num_runs
        X, y, model = simulate_and_train(sample_size=sample_size, dim=dim, μ=μ, C=C)
        push!(SV_counts, size(model.SVs.X, 2))
        β = model.SVs.X * model.coefs
        push!(sep_values, separated(X, y, β))
    end
    # mapping the identity over an array is a trick for
    # "tightening" the type associated with the array
    map(identity, SV_counts), map(identity, sep_values)
end

function load_MNIST_zeros_and_ones()
    features, labels = MNIST.traindata()
    features = reshape(features[:, :, labels .∈ Ref((0, 1))], (28^2, :))
    labels = labels[labels .∈ Ref((0,1))];
    float(features), labels
end

function svm_projections()
    Random.seed!(123)
    X = [randn(20) .- 4 randn(20);
         randn(20) .+ 4 randn(20) .+ 4]
    y = repeat([-1,1], inner = 20)
    model = svmtrain(X', y, kernel = LIBSVM.Kernel.Linear)
    β = model.SVs.X * model.coefs
    p = scatter(X[:,1], X[:,2], group = y, legend = :bottomright, size = (450,300), ratio = 1)
    heatmap!(p, -8:0.01:8, -3:0.01:8, (x,y) -> svmpredict(model, reshape([x,y], (2,1)))[1][1], 
             fillopacity = 0.25, fillcolor = cgrad([:blue, :red]), colorbar = false)
    plot!(p, -5:2, x -> -β[1]*x/β[2], label = "", color = :gray)
    for j in 1:10
        proj_point = Tuple(X[j,:] .- β*(X[j,:]⋅β/(β⋅β)))
        plot!(p, [Tuple(X[j,:]), proj_point], arrow=arrow(), label = "", primary = false)
        scatter!(p, [proj_point], color = :lightblue, label = "", primary = false)
    end
    p
end