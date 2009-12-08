plan(7);
_e = e;
is(parrot_typeof(_e), "Float", "e is a normal float");
_e = e(2);
is(parrot_typeof(_e), "NumMatrix2D", "e(2) is a matrix");
is(columns(_e), 2);
is(rows(_e), 2);

_e = e(3, 4);
is(parrot_typeof(_e), "NumMatrix2D", "e(3, 4) is a matrix");
is(columns(_e), 4);
is(rows(_e), 3);