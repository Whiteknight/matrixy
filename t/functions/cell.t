plan(6);
x = cell(2);
is(parrot_typeof(x), "PMCMatrix2D", "cell is PMCMatrix2D");
is(iscell(x), 1, "cell is cell");
is(columns(x), 2, "cell(n) is square, columns");
is(rows(x), 2, "cell(n) is square, rows");

y = cell(3, 4);
is(rows(y), 3, "cell(n, m) is rectangle, columns");
is(columns(y), 4, "cell(n, m) is rectangle, rows");
