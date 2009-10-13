plan(6)

% Test inequality of same-sized matrices
A1 = [1,2;3,4];
B1 = [5,6;7,8];
nok(isequal(A1, B1), "isequal() fails on non-same matrices");

% Test equality of same-sized matrices
A2 = [1,2;3,4;5,6];
B2 = [1,2;3,4;5,6];
ok(isequal(A2, B2), "isequal() succeeds with two same matrices");

% Test equality of three matrices, each the same size and shape
A3 = [1,2;3,4;5,6];
B3 = [1,2;3,4;5,6];
C3 = [1,2;3,4;5,6];
ok(isequal(A3, B3, C3), "isequal() succeeds on three same matrices");

% Test inequality of three matrices, each the same size and shape
A4 = [1,2;3,4;5,6];
B4 = [1,2;0,0;5,6];
C4 = [1,2;3,4;5,6];
nok(isequal(A4, B4, C4), "isequal() fails on three non-same matrices");

% Test inequality of three matrices of different sizes
A5 = [1,2;3,4;5,6;7,8];
B5 = [1,2;3,4;5,6];
C5 = [1,2;3,4;5,6];
nok(isequal(A5, B5, C5), "isequal() fails on three matrices of different sizes");

% Test inequality of two matrices of different sizes
A6 = [1,2;5,6;7,8];
B6 = [1,2;5,6];
nok(isequal(A6, B6), "isequal() fails on two matrices of different sizes");
