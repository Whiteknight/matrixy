function f = isunix()
    os = computer('parrotos');
    if os == "linux"
        f = 1;
    else
        f = 0;
    end
end
