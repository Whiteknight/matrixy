plan(2);

a = 123;
b = 789;
A = [4 25; 9 16];
B = [1 2; 3 4];

X = [4.0 12.5; 3.0 4.0];
Y = rdivide(A, B);
is(X, Y, "rdivide() two matrices");

x = 4;
y = rdivide(20, 5);
is(x, y, "rdivide() two scalars");
