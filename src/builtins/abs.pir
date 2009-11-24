.namespace ["_Matrixy";"builtins"]

.sub 'abs'
    .param int nargout
    .param int nargin
    .param pmc matrix

    $S0 = typeof matrix
    if $S0 == "Integer" goto its_an_int
    if $S0 == "Float" goto its_a_float
    if $S0 == "Complex" goto its_complex
    if $S0 == "NumMatrix2D" goto its_a_num_matrix
    if $S0 == "ComplexMatrix2D" goto its_a_complex_matrix
    if $S0 == "PMCMatrix2D" goto its_a_pmc_matrix
    .return(matrix)

  its_an_int:
    $I0 = matrix
    $I1 = abs $I0
    $P0 = box $I1
    .return($P0)
  its_a_float:
    $N0 = matrix
    $N1 = abs $N0
    $P0 = box $N1
    .return($P0)
  its_complex:
    $N0 = matrix
    $P0 = box $N0
    .return($P0)
  its_a_num_matrix:
    .const "Sub" num_helper = '!_abs_helper_NumMatrix2D'
    $P0 = clone matrix
    $P0.'iterate_function_inplace'(num_helper)
    .return($P0)
  its_a_complex_matrix:
    .const "Sub" complex_helper = '!_abs_helper_ComplexMatrix2D'
    $P0 = clone matrix
    $P0.'iterate_function_inplace'(complex_helper)
    .return($P0)
  its_a_pmc_matrix:
    .const "Sub" pmc_helper = '!_abs_helper_PMCMatrix2D'
    $P0 = clone matrix
    $P0.'iterate_function_inplace'(pmc_helper)
    .return($P0)
.end

.sub '!_abs_helper_NumMatrix2D'
    .param pmc matrix
    .param num value
    .param int x
    .param int y
    $N0 = abs value
    .return($N0)
.end

.sub '!_abs_helper_ComplexMatrix2D'
    .param pmc matrix
    .param pmc value
    .param int x
    .param int y
    $N0 = value
    .return($N0)
.end

.sub '!_abs_helper_PMCMatrix2D'
    .param pmc matrix
    .param pmc value
    .param int x
    .param int y
    $P0 = 'abs'(1, 1, matrix)
    .return($P0)
.end

