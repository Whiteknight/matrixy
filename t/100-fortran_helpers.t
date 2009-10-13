plan(8);

A = [1, 2, 3, 4; 5, 6, 7, 8];
ret = _test_fortran_array_conversions(A);
ok(ret, "fortran array conversion");

A = [1, 2, 3, 4; 5, 6, 7, 8; 9, 10, 11, 12; 13, 14, 15, 16];
ret = _test_fortran_array_conversions(A);
ok(ret, "passing float array");

A = zeros(10,3);
ret = _test_fortran_array_conversions(A);
ok(ret, "passing 10 x 3 zeros");

A = eye(10);
ret = _test_fortran_array_conversions(A);
ok(ret, "passing large idenity");

A = [1, 2, 3, 4; 5, 6, 7, 8; 9, 10, 11, 12; 13, 14, 15, 16];
ret = _test_fortran_array_conversions(A, 'Integer');
ok(ret, "passing int array");

A = 20;
ret = _test_fortran_array_conversions(A, 'Integer');
ok(ret, "passing scalar integer");

A = 20.5;
ret = _test_fortran_array_conversions(A, 'Float');
ok(ret, "passing scalar float");

A = [ 1+2i 2+3i; 4+5i 5+6i]
ret = _test_fortran_array_conversions(A, 'Complex');
ok(ret, "passing complex array");
