plan(1);

ok(1, "loadlibrary not ready for testing");

% TODO: Can't test loadlibrary till we have try/catch

%signatures = [ "[]" ];
%x = loadlibrary('nonexistent', signatures, 'FOOBAR');
%is(x, 0, "nonexistent library")

%x = libisloaded('FOOBAR');
%is(x, 0, "nonexistent library not loaded")

% TODO: Test a successful library load. Try libparrot or linalg_group

