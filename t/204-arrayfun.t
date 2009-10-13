plan(6)

function y = f(x) y=x+1; endfunction
A = [1 2 3; 4 5 6];
B = [2,3,4; 5,6,7];

A1 = arrayfun(@(x)f(x), A);
is(A1, B, "arrayfun() with an anon func handle");

A2 = arrayfun("f", A);
is(A2, B, "arrayfun() with a function name and matrix arg");

A3 = arrayfun("f", 10);
ok(A3 == 11, "arrayfun() with a function name and scalar arg");

A = [1 2; 3 4];
B = [2 2; 2 2];
C = [2 4; 6 8];
D = arrayfun(@(x,y) x*y, A, B);
is(C, D, "arrayfun() on two matrices with an anon func handle");

function y = f1(a,b,c) y = a+b+c; endfunction 

A = [1.1 2.2; 3.3 4.4];
B = [2 2; 2 2];
C = [0.01 0.002; 0.0003 0.0004];
D = [3.11 4.2020; 5.3003 6.4004];
E = arrayfun("f1", A, B, C);
is(D, E, "arrayfun() with three matrices and a named function");

A = 3;
B = 5;
C = 15;
D = 23;
E = arrayfun("f1", A, B, C);
is(D, E, "arrayfun() on three scalars and a named function");

