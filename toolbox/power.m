function power(A,B)
%% power(A, B)
%% This function returns the matrix arraywise exponentiation of A and B.
%% Equivalent to A^B

    return arrayfun(@(x,y) x^y, A,B)

endfunction
