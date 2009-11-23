plan(2);

% Test the pir() function
pir(".sub _tempa\nsay 'ok 1'\n.end")
pir(".sub _tempb\n.param string a\nsay a\n.end", "ok 2")


