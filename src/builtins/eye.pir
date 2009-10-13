=item eye(n)

Creates an identity matrix of dimension n.

=cut

.namespace ["_Matrixy";"builtins"]
.sub 'eye'
    .param int nargout
    .param int nargin
    .param int dim

    .local pmc A
    A = new 'ResizablePMCArray'

    .local int i, j, n
    i = -1
    next_i:
        i = i + 1
        unless i < dim goto return_array
        $P0 = new 'ResizablePMCArray'
        $P0 = dim
        push A, $P0
        j = -1
        next_j:
            j = j + 1
            unless j < dim goto next_i
            n = i * dim
            n = n + j
            if i == j goto set_as_one
            $N0 = 0
            goto set_element
            set_as_one:
                $N0 = 1
            set_element:
                A[i;j] = $N0
            goto next_j

  return_array:
    .return (A)

.end

.namespace []
