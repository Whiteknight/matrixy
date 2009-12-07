plan(2);

a = 123;
b = 789;
A = [4 25; 9 16];
B = [1 2; 3 4];

% Add two matrices
X = [5 27; 12 20];
Y = plus(A,B);
is(X, Y, "add two matrices");

x = 912;
y = plus(a,b);
is(x, y, "plus() two scalars");


