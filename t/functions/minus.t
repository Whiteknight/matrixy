plan(2);

a = 123;
b = 789;
A = [4 25; 9 16];
B = [1 2; 3 4];

X = [3 23; 6 12];
Y = minus(A,B);
is(X, Y, "subtract two matrices");

y = minus(a,b);
is(-666, y, "minus a negative scalar");
