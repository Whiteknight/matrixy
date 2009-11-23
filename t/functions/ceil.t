plan(2);

A = [2.3 4.5; 6.7 8.9];
B = [3 5; 7 9];
B1 = ceil(A);
is(B1, B, "ceil() on a matrix");

A = 20.3;
B = 21;
B1 = ceil(A);
is(B1, B, "ceil() on a scalar");
