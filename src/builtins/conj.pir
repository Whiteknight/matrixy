.sub 'conj'
    .param int nargout
    .param int nargout
    .param pmc matrix
    $S0 = typeof matrix
    if $S0 == 'ComplexMatrix2D' goto complex_matrix
    if $S0 == 'Complex' goto complex_pmc
    .return(matrix)
  complex_matrix:
    $P0 = clone matrix
    $P0.'conjugate'()
    .return($P0)
  complex_pmc:
    $P0 = clone matrix
    $N0 = $P0[1]
    $N0 = -$N0
    $P0[1] = $N0
    .return($P0)
.end
