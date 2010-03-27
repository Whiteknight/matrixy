
.namespace["accessor"]

.sub '__accessor_row_onload' :load :init :anon
    $P0 = newclass 'matrix_row'
    addattribute $P0, "primary_name"
    addattribute $P0, "primary_value"
    addattribute $P0, "indexer"
.end

.sub 'init' :vtable
    $P0 = null
    setattribute self, "primary_value", $P0
    setattribute self, "indexer", $P0
    $P0 = box "ans"
    setattribute self, "primary_name", $P0
.end

# When the accessor is an LVALUE, this returns the number of expected result
# arguments from the RVALUE accessor object. For a function call of the form:
#   foo = bar()
# this number represents the nargout of the function call.
.sub 'get_nargs' :method
    $P0 = getattribute self, "primary_value"
    $S0 = typeof $P0
    if $S0 == "matrix_literal" goto have_literal
    if $S0 == "cell_literal" goto have_literal
    $I0 = 1
    .return ($I0)
  have_literal:
    .tailcall $P0.get_nargs()
.end

# Called only when this accessor is an RVALUE. Use the indexer to get the
# requested value from the primary. Essentially performs the operation:
#   result = primary(indexer)
.sub 'get_result' :method
    .param int nargout
    .local pmc primary
    primary = getattribute self, "primary_value"

    .local pmc indexer
    indexer = getattribute self, "indexer"

    # TODO: We don't handle structure fields yet, though that will happen here
    #       as well
    # TODO: We don't handle slices yet.
    .local int indexer_type
    indexer_type = indexer.'get_type'()

    .local pmc args
    args = indexer.'get_arglist'()

    .local int nargin
    nargin = elements args

    .local pmc result
    result = new ["results"]
    result.set_nargout(nargout)

    .local string primary_type
    primary_type = typeof primary

    # Determine which type of primary we have.
    # TODO: Function handles. If primary is a sub we execute it, so we're going
    #       to need to invent a wrapper type for sub handles.
    $I0 = does primary, "matrix"
    if $I0 == 1 goto have_matrix
    if primary_type == "Sub" goto have_sub

    # Fall through. Don't know what type it is, so error.
    self."_error"("Unknown primary type: ", primary_type)

  have_matrix:
    if indexer_type > 2 goto indexer_not_supported
    if indexer_type == 0 goto indexer_non_indexing
    if primary_type == 'PMCMatrix2D' goto have_cell_array
    if indexer_type == 1 goto index_as_matrix

    self."_error"("Cannot index matrix with {}")

  have_cell_array:
    if indexer_type == 1 goto index_as_cell
  index_as_matrix:
    .tailcall self.'_index_as_matrix'(primary, args, nargs)
  index_cell_as_cell:
    # TODO: Do this right!
    $P0 = '!scalar_indexing'(var, args)
    $P1 = new ['PMCMatrix2D']
    $P1[0;0] = $P0
    .return($P1)

  indexer_not_supported:
    self."_error"("Indexer type ", indexer_type, " not supported on ", primary_type)

  have_sub:
    # TODO: set the number of expected output parameters somehow
    # TODO: set the number of input parameters somehow. We should be able
    #       to pull that number out of the callsig in the callee
    ($P0 :slurpy) = primary(args :flat)
    result.add_values($P0 :flat)
    .return(result)
.end

# Treats the primary as a matrix and looks up an element in it.
.sub '_index_as_matrix' :method
    .param pmc primary
    .param pmc args
    .param int nargs

    if nargs == 0 goto indexer_non_indexing
    if nargs == 1 goto vector_indexing
    if nargs == 2 goto matrix_indexing

    self."_error"("Only 0, 1, 2, indices are currently supported")

  indexer_non_indexing:
    .return(primary)
  vector_indexing:
    $I1 = args[0]
    # Make sure it's 0-indexed
    dec $I1
    $P0 = primary[$I1]
    .return($P0)
  matrix_indexing:
    $I0 = args[0]
    dec $I0
    $I1 = args[1]
    dec $I1
    $P0 = primary[$I0;$I1]
    .return($P0)
.end

# When the accessor is an LVALUE, assigns the result to the contained primary.
# Performs this operation:
#   primary(indexer) = result
.sub 'assign_result' :method
    .param pmc result

    .local int nargout
    nargout = result.'get_nargout'()

    .local pmc vals
    vals = result.'get_values'()

    # TODO: if the primary is a matrix literal, we need to assign into it. Maybe
    #       the matrix_literal class will have a method to make that happen.
    #       If primary is an indexed lookup, we can do the keying here directly.


.end

# Sets the primary for this accessor. Takes a name and a value. If the value
# is not provided, it means a variable of that name does not currently exist.
# We can look up the value as a sub, or we can create the value.
# TODO: We should probably not do the sub lookup here, because things can become
#       ambiguous. We should always look up the primary elsewhere before
#       setting it here.
.sub 'set_primary' :method
    .param string name
    .param pmc value

    $P0 = box name
    setattribute self, "primary_name", value

    if null value goto not_a_var
    setattribute self, "primary_value", value
    .return()

    # if it's not a pre-existing variable, see if we have a function
  not_a_var:
    value = self.'_lookup_function'(name)
    if null value goto error_var_undefined
    setattribute self, "primary_value", value
    .return()

  error_var_undefined:
    self."_error"("'", name, "' undefined")
.end

=item !lookup_function(name)

Searches for a function of the given name. The function could be a builtin
PIR function or a function written in M. Returns a Sub PMC object if one is
found, null otherwise.

=cut

.sub '_lookup_function' :method
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
    filehandle = self.'_find_file_in_path'(name)
    $I0 = defined filehandle
    if $I0 goto _dispatch_found_file
    goto _dispatch_not_found

  _dispatch_found_file:
    sub_obj = self.'_get_sub_from_code_file'(filehandle, name)
    close filehandle
    $I0 = defined sub_obj
    if $I0 goto _dispatch_found_sub

  _dispatch_not_found:
    $P0 = null
    .return($P0)

  _dispatch_found_sub:
    .return(sub_obj)
.end

.sub '_find_file_in_path' :method
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

# TODO: Script files take no arguments. An error message should be thrown if
#       we try to pass arguments to one. Should we handle that here, or let
#       Parrot's PCC system deal with it?
.sub '_get_sub_from_code_file' :method
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

.sub '_error'
    .param pmc args :slurpy
    .local pmc myiter
    .local string msg
    myiter = iter args
    msg = "Accessor: "
  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $S0 = $P0
    msg = concat msg, $S0
    goto loop_top
  loop_bottom:
    # TODO: Can we attach a backtrace to the message here?
    $P0 = new ["Exception"]
    $P0["message"] = msg
    throw $P0
.end
