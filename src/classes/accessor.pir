
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
#
.sub 'get_result' :method
    .param int nargout
    .local pmc primary
    primary = getattribute self, "primary_value"

    .local pmc indexer
    indexer = getattribute self, "indexer"

    .local pmc args
    args = indexer.'get_arglist'()

    .local pmc result
    result = new ["results"]
    result.set_nargout(nargout)

    $I0 = does primary, "matrix"
    if $I0 == 1 goto have_matrix
    $S0 = typeof primary
    if $S0 == "Sub" goto have_sub

    $P0 = new ["Exception"]
    $P0["message"] = "Unknown primary type"
    throw $P0

  have_matrix:
    # TODO: index into the matrix
    # TODO: the indexer may contain a range, in which case the lookup will
    #       be a slice. Figure out how to handle that.
    .return(result)

  have_sub:
    # TODO: set the number of expected output parameters somehow
    # TODO: set the number of input parameters somehow. We should be able
    #       to pull that number out of the callsig in the callee
    ($P0 :slurpy) = primary(args :flat)
    result.add_values($P0 :flat)
    .return(result)
.end

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
