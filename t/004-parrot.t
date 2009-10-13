disp("1..6");

% Test the pir() function
pir(".sub _tempa\nsay 'ok 1'\n.end")
pir(".sub _tempb\n.param string a\nsay a\n.end", "ok 2")

% Test parrot_typeof(), and verify that various data items are the things
% we think they are
if parrot_typeof(1) == "Integer"
    disp("ok 3");
else
    disp("not ok 3");
end

if parrot_typeof(1.2) == "Float"
    disp("ok 4")
else
    disp("not ok 4")
end

if parrot_typeof("hello") == "String"
    disp("ok 5")
else
    disp("not ok 5")
end

if parrot_typeof([1 2]) == "ResizablePMCArray"
    disp("ok 6")
else
    disp("not ok 6")
end