plan(9);

% Tests for expression handling and the default variable "ans"
"ok first!";
is(ans, "ok first!", "ans gets the value of a string literal");

1 + 1;
is(ans, 2, "ans gets the most simple result");

(2 + 1) * 1;
is(ans, 3, "ans gets the correct arithmetic result");

5 / 2;
is(ans, 2.5, "ans gets the value of a simple expression");

pi * 2;
is(ans, (pi() * 2), "ans gets the value of a compound expression");

% Test the use of ellipses for breaking a single statement over multiple lines
foo = ...
  "is ok";
is(foo, "is ok", "Ellipses breaks assignment");
is( ...
    foo, ...
"is ok", "Ellipses break function arguments");

# these are a few common idioms that don't work right now and
# should be fixed.

# this works
# x = -10
# but this doesn't
# x = +10
start_todo("prefix:+ does not work");
ok(0, "prefix:+ is a valid modifier");
end_todo();

# array constructs with minus signs break
A = [1 -1 ; 2 -2];
B = [1, -1; 2, -2];
start_todo("prefix:- doesn't work inside matrices");
is(A, B, "Minus signs in matrices break them");
end_todo();

