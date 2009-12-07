plan(2)

function n = countargs(varargin)
    n = nargin;
endfunction

is(countargs(), 0, "nargin with no args");
is(countargs(1, 2, 3), 3, "nargin with three args");