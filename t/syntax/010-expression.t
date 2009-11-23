plan(7);

% Tests for expression handling and the default variable "ans"
"ok 1";
disp(ans);

1 + 1;
if ans == 2
    printf("ok %d\n", ans);
else
    disp("not ok 2");
end

(2 + 1) * 1;
if ans == 3
    disp("ok 3");
else
    disp("not ok 3");
end

5 / 2;
if ans == 2.5
    disp("ok 4");
else
    disp("not ok 4");
end

pi * 2;
if ans == (pi() * 2)
    disp("ok 5");
else
    disp("not ok 5");
end

% Test the use of ellipses for breaking a single statement over multiple lines
foo = ...
  "ok 6";
disp(foo);
disp( ...
    "ok 7" ...
);
