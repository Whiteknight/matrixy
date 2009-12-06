plan(2);

a = 123;
b = 789;
A = [4 25; 9 16];
B = [1 2; 3 4];

X = [5 27; 12 20];
Y = A + B;
is(X, Y, "Symbolic + two matrices");

y = a + b;
is(912, y, "symbolic + two scalars");