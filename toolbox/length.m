function l = length(x)
%% l = length(x)
%% returns the length of x if x is a vector. This is the number of columns
%% for a row vector, or the number of rows for a column vector. If x is a
%% non-vector matrix, returns the number of columns.
    r = columns(x);
    if r == 1
        l = rows(x);
    else
        l = r;
    end
endfunction