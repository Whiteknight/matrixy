function y = inverse(A)
%% inverse(A)
%% This function returns the inverse of A.

n = length(A);
IP = zeros(n,1);
info = -1;

calllib('CLAPACK', 'dgetrf_', n,n,A,n,IP,info);

if info != 0
    error("problem occurred during factorizarion!");
end 

info = -1;
lwork = n * 8;
WORK = zeros(lwork, 1);
calllib('CLAPACK', 'dgetri_', n, A, n, IP, WORK, lwork, info);

if info != 0
    error("problem occurred during inversion!");
end 

y = A;

endfunction
