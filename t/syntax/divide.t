plan(5);

a = 123;
b = 789;
A = [4 25; 9 16];
B = [1 2; 3 4];

X = [4.0 12.5; 3.0 4.0];
Y = A./B;
is(X, Y, "symbolic ./ two matrices");

y = 20./5;
is(4, y, "symbolic ./ two scalars");

X = [ 2 12.5; 4.5 8 ];
Y = A./2;
is(X, Y, "symbolic ./ a matrix and a scalar");

% TODO: syntax error currently
start_todo("syntax error on symbolic .\\");
    ok(0, "symbolic .\\ on two matrices");
    %Y = A.\B;
    %is(floor(times(X, m100)), floor(times(Y, m100)), "symbolic .\\ on two matrices");
end_todo();

start_todo("syntax error on symbolic .\\");
    ok(0, "symbolic .\\ on two scalars");
    %y = 3.\27;
    %is(x, y, "symbolic .\\ on two scalars");
end_todo();
