plan(4);

is(conj(1), 1, "conjugate on real scalar");
is(conj(1+1i), 1-1i, "conjugate on complex scalar");
is(conj([1 2;3 4]), [1 2;3 4], "conjugate on real matrix");
is(conj([1+1i 2+2i;3+3i 4+4i]), [1-1i 2-2i;3-3i 4-4i], "conjugate on complex matrix");
