disp("1..4")

% Test that we have a PATH environment variable
if getenv('PATH') != ''
    printf("ok 1\n");
else
    printf("not ok 1\n");
end

% Add a new environment variable, and test that we've done it
setenv('_TESTVAR', 'some data')
if getenv('_TESTVAR') == 'some data'
    printf("ok 2\n");
else
    printf("not ok 2\n");
end

% Create a new environment variable with no value
setenv('_TESTVAR')
if getenv('_TESTVAR') == ''
    printf("ok 3\n");
else
    printf("not ok 3\n");
end

% Try to get a non-existent variable, verify that we didn't get anything.
if getenv('__SOME__NONEXISTENT__VAR__') == ''
    printf("ok 4\n");
else
    printf("not ok 4\n");
end