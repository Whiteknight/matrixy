function c = cell(y, x)
% Creates a new cell array.
% If one argument is provided, cell will be NxN square
% If two arguments are provided, cell will be NxM
    if nargin == 1
        x = y;
    end
    c = parrot_new('PMCMatrix2D');
    parrot_method(c, "resize", y, x);
endfunction