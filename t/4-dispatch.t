plan(7);

% Dispatch to a function with no args and no returns
% Defined in t/lib/test1.m
addpath('t/lib/')
test1()

% Dispatch to a funtion with 1 arg but no returns
% Defined in t/lib/test2.m
test2("ok 2");

% Dispatch to a function with two args and no returns
% Defined in t/lib/test3.m
test3(1, 2);

% Dispatch to a function with no args but one return value
% Defined in t/lib/test4.m
disp(test4());

% Dispatch to a function in a different folder
% Defined in t/test5.m
addpath("t/")
test5();

% Dispatch to a function file that starts with whitespace (issue from r197)
test6()

% Show that variables overshadow functions of the same name:
disp = [10, 11];

if disp(1) == 10
    printf("ok 7\n");
else
    printf("not ok 7\n");
end

