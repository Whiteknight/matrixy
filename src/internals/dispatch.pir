
.namespace []

=head1 Function/Variable dispatch routines

The routines in this file deal with dispatching function calls or variable
lookups. This issue is complicated slightly by the fact that that both
subroutines and variables use the same syntax for dispatching and array lookup.
Given the code C<x(5)>, if x is a variable it performs an array lookup.
Otherwise, attempts to dispatch to the subroutine x with the argument list
C<(5)>.

=head1 Functions

=over 4

=item !dispatch(name, var, nargout, nargin, parens, args :slurpy)

retrieve a value using the following syntax:

  bar
  bar ...
  bar(...)
  bar{...}

These are r-values only, not l-value assignment forms. bar could be
a matrix, a cell array, a func handle, or a subroutine call. We will take
the name of the variable and it's current value. Some rules:

1) functions are stored in the Matrixy::builtins namespace and "var" will
   be null here. Look up the function in the namespace and dispatch it
2) matrices and cells will have non-null values here. They must be vivified
   somewhere else.



=cut


=item !index_variable(var, nargout, nargin, parens)

Handles equations of the following types:

  a = var(b, ...)

Returns the value. Matrices can be indexed with foo(...) style, which returns
the scalar item at that position. Cells can be indexed with foo{...} to return
the item, or with foo(...) to return another cell containing those items.

 foo                parens == 0
 foo(...)           parens == 1
 foo{...}           parens == 2

=cut

=item !indexed_assign

Handles equations of the types:

 var(a, b) = c
 var(a) = c
 var() = c
 var = c

Determines where to assign the value, and does the assignment as necssarry.
Returns the modified variable.

=cut

# TODO: What is the difference between foo() and foo{}, besides the later
#       not working for non-cells? At the moment we do basic type checking and
#       Then redirect to normal indexed assignment.
# TODO: We can refactor these two assignment functions to both call a common
#       indexing kernel, I think
.sub '!indexed_assign_cell'
    .param pmc var
    .param pmc value
    .param pmc indices :slurpy

    if null var goto autovivify_cell
    $S0 = typeof var
    if $S0 != "PMCMatrix2D" goto error_not_a_cell
    .tailcall '!indexed_assign'(var, value, indices :flat)

  autovivify_cell:
    var = new ['PMCMatrix2D']
    .tailcall '!indexed_assign'(var, value, indices :flat)

  error_not_a_cell:
    _error_all("Cannot use {} indexing on a ", $S0)
.end

.sub '!indexed_assign'
    .param pmc var
    .param pmc value
    .param int idx
    .param int array_assign
    .param pmc indices :slurpy

    # If array_assign == 1, value is a regular scalar value. Otherwise, it's an
    # aggregate and idx is the index of the value
    if array_assign == 0 goto have_final_value
    if null value goto have_final_value
    value = value[idx]
  have_final_value:

    $I0 = elements indices
    if $I0 == 0 goto assign_scalar

    unless null var goto var_exists
    var = new ['NumMatrix2D']
  var_exists:

    $I1 = '!is_scalar'(var)
    if $I1 == 0 goto already_a_matrix
    var = '!matrix'(1, 1, var)
  already_a_matrix:
    if $I0 == 1 goto assign_vector
    if $I0 == 2 goto assign_matrix
    # TODO: Eventually we are going to need to support 3D matrices and higher
    _error_all("Number of indices is too great, only 2D matrices are supported")
  assign_scalar:
    .return(value)
  assign_vector:
    $I0 = indices[0]
    .tailcall '!vector_assign'(var, value, $I0)
  assign_matrix:
    $I1 = indices[0] # row
    $I2 = indices[1] # column
    dec $I1
    dec $I2
    var[$I1;$I2] = value
    .return(var)
.end

.sub '!vector_assign'
    .param pmc var
    .param pmc value
    .param int idx
    .local int x
    .local int y

    # NumMatrix2D doesn't currently bounds check on linear indexing.
    # So, we'll do that here for now. Octave's behavior for cases where we
    # try to linearly index beyond the bounds of the matrix is as follows:
    # 1) If var doesn't exist, create a new Nx1 row vector
    # 2) if var does exist and is a vector, extend it logically
    # 3) if var does exist and is a matrix, throw an error because we can't choose
    #    how to extend it.
    $P2 = getattribute var, "cols"
    x = $P2
    $P2 = getattribute var, "rows"
    y = $P2

    # Case (1)
    if x == 0 goto autovivify_row_vector

    # Case (2)
    if y == 1 goto is_row_vector
    if x == 1 goto is_column_vector

    # Case (3)
    $I2 = x * y
    if idx > $I2 goto autovivify_error

    # If vector exists and doesn't need to be resized just assign it
    var[idx] = value
    .return(var)

  autovivify_row_vector:
    var.'resize'(1, idx)
  is_row_vector:
    dec idx
    var[0;idx] = value
    .return(var)
  is_column_vector:
    dec idx
    var[idx;0] = value
    .return(var)
  autovivify_error:
    _error("Cannot auto-extend an existing matrix through linear indexing")
.end

=item !find_file_in_path(String name)

Finds a file named "name.m" in the path. Returns a FileHandle PMC for the file
if found, null otherwise.

=cut

.sub '!find_file_in_path'
    .param string name
    .local string filename
    .local pmc path
    .local pmc myiter
    .local pmc filehandle
    path = get_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH"

    filename = name . ".m"
    myiter = iter path
    $P0 = shift myiter  # get rid of "."
    push_eh _find_no_file
    filehandle = open filename, "r"
    goto _find_found_file

  _loop_top:
    unless myiter goto _loop_not_found
    $P0 = shift myiter
    $S0 = $P0
    $S0 .= filename

    push_eh _find_no_file
    filehandle = open $S0, "r"
    goto _find_found_file

  _find_no_file:
    pop_eh
    goto _loop_top

  _loop_not_found:
    $P0 = null
    .return($P0)

  _find_found_file:
    .return(filehandle)
.end

=item !get_sub_from_code_file

Given a FileHandle of a code file, compile it and return the appropriate Sub
PMC for that file. Notice that the file could be a script file or a function
file.

=cut

.namespace []

