plan(2)

a = 123;
b = 789;
A = [4 25; 9 16]; 
B = [1 2; 3 4];

X = [3 23; 6 12];
Y = A-B;
is(X, Y, "symbolic sybtract two matrices");

x = -666;
y = a-b;
is(x, y, "symbolic - two scalars");
