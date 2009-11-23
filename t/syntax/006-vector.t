disp("1..19");

% Test indexing into vectors
function vector_tester(a, b, c)
    if a == b
        printf("ok %d\n", c);
    else
        printf("not ok %d\n", c);
    end
endfunction

a = [1 2 3 4];
vector_tester(a(1), 1, 1);
vector_tester(a(2), 2, 2);
vector_tester(a(3), 3, 3);
vector_tester(a(4), 4, 4);

b = [1;2;3;4];
vector_tester(b(1), 1, 5);
vector_tester(b(2), 2, 6);
vector_tester(b(3), 3, 7);
vector_tester(b(4), 4, 8);

% Relational operator tests
a = [1 2 3];
b = [1 2 3];
c = [4 5 6];
if a == b
    disp("ok 9");
else
    disp("not ok 9");
end

if a == c
    disp("not ok 10");
else
    disp("ok 10");
end

if a != b
    disp("not ok 11");
else
    disp("ok 11");
end

if a != c
    disp("ok 12");
else
    disp("not ok 12");
end

% Test the use of whitespace in specifying column vectors:
foo = [1
       2
       3];
bar = [1;2;3];
if foo == bar
    disp("ok 13");
else
    disp("not ok 13");
end

% Test that we can assign to a row vector cell
y = [1 2 3];
y(3) = 4;
if y == [1 2 4]
    disp("ok 14");
else
    disp("not ok 14");
endif

% Test that we can assign to a column vector cell
y = [1;2;3];
y(3) = 4;
if y == [1;2;4]
    disp("ok 15");
else
    disp("not ok 15");
endif

% Test that assigning to a row vector causes autoextending
y = [1 2 3];
y(5) = 5;
if y == [1 2 3 0 5]
    disp("ok 16");
else
    disp("not ok 16");
endif

% Test that assigning to a column vector causes autoextending
y = [1;2;3];
y(5) = 5;
if y == [1;2;3;0;5]
    disp("ok 17");
else
    disp("not ok 17");
endif

% Test that a 1x1 matrix autoextends like a row vector
y = [1];
y(3) = 3;
if y == [1 0 3]
    disp("ok 18");
else
    disp("not ok 18");
endif

% Test that row vectors autovivify when we assign to an index of them
_not_existing_vector(3) = 3;
if _not_existing_vector == [0 0 3]
    disp("ok 19");
else
    disp("not ok 19");
endif

