disp("1..7");

% Basic sanity test. These functions are used in all other tests, so make
% sure to exercise them here.
printf("ok 1\n");

disp("ok 2");

% Tests for arguments
printf("ok %s\n", 3);

printf("ok %s\n", 3 + 1);

printf("%s %s\n", "ok", 3 + 2);

% Call without a trailing semicolon
printf("ok 6\n")

disp("ok 7")