using Random
Random.seed!(123)

function randpoint()
    p = rand()
    if p < 0.4
        rand(MvNormal([0.4, 0.2], [1.0 0.2; 0.2 0.5]))
    elseif p < 0.75
        rand(MvNormal([3.0, -2.5], [0.7 -0.1; -0.1 0.6]))
    else
        rand(MvNormal([-3.0, -1.5], [0.7 0; 0 0.2]))
    end
end

X = [randpoint() for i in 1:100]
scatter(Tuple.(X), color = :gray)