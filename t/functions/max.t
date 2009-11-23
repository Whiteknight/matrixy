plan(4);

# max (only non complex scalar types supported currently)
is(max(10,5), 10, "max integers")
is(max(10.5,5.5), 10.5, "max floats")
is(max(-10.5,5.5), 5.5, "max negative, positive floats")
is(max(-10.5,-5.5), -5.5, "max negative floats")
