function times(A,B)
%% times(A, B)
%% This function returns the matrix arraywise product of A and B.
%% Equivalent to A.*B

    if isscalar(A)
        return arrayfun(@(y) A*y, B)
    end

    if isscalar(B)
        return arrayfun(@(x) x*B, A)
    end

    return arrayfun(@(x,y) x*y, A,B)

endfunction
