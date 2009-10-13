
=head1 ABOUT

This file implements some basic routines for working with multidimensional
matrix objects. These are, at least at first, nested ResizablePMCArray objects.

=head2 Caveats

At the moment, only covers matrices with a dimension of 1 or 2. No 3-D matrices.

=head1 INTERNAL FUNCTIONS

=over 4

=item !get_matrix_string(m)

Gets a string that represents the contents of the variable m.

=cut

.namespace []

.sub '!get_matrix_string'
    .param pmc col
    .local string s
    s = ""
    $S0 = typeof col
    if $S0 == 'ResizablePMCArray' goto _its_a_matrix

    # Here, we don't have a matrix, it's something else. We should probably
    # differentiate between other types, but right now we'll just do things
    # the easy way.
    $S0 = col
    $S1 = $S0
    .return($S1)

    # TODO: This is all a bit of a hack. Clean this all up, and maybe delegate
    #       some of the logic to recursive sub-functions to make all the evil
    #       go away. Plus, this only handles Vectors and 2-D matrices, so that
    #       needs to be generalized.
  _its_a_matrix:
    .local pmc iter_col
    .local pmc iter_row
    #col = '_verify_matrix'(col)
    iter_col = iter col
  _outer_loop_top:
    unless iter_col goto _outer_loop_bottom
    $P0 = shift iter_col

    $S0 = typeof $P0
    if $S0 == 'ResizablePMCArray' goto _its_two_d
    $S0 = $P0
    s .= $S0
    s .= "\n"
    goto _outer_loop_top

  _its_two_d:
    iter_row = iter $P0
  _inner_loop_top:
    unless iter_row goto _inner_loop_bottom
    $P1 = shift iter_row
    $S0 = $P1
    s .= "\t"
    s .= $S0
    goto _inner_loop_top
  _inner_loop_bottom:
    s .= "\n"
    goto _outer_loop_top
  _outer_loop_bottom:
   .return(s)
.end

=item !get_first_string(PMC x)

Returns a string from the argument. If x is a String PMC, return that. If it
is an array or matrix PMC, return the first element as a string. Otherwise,
throw an error that no strings are found.

=cut

.sub '!get_first_string'
    .param pmc x
    $S0 = typeof x
    if $S0 == 'String' goto arg_string
    if $S0 == 'ResizablePMCArray' goto arg_array
    'error'("Expected string argument not found")

  arg_string:
    $S0 = x
    .return($S0)
  arg_array:
    $P0 = x[0]
    .tailcall '!get_first_string'($P0)
.end

=item !get_matrix_dimensions

Return the number of dimensions of the matrix. Probably 1 or 2

=cut

.sub '!get_matrix_dimensions'
    .param pmc m
    $S0 = typeof m
    if $S0 == 'ResizablePMCArray' goto _its_a_matrix
    .return(1)
  _its_a_matrix:
    $P0 = m[0]
    $I0 = '!get_matrix_dimensions'($P0)
    $I0 = $I0 + 1
    .return($I0)
.end

=item !get_matrix_sizes

Return the sizes of the matrix along each dimension, in an RIA.

=cut

.sub '!get_matrix_sizes'
    .param pmc m

    $S0 = typeof m
    if $S0 == 'ResizablePMCArray' goto _its_a_matrix
    $P0 = new 'ResizableIntegerArray'
    .return($P0)

  _its_a_matrix:
    $P0 = m[0]
    $P1 = '!get_matrix_sizes'($P0)
    $I0 = m
    unshift $P1, $I0
    .return($P1)
.end

=item !array_row(PMC fields :slurpy)

Construct an array row from the variadic argument list. If the row contains
any strings, compress the whole thing into a single String PMC. Otherwise,
create a ResizablePMCArray for the row.

=cut

.sub '!array_row'
    .param pmc fields :slurpy
    .local pmc myiter
    myiter = iter fields
  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $S0 = typeof $P0
    unless $S0 == "String" goto loop_top
    .tailcall '!array_compress_strings'(fields)
  loop_bottom:
    .return (fields)
.end

=item !array_col(PMC fields :slurpy)

Create a new array column from a variadic argument list. If any of the rows
are String PMCs, converts all rows in the matrix to string PMCs and returns
the list of them. Otherwise, builds a simple array of the row PMCs.

=cut

.sub '!array_col'
    .param pmc fields :slurpy
    .local pmc myiter
    myiter = iter fields
    unless myiter goto just_exit  # empty array
  loop_top:
    unless myiter goto number_array
    $P0 = shift myiter
    $S0 = typeof $P0
    unless $S0 == "String" goto loop_top

    # fall through. If any row is a string, the whole matrix is treated as
    # an array of strings. each row has to be converted now.
    .tailcall '!array_col_force_strings'(fields)
  number_array:
    myiter = iter fields
    $P0 = shift myiter
    $I0 = '!get_array_row_length'($P0)
  number_loop_top:
    unless myiter goto just_exit
    $P0 = shift myiter
    $I1 = '!get_array_row_length'($P0)
    if $I1 != $I0 goto error_bad_rows
    goto number_loop_top
  error_bad_rows:
    _error_all("number of columns must match (", $I0, " != ", $I1, ")")
  just_exit:
    .return (fields)
.end

=item !get_array_row_length

Returns the row-length of the matrix

=cut

.sub '!get_array_row_length'
    .param pmc x
    $S0 = typeof x
    if $S0 == 'ResizablePMCArray' goto is_array
    .return(1)
  is_array:
    $I0 = x
    .return(x)
.end

=item !add_cols_zero_pad

Adds n columns to the end of a matrix

=cut

.sub '!add_cols_zero_pad'
    .param pmc var
    .param int cols
    .tailcall '!matrix_extend_n_columns'(var, cols)
.end

=item !add_rows_zero_pad

Adds n rows to the bottom of a matrix

=cut

.sub '!add_rows_zero_pad'
    .param pmc var
    .param int rows
    # TODO: We assume here that the var is a proper matrix. Either make sure
    #       that this is tested by the caller, or do the test here.
    $I0 = rows
    $P0 = var[0]
    $I1 = $P0
  loop_top:
    if $I0 == 0 goto loop_bottom
    $P0 = '!row_of_zeros'($I1)
    push var, $P0
    dec $I0
    goto loop_top
  loop_bottom:
    .return(var)
.end

=item !row_of_zeros

Creates a new row of all zeros, of the given length

=cut

# TODO: There has to be a faster way to do this?
.sub '!row_of_zeros'
    .param int n
    .local pmc newrow
    newrow = new 'ResizablePMCArray'
    newrow = n  # Does this work?
    .local int idx
    idx = 0
  loop_top:
    if n == 0 goto loop_end
    newrow[idx] = 0
    inc idx
    dec n
    goto loop_top
  loop_end:
    .return(newrow)
.end

=item !matrix_extend_n_columns

extends a matrix with m columns to have n+m columns, zero padded

=cut

# TODO: There has to be a faster algorithm to do this!
# TODO: Double-check that all the rows are the same length
.sub '!matrix_extend_n_columns'
    .param pmc var
    .param int cols
    $I0 = var
  outer_loop_top:
        if $I0 == 0 goto outer_loop_end
        dec $I0
        $P0 = var[$I0]
        $I1 = $P0
        $I3 = cols
      inner_loop_top:
            if $I3 == 0 goto inner_loop_end
            push $P0, 0
            dec $I3
            goto inner_loop_top
      inner_loop_end:
        goto outer_loop_top
  outer_loop_end:
    .return(var)
.end

=item !array_col_force_strings(PMC m)

Force all rows in matrix m to become String PMCs

=cut

.sub '!array_col_force_strings'
    .param pmc m
    .local pmc myiter
    .local pmc newarray
    newarray = new 'ResizablePMCArray'
    myiter = iter m
  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $S0 = typeof $P0
    if $S0 == 'String' goto push_string_pmc
    $S0 = '!array_compress_strings'($P0)
    $P0 = box $S0
  push_string_pmc:
    push newarray, $P0
    goto loop_top
  loop_bottom:
    .return(newarray)
.end

=item !aray_compress_strings(PMC m)

String array constructor. Strings and numbers cannot really coexist in a
single matrix. If strings are present, all numbers are converted to their
ASCII character representations. All strings or characters in a given row
are concatenated together into a single string. If a Num is passed instead
of an Int, it is rounded down and the integer value is used to look up the
character.

=cut

.sub '!array_compress_strings'
    .param pmc fields
    .local pmc myiter
    .local string s
    myiter = iter fields
    s = ""

    # Iterate over the input array
  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $S0 = typeof $P0

    # If it's a string, add it to the running concatination.
    # Otherwise, get the ASCII character representation and add that
    if $S0 == 'String' goto have_string_pmc
    $I0 = $P0
    $S1 = chr $I0
    s .= $S1
    goto loop_top
  have_string_pmc:
    $S1 = $P0
    s .= $S1
    goto loop_top

  loop_bottom:
    .return(s)
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
    .tailcall '!array_col'(newarray)
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
    .tailcall '!array_col'(newarray)
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
    .tailcall '!distribute_sub_foreach_row'(a, b, op)
  bad_operand_sizes:
    _error_all("operands a and b are different sizes")
  bad_op_name:
    _error_all("Can't find sub named ", op)
  bad_op_type:
    _error_all("Unknown op type: ", $S0)
.end

.sub '!distribute_sub_foreach_row'
    .param pmc a
    .param pmc b
    .param pmc sub
    .local pmc iter_a
    .local pmc iter_b
    .local pmc results
    results = new 'ResizablePMCArray'
    iter_a = iter a
    iter_b = iter b
  loop_top:
    unless iter_a goto loop_bottom
    $P0 = shift iter_a
    $P1 = shift iter_b
    $P2 = '!distribute_sub_foreach_elem'($P0, $P1, sub)
    push results, $P2
    goto loop_top
  loop_bottom:
    .return(results)
.end

.sub '!distribute_sub_foreach_elem'
    .param pmc a
    .param pmc b
    .param pmc sub
    .local pmc iter_a
    .local pmc iter_b
    .local pmc results
    # TODO: Implement this.
.end

=back

=cut

