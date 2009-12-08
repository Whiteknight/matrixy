
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

=item !get_for_loop_iteration_array

Get an object suitable for use with an iterative "for" loop.
Matrix types are not iterable. Take the items from the first row of the
matrix and put them into an array for iteration.

=cut

.sub '!get_for_loop_iteration_array'
    .param pmc m
    $I0 = does m, "matrix"
    if $I0 == 1 goto have_matrix
    .return(m)
  have_matrix:
    .local pmc array
    .local int rows
    .local int cols
    .local int idx
    $P0 = getattribute m, "rows"
    rows = $P0
    $P0 = getattribute m, "cols"
    cols = $P0
    array = new ['ResizablePMCArray']
    if rows == 0 goto return_array
    if cols == 0 goto return_array
    idx = 0
    $I0 = 0 # current column number
  col_loop_top:
    $I1 = 0 # current row number
  row_loop_top:
    $P0 = m[$I1;$I0]
    array[idx] = $P0
    inc idx
    inc $I1
    if $I1 < rows goto row_loop_top
    inc $I0
    if $I0 < cols goto col_loop_top
  return_array:
    .return(array)
.end

=back

=cut

