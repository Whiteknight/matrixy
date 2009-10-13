plan(3);

x = ones(1, 1);
is(x(1, 1), 1, "the first element is 1");

x = ones(3, 3);
ok(x(1, 1) + x(2, 2) + x(3, 3) == 3, "an assortment of values are 1");

x = ones(4, 7);
y = [ 1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 ];
is(x, y, "ones() with arguments that aren't equal");
