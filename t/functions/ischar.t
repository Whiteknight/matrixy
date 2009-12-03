plan(3);
is(ischar(1), 0, "number is not char");
is(ischar("a"), 1, "string is char");
is(ischar(["a"]), 1, "char matrix is char");

