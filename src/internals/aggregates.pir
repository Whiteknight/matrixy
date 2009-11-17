
.namespace []

.sub '!hash'
    .param pmc fields :slurpy :named
    .return (fields)
.end

.sub '!array'
    .param pmc ary :slurpy
    .return(ary)
.end

.sub '!matrix_row'
    .param pmc args :slurpy
    $P0 = new ['matrix_row']
    $P0.'build_row'(args)
    $I0 = $P0.'row_length'()
    say $I0
    .return($P0)
.end

.sub '!_get_rows_info'
    .param pmc ary

    # Setup local variables
    .local pmc thisrow
    .local pmc lengths
    .local int numbers
    .local int strings
    .local int complex
    lengths = new ['FixedIntegerArray']
    $I0 = ary
    lengths = $I0
    .local int idx
    idx = 0
    numbers = 0
    complex = 0
    strings = 0
    .local pmc myiter
    myiter = iter ary

    # loop over each row, gather information
  loop_top:
    unless myiter goto loop_bottom
    thisrow = shift myiter
    $I0 = thisrow.'has_number'()
    numbers = or numbers, $I0
    $I0 = thisrow.'has_string'()
    strings = or strings, $I0
    $I0 = thisrow.'has_complex'()
    complex = or complex, $I0
    $I0 = thisrow.'row_length'()
    lengths[idx] = $I0
    inc idx
    goto loop_top
  loop_bottom:
    .return(lengths, numbers, strings, complex)
.end

.sub '!_verify_array_lengths_equal'
    .param pmc lengths
    .local pmc myiter
    myiter = iter lengths
    $I0 = shift myiter
  loop_top:
    unless myiter goto loop_bottom
    $I1 = shift myiter
    if $I0 == $I1 goto loop_top
    _error_all("Row lengths must be equal ", $I0, " != ", $I1)
  loop_bottom:
.end

.sub '!_build_numerical_matrix'
    .param pmc rows
    .local pmc matrix
    .local int x
    .local int y
    .local int width
    .local int height
    matrix = new ['NumMatrix2D']
    y = 0
    height = rows
    $P0 = rows[0]
    width = $P0
  outer_loop_top:
    x = 0
    $P0 = rows[y]
  inner_loop_top:
    $N0 = $P0[x]
    matrix[x;y] = $N0
    inc x
    if x < width goto inner_loop_top
    inc y
    if y < height goto outer_loop_top
    .return(matrix)
.end

.sub '!_build_complex_matrix'
    .param pmc rows
    .local pmc matrix
    .local int x
    .local int y
    .local int width
    .local int height
    matrix = new ['NumMatrix2D']
    y = 0
    height = rows
    $P0 = rows[0]
    width = $P0
  outer_loop_top:
    x = 0
    $P0 = rows[y]
  inner_loop_top:
    $P1 = $P0[x]
    matrix[x;y] = $P1
    inc x
    if x < width goto inner_loop_top
    inc y
    if y < height goto outer_loop_top
    .return(matrix)
.end

.sub '!_build_string_matrix'
    .param pmc rows
    .local pmc matrix
    .local int idx
    .local pmc myiter
    matrix = new ['CharMatrix2D']
    idx = 0
    myiter = iter rows
  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $P1 = $P0.'get_array'()
    matrix.'initialize_from_mixed_array'(idx, $P1)
    inc idx
    goto loop_top
  loop_bottom:
    .return(matrix)
.end

.sub '!matrix_from_rows'
    .param pmc ary :slurpy
    .local pmc lengths
    .local int has_numbers
    .local int has_strings
    .local int has_complex

    # If there are no rows, just return an empty matrix
    $I0 = ary
    unless $I0 == 0 goto construct_the_matrix
    $P0 = new ['NumMatrix2D']
    .return($P0)

  construct_the_matrix:
    (lengths, has_numbers, has_strings, has_complex) = '!_get_rows_info'(ary)
    unless has_numbers goto dont_check_length
    '!_verify_array_lengths_equal'(lengths)

  dont_check_length:
    if has_complex goto build_complex_matrix
    if has_strings goto build_string_matrix
    .tailcall '!_build_numerical_matrix'(ary)
  build_string_matrix:
    .tailcall '!_build_string_matrix'(ary)
  build_complex_matrix:
    if has_strings goto cant_have_both
    .tailcall '!_build_complex_matrix'(ary)
  cant_have_both:
    _error_all("Cannot have both complex and string values in one matrix")
.end

.sub '!matrix'
    .param int x
    .param int y
    .param pmc args :slurpy
    $P0 = new ['NumMatrix2D']
    $P0.'initialize_from_array'(x, y, args)
    .return($P0)
.end

# used in the parser
.sub '_new_empty_array'
    $P0 = new ['ResizablePMCArray']
    .return($P0)
.end

