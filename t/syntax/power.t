plan(2);

a = 123;
b = 789;
A = [4 25; 9 16];
B = [1 2; 3 4];

Y = A.^B;
is([4 625; 729 65536], Y, "Symbolic .^ on two matrices");

y = a.^2;
is(15129, y, "symbolic .^ on two scalars");
