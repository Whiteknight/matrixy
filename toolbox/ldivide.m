function ldivide(A,B)
%% ldivide(A, B)
%% This function returns the matrix arraywise left division of A and B.
%% Equivalent to A.\B

    return arrayfun(@(x,y) y/x, A,B)

endfunction
