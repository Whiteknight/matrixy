plan(3);

x = zeros(1, 1);
is(x(1, 1), 0, "zeros() returns at least 1 zero");


x = zeros(3, 3);
ok(x(1, 1) + x(2, 2) + x(3, 3) == 0, "zeros() returns at least 3 zeros");

x = zeros(4, 7);
y = [ 0 0 0 0 0 0 0; 0 0 0 0 0 0 0; 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 ];
ok(isequal(x,y), "zeros with non-same args returns what we expect");
