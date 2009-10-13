plan(4);

x = 1;
for a = 1:2
    is(x, a, "for loop with range");
    x = x + 1;
end

x = 1;
for b = [1 2]
    is(x, b, "for loop with matrix");
    x = x + 1;
end

