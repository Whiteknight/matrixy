plan(2);

% In this file we test try/catch error handling, the error() function, and
% lasterr();

try
    error("This is an error!");
catch
    disp("ok 1");
end_try_catch

try
    error("ok 2");
catch
    my_err = lasterr;
    disp(my_err);
end

