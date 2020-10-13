using Base64
io = IOBuffer()
iob64_encode = Base64EncodePipe(io)
write(iob64_encode, """
begin
    # X = 2.0 .+ 3randn(10)
    mysample = [-0.3158449050816192, 1.0231649888798504, 1.9117770902002116, 2.504598442341676, 4.968809090699897, -2.4899557184464394, 3.0741347708680196, 5.148240637619786, 2.101505157727294, 1.3321877268998883]
    
    function check_var_sample_max(v)
        if abs(v-5/252) < 0.002
            "correct! The variance is 5/252"
        else
            "not close enough!"
        end
    end
    
    function traps_mean(confidence_interval)
        a = rand(Uniform(-10,10))
        b = rand(Uniform(-10,10))
        n = rand(DiscreteUniform(5,20))
        X = a .+ b*randn(n)
        println("X is \$(round.(X; digits=2))")
        println("confidence interval is \$(confidence_interval(X))")
        println("actual mean of underlying distribution is \$a")
        c,d = confidence_interval(X)
        if c < a < d
            printstyled("interval traps \$a\n", color = :green)
            true
        else
            printstyled("interval does not trap \$a\n", color = :red)
            false
        end
    end
    
    function traps_max(confidence_interval)
        b = rand(Uniform(0,100))
        n = rand(DiscreteUniform(5,20))
        X = rand(Uniform(0,b), n)
        println("X is \$(round.(X; digits=2))")
        println("confidence interval is \$(confidence_interval(X))")
        println("actual max of underlying distribution is \$b")
        c,d = confidence_interval(X)
        if c < b < d
            printstyled("interval traps \$b\n", color = :green)
            true
        else
            printstyled("interval does not trap \$b\n", color = :red)
            false
        end
    end

    function check_mean(μ)
        if abs(μ-2.3) < 0.02
            "correct! The mean is 2.3"
        else
            "not close enough!"
        end
    end
    
    function check_var(v)
        if abs(v-1.41) < 0.02
            "correct! The variance is 1.41"
        else
            "not close enough!"
        end
    end
    
    function mysteryRV() 
        rand(Bernoulli(0.5)) + rand(Bernoulli(0.8)) + rand(Exponential(1))
    end
end
""")

close(iob64_encode)
str = String(take!(io))
write("mystery-distribution.jl", "import Base64\n\nusing Distributions\n\neval(Meta.parse(String(Base64.base64decode(\"$str\"))))")