plan(4);

x = {};
is(parrot_typeof(x), "PMCMatrix2D");
ok(iscell(x));
is(columns(x), 0);
is(rows(x), 0);

# Tests to do:
# non-empty cell
# cell () indexing lvalue
# cell () indexing rvalue
# cell () indexing autoextend
# cell {} indexing lvalue
# cell {} indexing rvalue
# cell {} indexing autovivify
