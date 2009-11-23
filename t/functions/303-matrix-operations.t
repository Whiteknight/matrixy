plan(27);

a = 123;
b = 789;
A = [4 25; 9 16]; 
B = [1 2; 3 4];

% Add two matrices
X = [5 27; 12 20];
Y = plus(A,B);
is(X, Y, "add two matrices");

Y = A + B;
is(X, Y, "Symbolic + two matrices");

x = 912;
y = plus(a,b);
is(x, y, "plus() two scalars");

y = a + b;
is(x, y, "symbolic + two scalars");

% Minus
X = [3 23; 6 12];
Y = minus(A,B);
is(X, Y, "subtract two matrices");

Y = A-B;
is(X, Y, "symbolic sybtract two matrices");

x = -666;
y = minus(a,b);
is(x, y, "minus a negative scalar");

y = a-b;
is(x, y, "symbolic - two scalars");

% Times
X = [4 50; 27 64];
Y = times(A,B);
is(X, Y, "times() tow matrices");

Y = A.*B;
is(X, Y, "Symbolic .* two matrices");

x = 97047;
y = times(a,b);
is(x, y, "times() two scalars");

X = [4 50; 27 64];
y = a.*b;
is(x, y, "symbolic .* two scalars");

X = [3156 19725; 7101 12624];
Y = A.*b;
is(X, Y, "symbolic .* a matrix and a scalar");

X = [123 246 ; 369 492];
Y = a.*B;
is(X, Y, "symbolic .* a scalar and a matrix");

% RDivide
X = [4.0 12.5; 3.0 4.0];
Y = rdivide(A, B);
is(X, Y, "rdivide() two matrices");

Y = A./B;
is(X, Y, "symbolic ./ two matrices");

x = 4;
y = rdivide(20, 5);
is(x, y, "rdivide() two scalars");

y = 20./5;
is(x, y, "symbolic ./ two scalars");

X = [ 2 12.5; 4.5 8 ];
Y = A./2;
is(X, Y, "symbolic ./ a matrix and a scalar");

% LDivide
m100 = [100 100; 100 100];
X = [0.25 0.08; 0.333333 0.25];
Y = ldivide(A, B);
is(floor(times(X, m100)), floor(times(Y, m100)), "ldivide() two matrices");

% TODO: syntax error currently
start_todo("syntax error on symbolic .\\");
    ok(0, "symbolic .\\ on two matrices");
    %Y = A.\B;
    %is(floor(times(X, m100)), floor(times(Y, m100)), "symbolic .\\ on two matrices");
end_todo();

x = 9;
y = ldivide(3, 27);
is(x, y, "ldivide() two scalars");

start_todo("syntax error on symbolic .\\");
    ok(0, "symbolic .\\ on two scalars");
    %y = 3.\27;
    %is(x, y, "symbolic .\\ on two scalars");
end_todo();

% Power
X = [4 625; 729 65536];
Y = power(A, B);
is(X, Y, "power() on two matrices");

Y = A.^B;
is(X, Y, "Symbolic .^ on two matrices");

x = 15129;
y = power(a, 2);
is(x, y, "power() on two scalars");

y = a.^2;
is(x, y, "symbolic .^ on two scalars");
