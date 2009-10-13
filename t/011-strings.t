plan(14);

% Basic sanity test. We've probably done this elsewhere, but do it here again
disp(["ok 1"])

% Strings in the same row of a matrix are concatinated
disp(["ok " "2"])

% matrices with strings convert numbers to their ASCII character equivalents
disp(["ok ", 51])

% an array of strings, multiple rows
disp(["ok 4";"ok 5"])

% combine: multiple rows and automatic ASCII conversion
disp(["ok ", 54; "ok ", 55])

% in a multi-row matrix, if any rows are strings, all rows are strings
disp(["ok 8"; 111, 107, 32, 57])
disp([111, 107, 32, 49, 48; "ok 11"])

% fractional parts are always rounded down to become integers, then converted
% to ASCII
disp(["ok ", 49.2, 50.7])

% expressions (with whitespace) inside a string matrix
disp(["ok ", 48 + 1, 48 + 3])

% printf with the %s placeholder
printf("ok %s\n", "14");
