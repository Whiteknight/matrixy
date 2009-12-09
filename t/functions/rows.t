plan(3);

is(rows([1;2;3]), 3);
is(rows(1), 1);
is(rows({"a";1;@columns}), 3);

