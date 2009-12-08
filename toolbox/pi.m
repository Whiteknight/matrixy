function val = pi(rows, cols)
%% val = pi()
%% returns the value of pi to about 13 decimal places
    % TODO: Should take an arbitrary number of args and return an N-dim matrix
    _p = 3.1415926535898;
    if nargin == 0
        val = _p;
    else
        if nargin == 1
            cols = rows;
        end
        val = parrot_new("NumMatrix2D");
        parrot_method(val, "fill", _p, rows, cols);
    end
endfunction