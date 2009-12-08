function val = e(rows, cols)
%% val = e()
%% Returns the value of e, Euler's constant, to several decimal places
    % TODO: Should take an arbitrary number of args and return an N-dim matrix
    _e = 2.7182882845904523536;
    if nargin == 0
        val = _e;
    else
        if nargin == 1
            cols = rows;
        end
        val = parrot_new("NumMatrix2D");
        parrot_method(val, "fill", _e, rows, cols);
    end
endfunction