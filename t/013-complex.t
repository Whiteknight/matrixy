plan(24);

% sanity checks

1 + i;
ok(1, "1+i");

1.0 + i;
ok(1, "1.0+i");

2.0 + 10j;
ok(1, "2.0+10i");

20 + 5.5i;
ok(1, "20+5.5i");

31.5 - 20.7j;
ok(1, "20-20.7");

is(parrot_typeof(1 + 2i), "Complex", "check type with i is complex")
is(parrot_typeof(1 + 2j), "Complex", "check type with i is complex")

is(1 + 2i + 4 , 5+2i, "check add real part")

is(1+2i , 1+2i, "check identical")

is(1 + 2i + 4 +3j , 5+5i, "complex + complex")


is((1+2j)*(2+3j) , -4+7i, "check product")

is(sprintf("%s", 1+2i) , "1+2i", "sprintf 1")

is(sprintf("%s", 20+5.5i) , "20+5.5i", "sprintf 2")

nok(1+2i  == 10, "check nothing crazy happens")

# i, j should behave like ordinary variables. although they default to sqrt(-1).
# see http://ccrma.stanford.edu/~jos/st/Complex_Numbers_Matlab_Octave.html

is(i , 0+1i, "i defaults to i")

is(j , 0+1j, "j defaults to j")

i = 100;
is(i , 100, "can overide i")

j = 101;
is(j , 101, "can override j")

# conj

is(conj(10+20i), 10-20i, "complex conj 1")
is(conj(1-2i), 1+2i, "complex conj 2")
is(conj(10), 10, "complex conj of non complex")
is(conj(5i), -5i, "complex conj imaginary")
is(conj(0), 0, "complex conj of 0")

A = [ 1+2i 2-3i; 10 0];
B = [ 1-2i 2+3i; 10 0];
is(conj(A), B, "array conj");
