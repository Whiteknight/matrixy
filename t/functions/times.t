plan(2);

a = 123;
b = 789;
A = [4 25; 9 16];
B = [1 2; 3 4];

X = [4 50; 27 64];
Y = times(A,B);
is(X, Y, "times() tow matrices");

x = 97047;
y = times(a,b);
is(x, y, "times() two scalars");
