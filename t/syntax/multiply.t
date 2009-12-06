plan(4);

a = 123;
b = 789;
A = [4 25; 9 16];
B = [1 2; 3 4];

X = [4 50; 27 64];
Y = A.*B;
is(X, Y, "Symbolic .* two matrices");


y = a.*b;
is(97047, y, "symbolic .* two scalars");

X = [3156 19725; 7101 12624];
Y = A.*b;
is(X, Y, "symbolic .* a matrix and a scalar");

X = [123 246 ; 369 492];
Y = a.*B;
is(X, Y, "symbolic .* a scalar and a matrix");

