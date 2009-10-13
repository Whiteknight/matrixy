% Test that if there is a function declaration here, we call that instead of
% other stuff in the file

printf("not ok 15\n");

function test_script3()
    printf("ok 15\n");
endfunction
