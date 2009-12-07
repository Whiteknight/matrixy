plan(9);

is(abs(-1), 1, "abs on a simple negative integer");
is(abs(-1.2), 1.2, "abs on a negative float");
is(abs(3+4i), 5, "complex abs 1");
is(abs(9+40i), 41, "complex abs 2");
is(abs(3/2+2i), 2.5, "simple rational abs");

is(abs(3+4i), 5, "complex abs 1");
is(abs(9+40i), 41, "complex abs 2");
is(abs(3/2+2i), 2.5, "simple rational abs");

start_todo("cannot compare complex and normal matrices yet");
is(abs([ 5+12i, -20; 20, -9-40i ]), [ 13 20; 20 41], "various abs");
end_todo();
