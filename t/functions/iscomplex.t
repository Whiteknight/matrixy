plan(4)
is(iscomplex(1), 0, "real is not complex");
is(iscomplex(1+1i), 1, "complex is complex");
is(iscomplex([2+2i]), 1, "complex matrix is complex");
is(iscomplex(3i), 1, "imaginary is complex");
