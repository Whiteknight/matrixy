plan(5);

x1 = 1;
x2 = [ 1 ];
x3 = [ 1 1 ];
x4 = [ 1; 1];
x5 = ones(2,3);

ok(isscalar(x1), "isscalar");

ok(isscalar(x2), "isscalar 2");

is(isscalar(x3), 0, "row vector is not scalar");

is(isscalar(x4), 0, "col vector is not scalar");

is(isscalar(x5), 0, "matrix is not scalar");
