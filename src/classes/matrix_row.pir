.namespace ['matrix_row']

.sub '__matrix_row_onload' :load :init :anon
    $P0 = newclass 'matrix_row'
    addattribute $P0, "has_string"
    addattribute $P0, "has_number"
    addattribute $P0, "row"
    addattribute $P0, "row_length"
    addattribute $P0, "has_complex"
.end

.sub 'init' :vtable
    $P0 = new ['ResizablePMCArray']
    setattribute self, "row", $P0
    $P0 = box 0
    setattribute self, "has_string", $P0
    $P0 = box 0
    setattribute self, "has_number", $P0
    $P0 = box 0
    setattribute self, "row_length", $P0
    $P0 = box 0
    setattribute self, "has_complex", $P0
.end

.sub 'get_iter' :vtable
    $P0 = getattribute self, "row"
    $P1 = iter $P0
    .return($P1)
.end

.sub 'get_integer' :vtable
    $P0 = getattribute self, "row"
    $I0 = $P0
    .return($I0)
.end

.sub 'get_number_keyed_int' :vtable
    .param int idx
    $P0 = getattribute self, "row"
    $N0 = $P0[idx]
    .return($N0)
.end

.sub 'get_pmc_keyed_int' :vtable
    .param int idx
    $P0 = getattribute self, "row"
    $P1 = $P0[idx]
    .return($P1)
.end


.sub 'has_string' :method
    .param int has_string :optional
    .param int has_has_string :opt_flag

    if has_has_string goto set_has_string
    $P0 = getattribute self, "has_string"
    $I0 = $P0
    .return($I0)

  set_has_string:
    $P0 = box has_string
    setattribute self, "has_string", $P0
    .return(has_string)
.end

.sub 'has_number' :method
    .param int has_number :optional
    .param int has_has_number :opt_flag

    if has_has_number goto set_has_number
    $P0 = getattribute self, "has_number"
    $I0 = $P0
    .return($I0)

  set_has_number:
    $P0 = box has_number
    setattribute self, "has_number", $P0
    .return(has_number)
.end

.sub 'has_complex' :method
    .param int has_complex :optional
    .param int has_has_complex :opt_flag

    if has_has_complex goto set_has_complex
    $P0 = getattribute self, "has_complex"
    $I0 = $P0
    .return($I0)

  set_has_complex:
    $P0 = box has_complex
    setattribute self, "has_complex", $P0
    .return(has_complex)
.end


.sub 'row_length' :method
    $P0 = getattribute self, "row_length"
    $I0 = $P0
    .return($I0)
.end

.sub 'build_row_args' :method
    .param pmc args :slurpy
    self.'build_row'(args)
.end

.sub 'build_row' :method
    .param pmc args
    .local pmc myiter
    .local pmc arg
    .local pmc has_string
    .local pmc has_number
    .local pmc has_complex
    .local int row_length
    row_length = 0
    has_string = getattribute self, "has_string"
    has_number = getattribute self, "has_number"
    has_complex = getattribute self, "has_complex"
    myiter = iter args
  loop_top:
    unless myiter goto loop_bottom
    arg = shift myiter
    $S0 = typeof arg
    if $S0 == "Integer" goto has_arg_number
    if $S0 == "Float" goto has_arg_number
    if $S0 == "String" goto has_arg_string
    if $S0 == "Complex" goto has_arg_complex
    # TODO: What here?
    goto loop_top
  has_arg_number:
    has_number = 1
    inc row_length
    goto loop_top
  has_arg_string:
    has_string = 1
    $S0 = arg
    $I0 = length $S0
    row_length = row_length + $I0
    goto loop_top
  has_arg_complex:
    say "building row, has complex"
    has_number = 1
    has_complex = 1
    inc row_length
    goto loop_top

  loop_bottom:
    setattribute self, "row", args
    $P0 = box row_length
    setattribute self, "row_length",$P0
.end

.sub 'contains_numbers' :method
    .local pmc has_number
    has_number = getattribute self, "has_number"
    $I0 = has_number
    .return($I0)
.end

.sub 'contains_strings' :method
    .local pmc has_string
    has_string = getattribute self, "has_string"
    $I0 = has_string
    .return($I0)
.end

.sub 'get_array' :method
    $P0 = getattribute self, "row"
    .return($P0)
.end
