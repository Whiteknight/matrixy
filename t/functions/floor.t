plan(2);

A = [2.3 4.5; 6.7 8.9];
B = [2 4; 6 8];
B1 = floor(A);
is(B1, B, "floor() on a matrix");

A = 10.2;
B = 10;
B1 = floor(A);
is(B1, B, "floor() on a scalar");
