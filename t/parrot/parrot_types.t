pla(7);

% Test parrot_typeof(), and verify that various data items are the things
% we think they are
is(parrot_typeof(1), "Integer", "Integers are Parrot Integers");
is(parrot_typeof(1.2), "Float", "Floats are Parrot Floats");
is(parrot_typeof("hello"), "String", "Strings are Parrot Strings");
is(parrot_typeof([1 2]), "NumMatrix2D", "Matrices are NumMatrix2D");
is(parrot_typeof(1+3i), "Complex", "Complex is Parrot Complex");
is(parrot_typeof([1+3i]), "ComplexMatrix2D", "Complex matrix is ComplexMatrix2D");
is(parrot_typeof({1, "hello"}), "PMCMatrix2D", "Cell is PMCMatrix2D");
