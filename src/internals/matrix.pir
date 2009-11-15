
=head1 ABOUT

This file implements some basic routines for working with multidimensional
matrix objects. These are, at least at first, nested ResizablePMCArray objects.

=head2 Caveats

At the moment, only covers matrices with a dimension of 1 or 2. No 3-D matrices.

=head1 INTERNAL FUNCTIONS

=over 4

=cut

=item !get_first_string(PMC x)

Returns a string from the argument. If x is a String PMC, return that. If it
is an array or matrix PMC, return the first element as a string. Otherwise,
throw an error that no strings are found.

=cut

.sub '!get_first_string'
    .param pmc x
    $S0 = typeof x
    if $S0 == 'String' goto arg_string
    if $S0 == 'CharMatrix2D' goto arg_matrix
    'error'("Expected string argument not found")

  arg_string:
    $S0 = x
    .return($S0)
  arg_matrix:
    $S0 = x[0]
    .return($S0)
.end

=item !get_matrix_dimensions

Return the number of dimensions of the matrix. Probably 1 or 2

=cut

.sub '!get_matrix_dimensions'
    .param pmc m
    $S0 = typeof m
    if $S0 == 'NumMatrix2D' goto _its_a_matrix
    .return(1)
  _its_a_matrix:
    #NumMatrix2D is always 2D. Other types will be other things
    .return(2)
.end

=item !get_matrix_sizes

Return the sizes of the matrix along each dimension, in an RIA.

=cut

.sub '!get_matrix_sizes'
    .param pmc m

    $P0 = new 'ResizableIntegerArray'
    $S0 = typeof m
    if $S0 == 'NumMatrix2D' goto _its_a_matrix
    .return($P0)

  _its_a_matrix:
    $P1 = getattribute m, "X"
    $P2 = getattribute m, "Y"
    $P0[0] = $P1
    $P0[1] = $P2
    .return($P0)
.end

=item !build_matrix()

Construct a matrix from a list of elements

=cut

.sub '!build_matrix'
    .param int x
    .param int y
    .param pmc fields :slurpy
    $P0 = new ['NumMatrix2D']
    $P0.'initialize_from_array'(x, y, fields)
    .return($P0)
.end

=item !add_cols_zero_pad

Adds n columns to the end of a matrix

=cut

.sub '!add_cols_zero_pad'
    .param pmc matrix
    .param int cols
    $P0 = getattribute matrix, "X"
    $I0 = $P0
    $I0 = $I0 + cols
    $P0 = getattribute matrix, "Y"
    $I1 = $P0
    matrix.'resize'($I0, $I1)
.end

=item !add_rows_zero_pad

Adds n rows to the bottom of a matrix

=cut

.sub '!add_rows_zero_pad'
    .param pmc matrix
    .param int rows
    $P0 = getattribute matrix, "X"
    $I0 = $P0
    $P0 = getattribute matrix, "Y"
    $I1 = $P0
    $I1 = $I1 + rows
    matrix.'resize'($I0, $I1)
.end

=item !array_col_force_strings(PMC m)

Force all rows in matrix m to become String PMCs

=cut

.sub '!array_col_force_strings'
    .param pmc m
    .local pmc myiter
    .local pmc newarray
    newarray = new 'ResizablePMCArray'

    $S0 = typeof m
    if $S0 == 'NumMatrix2D' goto _its_a_matrix

    # Not a matrix, some other aggregate
    myiter = iter m
  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $S0 = typeof $P0
    if $S0 == 'String' goto push_string_pmc
    $S0 = $P0
    $P0 = box $S0
  push_string_pmc:
    push newarray, $P0
    goto loop_top
  loop_bottom:
    .return(newarray)

    #it's a matrix
  _its_a_matrix:
    .local int x_size
    .local int y_size
    $P0 = getattribute m, "Y"
    x_size = $P0
    $I0 = x_size
    $P0 = getattribute m, "X"
    y_size = $P0
    y_size = y_size - 1
  matrix_loop_top:
    $I0 = $I0 - 1
    if $I0 == -1 goto matrix_loop_bottom
    $P0 = m.'get_block'(0, $I0, x_size, 1)
    $S0 = $P0
    $P1 = box $S0
    newarray[$I0] = $P1
    goto matrix_loop_top
  matrix_loop_bottom:
    .return(newarray)
.end

=item !range_constructor_two

Construct an array from a range of the form a:b

=item !range_constructor_three

Construct an array from a range of the form a:b:c

=cut

.sub '!range_constructor_two'
    .param pmc start
    .param pmc stop
    $N0 = start
    $N1 = stop
    if $N0 < $N1 goto positive_range
    if $N0 > $N1 goto negative_range
    .return(start)
  positive_range:
    .tailcall '!range_constructor_three'(start, 1, stop)
  negative_range:
    .tailcall '!range_constructor_three'(start, -1, stop)
.end

.sub '!range_constructor_three'
    .param pmc start
    .param pmc step
    .param pmc stop
    $N0 = start
    $N1 = step
    $N2 = stop
    if $N0 < $N2 goto expect_positive_step
    if $N0 > $N2 goto expect_negative_step
    .return(start)
  expect_positive_step:
    if $N1 <= 0 goto bad_step
    .tailcall '!range_constructor_positive'(start, step, stop)
  expect_negative_step:
    if $N1 >= 0 goto bad_step
    .tailcall '!range_constructor_negative'(start, step, stop)
  bad_step:
    _error_all("Step parameter is incorrect")
.end

# Actually construct the array. We know a few things right now: start and
# stop are not equal. Start, stop, and step are all properly aligned so that
# we won't loop infinitely looking for a value that we can't get.
.sub '!range_constructor_positive'
    .param pmc start
    .param pmc step
    .param pmc stop
    .local pmc newarray
    newarray = new 'ResizablePMCArray'
    $N0 = start
    $N1 = step
    $N2 = stop
  loop_top:
    push newarray, $N0
    $N0 = $N0 + $N1
    if $N0 > $N2 goto loop_end
    goto loop_top
  loop_end:
    $I0 = elements newarray
    $P0 = new ['NumMatrix2D']
    $P0.'initialize_from_array'($I0, 1, newarray)
    .return($P0)
.end

.sub '!range_constructor_negative'
    .param pmc start
    .param pmc step
    .param pmc stop
    .local pmc newarray
    newarray = new 'ResizablePMCArray'
    $N0 = start
    $N1 = step
    $N2 = stop
  loop_top:
    push newarray, $N0
    $N0 = $N0 + $N1
    if $N0 < $N2 goto loop_end
    goto loop_top
  loop_end:
    $I0 = elements newarray
    $P0 = new ['NumMatrix2D']
    $P0.'initialize_from_array'($I0, 1, newarray)
    .return($P0)
.end

=item !distribute_matrix_op(PMC a, PMC b, PMC op)

Distributes operator op over each element of the two arrays a and b. Returns
a matrix that is the same size as a and b. This is used to implement most
normal operators. op can be either the String name of the operation, or a Sub
PMC.

Can only dispatch over an internal function, not a builtin or a library routine.

=cut

.sub '!distribute_matrix_op'
    .param pmc a
    .param pmc b
    .param pmc op

    # Check that we have operands of the same size.
    $P0 = '!get_matrix_sizes'(a)
    $P1 = '!get_matrix_sizes'(b)
    if $P0 != $P1 goto bad_operand_sizes

    .local pmc sub
    $S0 = typeof op

    # If it's a sub, we're done. If it's a string, look it up. Otherwise, error
    if $S0 == "Sub" goto has_sub
    unless $S0 == 'String' goto bad_op_type
    $S0 = op
    sub = find_name $S0

    # If the result is undefined, error. If it's not a Sub, error
    $I0 = defined sub
    unless $I0 goto bad_op_name
    $S0 = typeof sub
    unless $S0 == 'Sub' goto bad_op_type
    op = sub

    # At this point, op should contain a Sub PMC.
  has_sub:
    .tailcall '!distribute_binary_operation'(a, b, op)
  bad_operand_sizes:
    _error_all("operands a and b are different sizes")
  bad_op_name:
    _error_all("Can't find sub named ", op)
  bad_op_type:
    _error_all("Unknown op type: ", $S0)
.end

.sub '!distribute_binary_operation'
    .param pmc a
    .param pmc b
    .param pmc sub
    .const "Sub" handler = '!distribute_op_handler'
    $P0 = a.'iterate_function_external'(handler, b, sub)
    .return($P0)
.end

.sub '!distribute_op_handler'
    .param pmc matrix_a
    .param num value_a
    .param int x
    .param int y
    .param pmc matrix_b
    .param pmc op
    .local num value_b
    .local num result

    value_b = matrix_b[x;y]
    result = op(value_a, value_b)
    .return(result)
.end

=item !get_for_loop_iteration_array

Get an object suitable for use with an iterative "for" loop.
Matrix types are not iterable. Take the items from the first row of the
matrix and put them into an array for iteration.

=cut

.sub '!get_for_loop_iteration_array'
    .param pmc m
    $S0 = typeof m
    if $S0 == 'NumMatrix2D' goto have_matrix
    .return(m)
  have_matrix:
    .local pmc array
    $P0 = getattribute m, "X"
    $I0 = $P0
    $P1 = m.'get_block'(0, 0, $I0, 1)
    array = new ['ResizablePMCArray']
  loop_top:
    dec $I0
    $N0 = $P1[$I0]
    array[$I0] = $N0
    if $I0 > 0 goto loop_top
    .return(array)
.end

=back

=cut

