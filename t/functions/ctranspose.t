plan(4);

is(ctranspose(1), 1, "ctranspose on real scalar");
is(ctranspose(1+1i), 1-1i, "ctranspose on complex scalar");
is(ctranspose([1 2;3 4]), [1 3;2 4], "ctranspose on real matrix");
is(ctranspose([1+1i 2+2i;3+3i 4+4i]), [1-1i 3-3i;2-2i 4-4i], "conjugate on complex matrix");
