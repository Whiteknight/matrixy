function plan(x)
%% plan(x)
%% prints a TAP test plan with x tests to be run.
    global _TAP_TEST_CNT;
    global _TAP_TODO;
    _TAP_TODO = 0;
    _TAP_TEST_CNT = 1;
    printf("1..%d\n", x);
endfunction