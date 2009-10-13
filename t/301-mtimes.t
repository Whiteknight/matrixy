plan(3)


A = [1,2;3,4];
B = [5,6;7,8];
C = [19,22;43,50];
is(mtimes(A, B), C, "product 2 square matrices");

A = [1,2;3,4;5,6];
B = [7,8,9;10,11,12];
C = [27,30,33;61,68,75;95,106,117];
is(mtimes(A, B), C, "product 2 non square matrices")

A = [ 1+2i 2+3i ; 4+5i 6+7i; 8+9i 9+1i ];
B = [ 1+2i 2+3i 3+4i; 5+6i 7+8i 9+1i ];
C = [ -11+31i, -14+44i, 10+39i; -18+84i, -21+119i, 39+100i; 29+84i, 44+121i, 68+77i ];
is(mtimes(A, B), C, "product 2 non square complex matrices")
