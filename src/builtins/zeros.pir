=item zeros(n, m)

Create an n x m matrix of zeros.

=cut


.sub 'zeros'
    .param int nargout
    .param int nargin
    .param int rows
    .param int cols

    .local pmc A
    A = new 'ResizablePMCArray'

    .local int i, j, n
    i = -1
    next_i:
        i = i + 1
        unless i < rows goto return_array
        $P0 = new 'ResizablePMCArray'
        $P0 = cols
        push A, $P0
        j = -1
        next_j:
            j = j + 1
            unless j < cols goto next_i
            n = i * cols
            n = n + j
            $N0 = 0
            A[i;j] = $N0
            goto next_j

    return_array:
        .return (A)

.end


