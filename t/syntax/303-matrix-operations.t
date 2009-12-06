plan(27);

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

X = [3 23; 6 12];
Y = minus(A,B);
is(X, Y, "subtract two matrices");

y = minus(a,b);
is(-666, y, "minus a negative scalar");

% Times
X = [4 50; 27 64];
Y = times(A,B);
is(X, Y, "times() tow matrices");



x = 97047;
y = times(a,b);
is(x, y, "times() two scalars");


% RDivide
X = [4.0 12.5; 3.0 4.0];
Y = rdivide(A, B);
is(X, Y, "rdivide() two matrices");


x = 4;
y = rdivide(20, 5);
is(x, y, "rdivide() two scalars");

% LDivide
m100 = [100 100; 100 100];
X = [0.25 0.08; 0.333333 0.25];
Y = ldivide(A, B);
is(floor(times(X, m100)), floor(times(Y, m100)), "ldivide() two matrices");

x = 9;
y = ldivide(3, 27);
is(x, y, "ldivide() two scalars");


% Power
X = [4 625; 729 65536];
Y = power(A, B);
is(X, Y, "power() on two matrices");

x = 15129;
y = power(a, 2);
is(x, y, "power() on two scalars");

