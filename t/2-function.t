disp("1..10");

% Basic function call with no args
function bar
    printf("ok 1\n");
end
bar();

% Function call with 1 arg
function foo(x)
    disp(x);
end
foo("ok 2");

% Function call with an alphanumeric name
function foo2(x)
    printf(x);
endfunction
foo2("ok 3\n");

% Function call with one return argument and one parameter, but no returned
% value
function y = foo3(x)
    printf("%s\n", x);
end
foo3("ok 4");

% function with 1 return parameter, and another lexically-scoped variable
function y = foo4(x)
    y = 5;
    r = 100;
end
myret = foo4("dummy");
if myret == 5
    printf("ok 5\n");
else
    printf("not ok 5\n");
endif

% Test a combination of functions, including calling functions from functions
% and using function output arguments as inputs to other functions.
function pi2
    return 3.14;
end

function  c = circum(r)
    c = double( pi2() * r );
end

function d = double(x)
    d = 2 * x;
end

function z = ten()
    z = 10;
end

x = double(circum(ten() * 5));

if x == 200 * pi2()
    printf("ok 6\n");
else
    printf("not ok 6\n");
endif

% Test nargin and varargin
function argsintest(varargin)
    printf("ok %d\n", nargin + 6);
endfunction
argsintest(5);
argsintest(6, 7);
argsintest(8, 9, 10);

% Test nargout
function x = argsouttest()
    if nargout == 1
        printf("ok 10\n");
    else
        printf("not ok 10 # TODO need to implement nargout\n");
    endif
endfunction
a = argsouttest();
