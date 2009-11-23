plan(12);


# abs (use some pythagorean triples)
is(abs(3+4i), 5, "complex abs 1")
is(abs(9+40i), 41, "complex abs 2")
is(abs([ 5+12i, -20; 20, -9-40i ]), [ 13 20; 20 41], "various abs")
is(abs(3/2+2i), 2.5, "simple rational abs")

# max (only non complex scalar types supported currently)
is(max(10,5), 10, "max integers")
is(max(10.5,5.5), 10.5, "max floats")
is(max(-10.5,5.5), 5.5, "max negative, positive floats")
is(max(-10.5,-5.5), -5.5, "max negative floats")


# min (only non complex scalar types supported currently)
is(min(10,5), 5, "min integers")
is(min(10.5,5.5), 5.5, "min floats")
is(min(-10.5,5.5), -10.5, "min negative, positive floats")
is(min(-10.5,-5.5), -10.5, "min negative floats")