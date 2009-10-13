plan(7);

% check default path is '.'
x = path();
if x == '.;toolbox/'
    disp('ok 1');
else
    disp('not ok 1');
end

% add one new path
addpath("t1/");
x = path();
if x == '.;toolbox/;t1/'
    disp('ok 2');
else
    disp('not ok 2');
end

% add multiple paths
addpath("t4/", "t5/", "t6/");
x = path();
if x == '.;toolbox/;t1/;t4/;t5/;t6/'
    disp('ok 3');
else
    disp('not ok 3');
end

% remove a path
rmpath("t6/");
x = path();
if x == '.;toolbox/;t1/;t4/;t5/'
    disp('ok 4');
else
    disp('not ok 4 # TODO right path, wrong order');
end

% remove multiple paths
rmpath("t5/", "t4/");
x = path();
if x == '.;toolbox/;t1/'
    disp('ok 5');
else
    disp('not ok 5 # TODO right path, wrong order');
end

% set path to new path
x = path("one;two;three");
if x == 'one;two;three'
    disp('ok 6');
else
    disp('not ok 6');
end

% reset it
x = path(".");
if x == '.'
    disp('ok 7');
else
    disp('not ok 7');
end
