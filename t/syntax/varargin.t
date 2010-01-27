plan(5);

function v = getvarargs(varargin)
    v = varargin;
endfunction

x = getvarargs(7, 8, 9);
is(parrot_typeof(x), "PMCMatrix2D", "varargin is a PMCMatrix2D");
ok(iscell(x), "varargin is a cell array");
is(x{1}, 7, "varargin(1)");
is(x{2}, 8, "varargin(2)");
is(x{3}, 9, "varargin(3)");
