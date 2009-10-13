plan(11);

ok(1, "first");
ok(2 == 2, "second");
is(3, 3, "third");
nok(0, "fourth");

start_todo("functions expected to fail");

ok(0, "fifth");
ok(1 == 2, "sixth");
is(3, 4, "seventh");
nok(1, "eighth");

end_todo();

x = 1;
y = 0;
ok(x, "ninth");
is(x, 1, "tenth");
nok(y, "eleventh");

