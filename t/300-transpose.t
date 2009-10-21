plan(8)

# Currently tranpose has been implemented using blas routines.
# This really for historic reasons because it helped in developing
# BLAS support. Once we have a proper benchmarking function we should
# redo this using simple PIR and compare the two.

A = [1, 2, 3, 4; 5, 6, 7, 8; 9, 10, 11, 12; 13, 14, 15, 16];
X = [1, 5, 9, 13; 2, 6, 10, 14; 3, 7, 11, 15; 4, 8, 12, 16];
Y = transpose(A);
is(X, Y, "transpose() on matrix");

Y = A';
is(X, Y, "transpose op ' on matrix");

A = [1, 2, 3, 4; 5, 6, 7, 8; 9, 10, 11, 12; 13, 14, 15, 16; 17, 18, 19, 20];
X = [1, 5, 9, 13, 17; 2, 6, 10, 14, 18; 3, 7, 11, 15, 19; 4, 8, 12, 16, 20];
Y = transpose(A);
is(X, Y, "transpose() on non square matrix");

Y = A';
is(X, Y, "transpose op ' on non square matrix");


A = [ 1+2i 2+3i; 3+4i 4+5i];
X = [ 1+2i 3+4i; 2+3i 4+5i];
Y = transpose(A);
is(X, Y, "transpose() on complex matrix");

Y = A.';
is(X, Y, "transpose op .' on complex matrix");

X = [ 1-2i 3-4i; 2-3i 4-5i];
Y = ctranspose(A);
is(X, Y, "ctranspose() on complex matrix");

Y = A';
is(X, Y, "ctranspose op ' on complex matrix");

