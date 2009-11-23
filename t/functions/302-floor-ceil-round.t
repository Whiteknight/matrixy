plan(7);

A = [2.3 4.5; 6.7 8.9];
B = [2 4; 6 8];
B1 = floor(A);
is(B1, B, "floor() on a matrix");

A = 10.2;
B = 10;
B1 = floor(A);
is(B1, B, "floor() on a scalar");

A = [2.3 4.5; 6.7 8.9];
B = [3 5; 7 9];
B1 = ceil(A);
is(B1, B, "ceil() on a matrix");

A = 20.3;
B = 21;
B1 = ceil(A);
is(B1, B, "ceil() on a scalar");

A = [2.3 4.5; 4.49 9.51];
B = [2 5; 4 10];
B1 = round(A);
is(B1, B, "round() on a matrix");

A = 10.49;
B = 10;
B1 = round(A);
is(B1, B, "round() on a scalar (round down)");

A = 10.50;
B = 11;
B1 = round(A);
is(B1, B, "round() on a scalar (round up)");
