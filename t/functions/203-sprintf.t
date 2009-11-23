plan(3);

a = sprintf("%d", 5);
ok(a == "5", "sprintf() with a %d");

a = sprintf("%s world", "hello");
ok(a == "hello world", "sprinf() with a %s");

a = sprintf("%.2f", 123.456789);
is(a, "123.46", "sprintf() with %f and modifiers");
