
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

  foo = bar(1, 2)

bar could be either a matrix or a subroutine. Handles all the idiosyncratic
rules for these kinds of things in M.

=cut

.sub '!dispatch'
    .param string name
    .param pmc var
    .param int nargout
    .param int nargin
    .param int parens
    .param pmc args :slurpy
    .local pmc sub_obj
    .local pmc var_obj

    # if we have a variable value, dispatch that
    if null var goto not_a_var
    .tailcall '!index_variable'(var, nargout, nargin, parens, args)

    # if it's not a variable, treat it like a sub and look that up.
  not_a_var:
    sub_obj = '!lookup_function'(name)
    unless null sub_obj goto found_sub
    _error_all("'", name, "' undefined")

  found_sub:
    .tailcall sub_obj(nargout, nargin, args :flat)
.end

=item !lookup_function(name)

Searches for a function of the given name. The function could be a builtin
PIR function or a function written in M. Returns a Sub PMC object if one is
found, null otherwise.

=cut

.sub '!lookup_function'
    .param string name
    .local pmc sub_obj
    .local pmc var_obj

    # First, look for a builtin function.
    sub_obj = get_hll_global ["_Matrixy";"builtins"], name
    $I0 = defined sub_obj
    if $I0 goto _dispatch_found_sub

    # Second, look for a locally-defined function
    sub_obj = get_hll_global ["Matrixy::functions"], name
    $I0 = defined sub_obj
    if $I0 goto _dispatch_found_sub

    # Third, look for a list of already-loaded external functions
    # TODO: This might not be necessary, since we are loading subs into their
    #       own namespace now
    .local pmc func_list
    func_list = get_hll_global ['Matrixy';'Grammar';'Actions'], '%?FUNCTIONS'
    sub_obj = func_list[name]
    $I0 = defined sub_obj
    if $I0 goto _dispatch_found_sub

    # Fourth, search for the file "name".m in the /lib
    .local pmc filehandle
    filehandle = '!find_file_in_path'(name)
    $I0 = defined filehandle
    if $I0 goto _dispatch_found_file
    goto _dispatch_not_found

  _dispatch_found_file:
    sub_obj = '!get_sub_from_code_file'(filehandle, name)
    close filehandle
    $I0 = defined sub_obj
    if $I0 goto _dispatch_found_sub

  _dispatch_not_found:
    $P0 = null
    .return($P0)

  _dispatch_found_sub:
    .return(sub_obj)
.end

=item !index_variable(var, nargout, nargin, parens)

Handles equations of the following types:

  a = var(b, ...)

Returns the value

=cut

.sub '!index_variable'
    .param pmc var
    .param int nargout
    .param int nargin
    .param int parens
    .param pmc args

    $S0 = typeof var

    # If it's a function handle variable, dispatch it.
    unless $S0 == 'Sub' goto its_a_variable
    if parens == 1 goto execute_sub_handle
    .return(var)
  execute_sub_handle:
    .tailcall var(nargout, nargin, args :flat)

    # If it's an ordinary variable, do the indexing
  its_a_variable:

    # If we only have a 1-ary index, we need to use a separate vector indexing
    # algorithm instead of the nested matrix indexing.
    $I0 = args
    unless $I0 == 1 goto matrix_indexing
    $I1 = args[0]
    dec $I1 # Make sure it's 0-indexed
    .tailcall '!index_vector'(var, $I1)

  matrix_indexing:
    .local pmc myiter
    myiter = iter args
    $P1 = var
  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $I0 = $P0
    dec $I0   # M Matrices are 1-based, not 0-based like Parrot arrays
    if $I0 < 0 goto negative_index_attempt
    $P2 = $P1[$I0]
    $P1 = $P2
    goto loop_top
  loop_bottom:
    .return($P1)
  negative_index_attempt:
    _error_all("invalid index")
.end

=item !index_vector(var, idx)

Handles simple vector indexing of the form:

  a = var(b)

Here, var could be either a 2D matrix or a 1D vector

=cut

.sub '!index_vector'
    .param pmc var
    .param int idx
    .local int rows
    .local int cols

    $P0 = '!get_matrix_sizes'(var)
    rows = $P0[0]
    cols = $P0[1]
    if cols == 1 goto column_vector
    if rows == 1 goto row_vector

    # here, it's a matrix that's being indexed like a vector
    .local int row
    .local int col
    row = idx % rows
    col = idx / rows
    $P1 = var[row]
    $P2 = $P1[col]
    .return($P2)

  column_vector:
    $P1 = var[idx]
    $P2 = $P1[0]
    .return($P2)

  row_vector:
    $P1 = var[0]
    $P2 = $P1[idx]
    .return($P2)
.end

=item !is_scalar

Returns 1 if the variable is a scalar type, 0 if it's a vector or matrix

TODO: This is probably redundant and unneccessary. Remove this if not needed.

=cut

.sub '!is_scalar'
    .param pmc var
    $S0 = typeof var
    if $S0 == 'ResizablePMCArray' goto is_not_scalar
    .return(1)
  is_not_scalar:
    .return(0)
.end

=item !indexed_assign

Handles equations of the types:

 var(a, b) = c
 var(a) = c
 var() = c
 var = c

Determines where to assign the value, and does the assignment as necssarry.
Returns the modified variable.

=cut

.sub '!indexed_assign'
    .param pmc var
    .param pmc value
    .param pmc indices :slurpy

    unless null var goto no_autovivify
    $P0 = '!array_row'(0)
    var = '!array_col'($P0)

  no_autovivify:
    $I0 = indices
    if $I0 == 0 goto assign_scalar

    # If we have a scalar, autopromote it to a matrix
    # TODO: do a more robust check here for matrix-ness
    $I1 = '!is_scalar'(var)
    if $I1 == 0 goto not_scalar
    $P0 = '!array_row'(var)
    var = '!array_col'($P0)

  not_scalar:
    if $I0 == 1 goto assign_vector
    if $I0 == 2 goto assign_matrix
    # TODO: Eventually we are going to need to support 3D matrices and higher
    _error_all("Number of indices is too great, only 2D matrices are supported")
  assign_scalar:
    .return(value)
  assign_vector:
    $P0 = indices[0]
    $I1 = $P0
    .tailcall '!indexed_assign_vector'(var, value, $I1)
  assign_matrix:
    $P0 = indices[0]
    $P1 = indices[1]
    $I1 = $P0
    $I2 = $P1
    .tailcall '!indexed_assign_matrix'(var, value, $I1, $I2)
.end

=item '!indexed_assign_vector'

Handles equations of the type:

 var(a) = c

Where var could be either a vector or a 2D matrix.

=cut

.sub '!indexed_assign_vector'
    .param pmc var
    .param pmc value
    .param int idx
    .local int rows
    .local int cols
    .local int row
    .local int col
    rows = var
    $P0 = var[0]
    cols = $P0
    if rows == 1 goto row_vector
    if cols == 1 goto col_vector

    # Here, it's a matrix that we're indexing like a vector.
    # Get the matrix coordinates.
    dec idx
    row = idx % rows
    col = idx / rows
    inc row
    inc col
    if row > rows goto cant_extend
    if col > cols goto cant_extend
    .tailcall '!indexed_assign_matrix'(var, value, row, col)

  row_vector:
    .tailcall '!indexed_assign_matrix'(var, value, 1, idx)

  col_vector:
    .tailcall '!indexed_assign_matrix'(var, value, idx, 1)

  cant_extend:
    # We can't extend a matrix using vector-indexing. Throw an error here
    _error_all("Cannot autoextend a matrix using vector indexing")
.end

=item '!indexed_assign_matrix'

Handles equations of the form:

 var(a, b) = c

Where var is any 2D matrix

=cut

.sub '!indexed_assign_matrix'
    .param pmc var
    .param pmc value
    .param int idrow
    .param int idcol

    $P0 = var[0]
    $I0 = var
    $I1 = $P0

    if idrow <= $I0 goto row_size_ok
    $I2 = idrow - $I0
    var = '!add_rows_zero_pad'(var, $I2)
  row_size_ok:
    if idcol <= $I1 goto col_size_ok
    $I2 = idcol - $I1
    var = '!add_cols_zero_pad'(var, $I2)
  col_size_ok:
    dec idrow
    dec idcol
    $I0 = var
    $P0 = var[0]
    $I1 = $P0
    var[idrow;idcol] = value
    .return(var)
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

# TODO: Script files take no arguments. An error message should be thrown if
#       we try to pass arguments to one. Should we handle that here, or let
#       Parrot's PCC system deal with it?
.sub '!get_sub_from_code_file'
    .param pmc filehandle
    .param string name
    .local pmc code
    .local pmc func_list
    .local pmc sub_obj
    code = filehandle.'readall'()
    $P0 = compreg "matrixy"
    $P1 = $P0.'compile'(code)

    # Get the number of subs in the codefile, and try to determine whether it's
    # a script or a function file.
    $I0 = elements $P1 # Need Parrot r37779 for this to work.
    if $I0 == 1 goto script_file

    # Here, we just assume it's a function-file. Take the first function.
    # Other functions are private to that file and are ignored
    sub_obj = $P1[1]
    $S0 = sub_obj
    if $S0 == name goto has_sub_obj
    _disp_all("Warning: function name '", $S0, "' does not agree with file name ", name, ".m")
    goto has_sub_obj

  script_file:
    sub_obj = $P1[0]

  has_sub_obj:
    func_list = get_hll_global ['Matrixy';'Grammar';'Actions'], '%?FUNCTIONS'
    func_list[name] = sub_obj
    .return(sub_obj)
.end


.namespace []

