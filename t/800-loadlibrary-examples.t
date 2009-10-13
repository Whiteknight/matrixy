plan(4)

import_cblas_library
addpath("examples/loadlibrary/");

A = [ 1 2; 4 5];
B = blas_transpose(A, 'Real');
is(A.', B, "check real blas transpose")

A = [ 1+2i 2+3i; 4+5i 5+6i];
B = blas_transpose(A, 'Complex');
is(A.', B, "check complex blas transpose")

A = [ 1 2 3; 4 5 6];
B = [ 2 3 ; 5 7 ; 11 13];
C = blas_mtimes(A, B, 'Real');
is(A*B, C, "real blas matrix product")

A = [ 1+2i 2+3i 3+4i; 4+5i 5+6i 6+7i];
B = [ 2-i 3-2i ; 5-4i 7-6i ; 11-10i 13-12i];
C = blas_mtimes(A, B, 'Complex');
is(A*B, C, "complex blas matrix product")