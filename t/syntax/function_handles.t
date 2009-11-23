plan(10);

% Test anonymous function with no arguments
foo = @() 5;
if foo() == 5
    disp("ok 1");
else
    disp("not ok 1");
end

% Test an anonymous function with one argument
f = @(x) x+1;
if f(100) == 101
    disp("ok 2");
else
    disp("not ok 2");
endif

% Test that function handles are what we think they are:
y = @(x) printf("ok %d\n", x);
if parrot_typeof(y) == "Sub"
    disp("ok 3");
else
    disp("not ok 3");
end

function z(x)
    printf("ok %d\n", x);
endfunction
w = @z;
if parrot_typeof(w) == "Sub"
    disp("ok 4");
else
    disp("not ok 4");
end

% Test that we can feval on function handles
feval(y, 5);
feval(w, 6);

% Test anonymous function with two arguments
g = @(x, y) x*y;
if g(10,6) == 60
    disp("ok 7");
else
    disp("not ok 7");
endif

% Anonymous function with two references to the input argument
h = @(x) x*x + 1;
if h(10) == 101
    disp("ok 8");
else
    disp("not ok 8");
endif

% Anonymouse function test base case
if h(0) == 1
    disp("ok 9");
else
    disp("not ok 9");
endif

% Function handles do not execute without parens like builtin functions do.
% Test that this is true
k = @() disp("not ok 10");
k;      % Shouldn't print
l = @() disp("ok 10");
l();    % does print
