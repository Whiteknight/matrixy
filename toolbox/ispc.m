function f = ispc()
    os = computer('parrotos');
    if os == "MSWin32"
        f = 1;
    else
        f = 0;
    end
end