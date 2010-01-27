plan(3);

is(columns([1, 2, 3]), 3);
is(columns(1), 1);
is(columns({"a", 1, @columns}), 3);

