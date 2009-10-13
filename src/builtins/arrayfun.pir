=item arrayfun(func, A)

Apply a function 'func' to each element of an array 'A'.

=cut

.namespace ["_Matrixy";"builtins"]

.sub 'arrayfun'
    .param int nargout
    .param int nargin
    .param pmc f
    .param pmc A
    .param pmc O :slurpy

    .local pmc matrix_list
    .local int matrix_list_size
    matrix_list = new 'ResizablePMCArray'
    push matrix_list, A
    matrix_list.'append'(O)
    matrix_list_size = matrix_list

    $S0 = typeof f
    if $S0 == 'Sub' goto main
    $S1 = f
    f = '!lookup_function'($S1)

    main:
    .local pmc arg_list
    .local int n
    $S0 = typeof A
    if $S0 == 'ResizablePMCArray' goto process_array

    process_scalar:

    arg_list = new 'ResizablePMCArray'
    n = -1
    next_n_scalar:
        n = n + 1
        unless n < matrix_list_size goto call_fun_scalar
        $P0 = matrix_list[n]
        #$P1 = $P0[i;j]
        $P1 = $P0
        push arg_list, $P1
        goto next_n_scalar

    call_fun_scalar:
    $P0 = f(1,1, arg_list :flat)
    .return ($P0)

    process_array:

    # TODO - should really take the smallest matrix size
    .local int rows, cols
    $P0 = '!get_matrix_sizes'(A)
    rows = $P0[0]
    cols = $P0[1]

    .local int size
    size = rows * cols

    .local pmc B
    B = new 'ResizablePMCArray'

    .local int i, j
    i = -1
    next_i:
        i = i + 1
        unless i < rows goto return_array
        $P0 = new 'ResizablePMCArray'
        $P0 = cols
        push B, $P0
        j = -1
        next_j:
            j = j + 1
            unless j < cols goto next_i

            arg_list = new 'ResizablePMCArray'
            n = -1
            next_n:
                n = n + 1
                unless n < matrix_list_size goto call_fun
                $P0 = matrix_list[n]
                $P1 = $P0[i;j]
                push arg_list, $P1
                goto next_n

            call_fun:
            $P0 = A[i;j]
            $P1 = f(1,1, arg_list :flat)
            B[i;j] = $P1
            goto next_j

  return_array:
    .return (B)

.end


