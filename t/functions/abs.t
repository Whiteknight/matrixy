plan(4);

# abs (use some pythagorean triples)
is(abs(3+4i), 5, "complex abs 1")
is(abs(9+40i), 41, "complex abs 2")
is(abs([ 5+12i, -20; 20, -9-40i ]), [ 13 20; 20 41], "various abs")
is(abs(3/2+2i), 2.5, "simple rational abs")
