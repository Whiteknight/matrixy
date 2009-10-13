function plus(A,B)
%% plus(A, B)
%% This function returns the matrix sum of A times B.
%% Equivalent to A+B

    return arrayfun(@(x,y) x+y, A,B)

endfunction
