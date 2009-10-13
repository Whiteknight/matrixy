function is(a, b, comment)
%% is(a, b, comment)
%% tests that the two values a and b are equal. Calls ok() to handle
%% the test output logic, so has all the same capabilities as that
%% function.
    ok(a == b, comment);
endfunction