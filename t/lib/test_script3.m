% Test that if there is a function declaration here of the same name, we
% call that instead of other stuff in the file

ok(0, "executed other stuff")

function test_script3()
    ok(1, "executed correctly");
endfunction
