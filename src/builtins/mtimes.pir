=item mtimes(A, B)

This function returns the matrix product of A times B
and is equivalent to A * B.

=cut

.namespace ["_Matrixy";"builtins"]

.sub 'mtimes'
    .param int nargout
    .param int nargin
    .param pmc A
    .param pmc B

    $S0 = typeof A
    $S1 = typeof B
    $I1 = $S0 == 'ResizablePMCArray'
    $I2 = $S1 == 'ResizablePMCArray'
    $I3 = and $I1, $I2
    if $I3 goto process_array
    $P0 = '!lookup_function'('times')
    $P1 = $P0(1,1,A,B)
    .return ($P1)

    process_array:
    .local int A_rows, A_cols
    $P0 = '!get_matrix_sizes'(A)
    A_rows = $P0[0]
    A_cols = $P0[1]
    
    .local int B_rows, B_cols
    $P0 = '!get_matrix_sizes'(B)
    B_rows = $P0[0]
    B_cols = $P0[1]

    .local pmc C
    C = new 'ResizablePMCArray'

    .local int i, j, n
    i = -1
    next_i:
        i = i + 1
        unless i < A_rows goto return_array
        $P0 = new 'ResizablePMCArray'
        push C, $P0
        j = -1
        next_j:
            j = j + 1
            unless j < B_cols goto next_i
            n = -1
            # we do it this way to support any Field, i.e. Real, Complex, etc..
            null $P1
            next_n:
                n = n + 1
                unless n < A_cols goto end_n
                $P2 = A[i;n] 
                $P3 = B[n;j]
                $P4 = $P2 * $P3
                if_null $P1 , init_sum
                $P1 += $P4
                goto next_n
                init_sum:
                    $P1 = $P4
                    goto next_n
            end_n:
            
            C[i;j] = $P1
            goto next_j

  return_array:
    .return (C)

.end


