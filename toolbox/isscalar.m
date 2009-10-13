function isscalar(A)
%% isscalar(A)
%% returns 1 if A is 1 x 1 matrix
    if columns(A) == 1 and rows(A) == 1
        return 1
    end
    return 0
endfunction
