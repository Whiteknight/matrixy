function y = blas_transpose(A, type)
%% blas_transpose(A, type)
%% This function returns the transpose of A and is equivalent to A.'
%% If type = "Complex" then uses the BLAS zgemn.
%%
%% It is implemented using blas and might be used as a fast alternative.

    M = columns(A);
    N = rows(A);
    K = rows(A);
    B = eye(K);
    C = zeros(M, N);
    alpha = 1;
    beta = 0;
    lda = N;
    ldb = K;
    ldc = M;

    if type == "Complex"
        ret = calllib('CBLAS', 'f2c_zgemm', 'T', 'N', M, N, K, alpha, A, lda, B, ldb, beta, C, ldc );
    else
        ret = calllib('CBLAS', 'f2c_dgemm', 'T', 'N', M, N, K, alpha, A, lda, B, ldb, beta, C, ldc );
    end

    return C;

endfunction
