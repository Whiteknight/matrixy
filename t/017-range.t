plan(6);

X = 1:5;
Y = [1 2 3 4 5];
is(X, Y, "two-argument range");

X = 1:1:5;
is(X, Y, "three-argument range");

X = 1:2:10;
Y = [1 3 5 7 9];
is(X, Y, "three-argument range with non-unity step");

X = 5:1
Y = [5 4 3 2 1];
is(X, Y, "two-argument range with implied negative step");

X = 5:(-1):1;
is(X, Y, "three argument range with negative step");

X = 10:(-2):1;
Y = [10 8 6 4 2];
is(X, Y, "three argument range with non-unity negative step");
