function sep = filesep()
    os = computer('parrotos');
    if os == "MSWin32"
        sep = "\\";
    else
        sep = "/";
    end
end
