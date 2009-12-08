function c = cell(y, x)
% Creates a new cell array.
% If one argument is provided, cell will be NxN square
% If two arguments are provided, cell will be NxM
    if nargin == 1
        x = y;
    end
    c = pir([".sub cell_helper"
             "  .param int y"
             "  .param int x"
             "  $P0 = new ['PMCMatrix2D']"
             "  $P0.'resize'(y, x)"
             "  .return($P0)"
             ".end"], y, x);
endfunction