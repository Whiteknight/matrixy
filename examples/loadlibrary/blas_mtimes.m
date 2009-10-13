function y = blas_mtimes(A, B, type)
%% blas_mtimes(A, B, type)
%% This function returns the matrix product of A times B
%% and is equivalent to A * B.
%% If type = "Complex" then uses the BLAS zgemn.
%%
%% It is implemented using blas and might be used as a fast alternative.

    M = rows(A);
    N = columns(B);
    K = columns(A);
    C = zeros(M, N);
    alpha = 1;
    beta = 0;
    lda = N;
    ldb = K;
    ldc = M;
    
    if type == "Complex"
        ret = calllib('CBLAS', 'f2c_zgemm', 'N', 'N', M, N, K, alpha, A, lda, B, ldb, beta, C, ldc );
    else
        ret = calllib('CBLAS', 'f2c_dgemm', 'N', 'N', M, N, K, alpha, A, lda, B, ldb, beta, C, ldc );
    end

    return C;

endfunction
