
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

    # if it's not a pre-existing variable, see if we have a function
  not_a_var:
    sub_obj = '!lookup_function'(name)
    if null sub_obj goto error_var_undefined
    .tailcall sub_obj(nargout, nargin, args :flat)
   
  error_var_undefined:
    _error_all("'", name, "' undefined")
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
    # TODO: Fix this to be "Matrixy";"functions" instead
    sub_obj = get_hll_global ["Matrixy";"functions"], name
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

Returns the value. Matrices can be indexed with foo(...) style, which returns
the scalar item at that position. Cells can be indexed with foo{...} to return
the item, or with foo(...) to return another cell containing those items.

 foo                parens == 0
 foo(...)           parens == 1
 foo{...}           parens == 2

=cut

.sub '!index_variable'
    .param pmc var
    .param int nargout
    .param int nargin
    .param int parens
    .param pmc args

    # TODO: We don't handle slices yet.

    # Figure out which type it is, to determine where to go
    $S0 = typeof var
    if $S0 == 'Sub' goto have_func_handle
    if $S0 == 'PMCMatrix2D' goto have_cell_array
    $I0 = does var, "matrix"
    if $I0 == 1 goto have_matrix_type
    $I0 = args
    if $I0 != 0 goto error_index_scalar
    .return(var)

    # For Subs, if we have parens execute it. Otherwise it's an error. If we
    # want a sub reference, need to use the @ operator
  have_func_handle:
    if parens == 0 goto assign_func_handle
    if parens == 2 goto error_func_not_cell
    .tailcall var(nargout, nargin, args :flat)
  assign_func_handle:
    .return(var)

    # For cell arrays the indexing is different depending on which brackets
    # we use.
  have_cell_array:
    if parens == 1 goto index_cell_as_cell
    if parens == 2 goto index_cell_as_matrix
    .return(var)
  index_cell_as_matrix:
    .tailcall '!scalar_indexing'(var, args)
  index_cell_as_cell:
    # TODO: Do this right!
    $P0 = '!scalar_indexing'(var, args)
    $P1 = new ['PMCMatrix2D']
    $P1[0;0] = $P0
    .return($P1)

    # Matrices can be indexed by () but not {}.
  have_matrix_type:
    if parens == 1 goto index_matrix_as_matrix
    if parens == 2 goto error_matrix_not_cell
    .return(var)
  index_matrix_as_matrix:
    .tailcall '!scalar_indexing'(var, args)

  error_index_scalar:
    _error_all("Cannot index a scalar")
  error_func_not_cell:
    _error_all("Cannot index function with {}")
  error_matrix_not_cell:
    _error_all("Cannot index matrix with {}")
.end

.sub '!scalar_indexing'
    .param pmc var
    .param pmc args
    
    # If we only have a 1-ary index, we need to use a separate vector indexing
    # algorithm instead of the nested matrix indexing.
    $I0 = args
    if $I0 == 0 goto non_indexing
    if $I0 == 1 goto vector_indexing
    if $I0 == 2 goto matrix_indexing
    _error_all("Only 0, 1, 2 indexes are currently supported")

  non_indexing:
    .return(var)
  vector_indexing:
    $I1 = args[0]
    # Make sure it's 0-indexed
    dec $I1
    $P0 = var[$I1]
    .return($P0)
  matrix_indexing:
    $I0 = args[0]
    dec $I0
    $I1 = args[1]
    dec $I1
    $P0 = var[$I0;$I1]
    .return($P0)
.end

=item !is_scalar

Returns 1 if the variable is a scalar type, 0 if it's a vector or matrix

TODO: This is probably redundant and unneccessary. Remove this if not needed.

=cut

.sub '!is_scalar'
    .param pmc var
    $I0 = does var, "matrix"
    $I1 = not $I0
    .return($I1)
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
    .param pmc indices :slurpy

    # TODO: Handle block assignments for matrices.

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

.sub '!unpack_return_array'
    .param pmc args
    .return(args :flat)
.end


.namespace []

