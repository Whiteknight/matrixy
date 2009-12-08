plan(19);

% Test indexing into vectors


a = [1 2 3 4];
is(a(1), 1);
is(a(2), 2);
is(a(3), 3);
is(a(4), 4);

b = [1;2;3;4];
is(b(1), 1);
is(b(2), 2);
is(b(3), 3);
is(b(4), 4);

% Relational operator tests
a = [1 2 3];
b = [1 2 3];
c = [4 5 6];
is(a, b, "equal row vectors are equal");

if a == c
    ok(0, "inequal vectors are apparently equal");
else
    ok(1, "equal column vectors are equal");
end

if a != b
    ok(0, "equal vectors are apparently inequal");
else
    ok(1, "equal vectors are not inequal");
end

if a != c
    ok(1, "inequal vectors are inequal");
else
    ok(0, "inequal vectors aren't inequal");
end

% Test the use of whitespace in specifying column vectors:
foo = [1
       2
       3];
bar = [1;2;3];
is(foo, bar, "matrix rows using different syntax");

% Test that we can assign to a row vector cell
y = [1 2 3];
y(3) = 4;
is(y, [1 2 4], "vector assign to row vector cell");

% Test that we can assign to a column vector cell
y = [1;2;3];
y(3) = 4;
is(y, [1;2;4], "vecor assign to col vector cell");

% Test that assigning to a row vector causes autoextending
y = [1 2 3];
y(5) = 5;
is(y, [1 2 3 0 5], "autoextend row vector");

% Test that assigning to a column vector causes autoextending
y = [1;2;3];
y(5) = 5;
is(y, [1;2;3;0;5], "autoextend col vector");

% Test that a 1x1 matrix autoextends like a row vector
y = [1];
y(3) = 3;
is(y, [1 0 3], "autoextend scalar into row vector");

% Test that row vectors autovivify when we assign to an index of them
_not_existing_vector(3) = 3;
is(_not_existing_vector, [0 0 3], "autovivify row vector");

