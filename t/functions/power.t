plan(2);

a = 123;
b = 789;
A = [4 25; 9 16];
B = [1 2; 3 4];

% Power
X = [4 625; 729 65536];
Y = power(A, B);
is(X, Y, "power() on two matrices");

x = 15129;
y = power(a, 2);
is(x, y, "power() on two scalars");

