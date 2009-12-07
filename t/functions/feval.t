plan(6);

% feval with a builtin function
feval('ok', 1);
feval('ok', 1, "second test");
feval('feval', 'ok', 1, "third test");
feval(['ok'], 1);

% Show that we can still feval a function if we've overridden it with a variable
% of the same name
ok = [10, 11, 12];
is(ismatrix(ok), 1, "is really overshadowed");
feval('ok', 1);
