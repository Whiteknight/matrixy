plan(3);

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
