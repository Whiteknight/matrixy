plan(7);
p = pi;
is(parrot_typeof(p), "Float", "pi is a normal float");
p = pi(2);
is(parrot_typeof(p), "NumMatrix2D", "pi(2) is a matrix");
is(columns(p), 2);
is(rows(p), 2);

p = pi(3, 4);
is(parrot_typeof(p), "NumMatrix2D", "pi(3, 4) is a matrix");
is(columns(p), 4);
is(rows(p), 3);