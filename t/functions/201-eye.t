plan(3);

X1 = eye(1);
Y1 = [1];

% Test that eye(1) does what we think it should
ok(isequal(X1, Y1), "eye(1) does what we want");

% Test that eye(3) does what we think it does
X2 = eye(3);
Y2 = [1,0,0;0,1,0;0,0,1];
ok(isequal(X2, Y2), "eye(3) does what we think it does");

% Test eye(4)
X3 = eye(4);
Y3 = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
ok(isequal(X3, Y3), "eye(4) does what we think it does");
