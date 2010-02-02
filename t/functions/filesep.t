plan(1);

separator = filesep();
platform = computer('parrotos');
if platform == "MSWin32"
    ok(separator == "\\");
else
    ok(separator == "/");
end
