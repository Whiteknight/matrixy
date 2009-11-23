plan(3);

x = zeros(1, 1);
y = [0];
ok(isequal(x,y), "zeros(1,1) works");

x = zeros(3, 3);
y = [0 0 0;0 0 0;0 0 0];
ok(isequal(x,y), "zeros(3,3) works");

x = zeros(4, 7);
y = [ 0 0 0 0 0 0 0; 0 0 0 0 0 0 0; 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 ];
ok(isequal(x,y), "zeros with non-same args returns what we expect");
