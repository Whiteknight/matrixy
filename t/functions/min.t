plan(4);

# min (only non complex scalar types supported currently)
is(min(10,5), 5, "min integers")
is(min(10.5,5.5), 5.5, "min floats")
is(min(-10.5,5.5), -10.5, "min negative, positive floats")
is(min(-10.5,-5.5), -10.5, "min negative floats")
