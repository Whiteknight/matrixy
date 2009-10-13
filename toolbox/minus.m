function minus(A,B)
%% minus(A, B)
%% This function returns the matrix difference of A times B.
%% Equivalent to A-B

    return arrayfun(@(x,y) x-y, A,B)

endfunction
