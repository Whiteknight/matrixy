=item isequal(A, B, C, ...)


=cut

.namespace ['_Matrixy';'builtins']

.sub 'isequal'
    .param int nargout
    .param int nargin
    .param pmc X
    .param pmc Y
    .param pmc O :slurpy

    .local pmc matrix_list
    matrix_list = new 'ResizablePMCArray'
    push matrix_list, X
    push matrix_list, Y
    matrix_list.'append'(O)

    start_compare:

        .local int n, m, count
        count = matrix_list

        .local pmc A, B
        .local int Ar, Ac, Br, Bc
        .local int i, j

        n = -1
        check_pair:
            n = n + 1
            m = n + 1
            unless m < count goto success
            A = matrix_list[n]
            B = matrix_list[m]

            Ar = 'rows'(1,1,A)
            Ac = 'columns'(1,1,A)
            Br = 'rows'(1,1,B)
            Bc = 'columns'(1,1,B)

            if Ar != Br goto failure
            if Ac != Bc goto failure

            i = -1
            next_i:
                i = i + 1
                unless i < Ar goto check_pair
                j = -1
                next_j:
                    j = j + 1
                    unless j < Ac goto next_i
                    $P0 = A[i;j]
                    $P1 = B[i;j]
                    $N0 = $P0
                    $N1 = $P1
                    if $N0 != $N1 goto failure
                    goto next_j

  success:
    .return(1)

  failure:
    .return(0)

.end
