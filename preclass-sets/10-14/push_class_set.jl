
original_dir = pwd()

try
    dirname = basename(pwd()) # name of current homework, like hw07

    target = "/Users/sswatson/GitHub/problem-sets-1010/$dirname"

    dir_created = false
    if !isdir(target)
        mkdir(target)
        dir_created = true
    end
    
    for file in ARGS
        cp(file, "$target/$file", force = true)
    end

    cd(target)
    run(`git add \*`)
    msg = dir_created ? "add $dirname" : "update $dirname"
    run(`git commit -m $msg`)
    run(`git push`)
    
finally
    cd(original_dir)
end