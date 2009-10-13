=item transpose(A)

This function returns the transpose of A and is equivalent to A.'

=cut

.namespace ["_Matrixy";"builtins"]

.sub 'transpose'
    .param int nargout
    .param int nargin
    .param pmc A

    $S0 = typeof A
    if $S0 == 'ResizablePMCArray' goto process_array
    .return (A)

    process_array:
    .local int rows, cols
    $P0 = '!get_matrix_sizes'(A)
    rows = $P0[0]
    cols = $P0[1]

    .local pmc B
    B = new 'ResizablePMCArray'

    .local int i, j
    j = -1
    next_j:
        j = j + 1
        unless j < cols goto return_array
        $P0 = new 'ResizablePMCArray'
        push B, $P0
        i = -1
        next_i:
            i = i + 1
            unless i < rows goto next_j
            $P0 = A[i;j]
            B[j;i] = $P0
            goto next_i

  return_array:
    .return (B)

.end


