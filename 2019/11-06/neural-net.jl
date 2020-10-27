using Flux
using Flux: onecold, onehotbatch, crossentropy, params, throttle
using Base.Iterators: repeated

function gensample(k)
    r(t) = 1-2t/3
    f1(t) = [-1/2 + r(t)*cos(k*π*t), r(t)*sin(k*π*t)]
    f2(t) = [-1/2 - r(t)*cos(k*π*t), -r(t)*sin(k*π*t)]
    if rand(Bool)
        f1(rand()) + 0.05*randn(2), 0
    else
        f2(rand()) + 0.05*randn(2), 1
    end
end

n = 1000
X = zeros(2,n)
Y = zeros(n)
for i=1:n
    X[:,i] , Y[i] = gensample(1.5)
end
Y = onehotbatch(Y, 0:1); 