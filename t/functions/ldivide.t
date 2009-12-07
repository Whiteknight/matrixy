plan(2);

a = 123;
b = 789;
A = [4 25; 9 16];
B = [1 2; 3 4];

m100 = [100 100; 100 100];
X = [0.25 0.08; 0.333333 0.25];
Y = ldivide(A, B);
is(floor(times(X, m100)), floor(times(Y, m100)), "ldivide() two matrices");

x = 9;
y = ldivide(3, 27);
is(x, y, "ldivide() two scalars");
