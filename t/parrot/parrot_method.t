plan(4);

x = [1];
is(columns(x), 1);
is(rows(x), 1);
parrot_method(x, "resize", 2, 7);
is(columns(x), 7);
is(rows(x), 2);