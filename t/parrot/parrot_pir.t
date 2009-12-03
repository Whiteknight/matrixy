plan(6);

% Test the pir() function
pir(".sub _tempa\nsay 'ok 1'\n.end")
pir(".sub _tempb\n.param string a\nsay a\n.end", "ok 2")
pir(".sub '' :anon\n.param string a\nsay a\n.end", "ok 3")
pir([".sub '' :anon\n.param string a\nsay a\n.end"], "ok 4")
pir([".sub '' :anon";".param string a";"say a";".end"], "ok 5")
pir([".sub '' :anon"
     ".param string a"
     "say a"
     ".end"],  "ok 6");



