.namespace ['matrix_row']

.sub '__matrix_row_onload' :load :init :anon
    $P0 = newclass 'matrix_row'
    add_attribute $P0, "has_string"
    add_attribute $P0, "has_number"
    add_attribute $P0, "row"
.end

.sub 'init' :vtable
    $P0 = new ['ResizablePMCArray']
    set_attribute self, "row", $P0
    $P0 = box 0
    set_attribute self, "has_string", $P0
    $P0 = box 0
    set_attribute self, "has_number", $P0
.end

.sub 'has_string'
    .param int has_string
    $P0 = box has_string
    set_attribute self, "has_string", $P0
.end

.sub 'has_number'
    .param int has_number
    $P0 = box has_number
    set_attribute self, "has_number", $P0
.end

.sub 'build_row'
    .param pmc args :slurpy
    .local pmc myiter
    .local pmc arg
    .local pmc has_string
    .local pmc has_number
    has_string = get_attribute self, "has_string"
    has_number = get_attribute self, "has_number"
    myiter = iter args
  loop_top:
    unless myiter goto loop_bottom
    arg = shift myiter
    $S0 = typeof arg
    if $S0 == "Integer" goto has_arg_number
    if $S0 == "Float" goto has_arg_number
    if $S0 == "String" goto has_arg_string
    # TODO: What here?
    goto loop_top
  has_arg_number:
    has_number = 1
    goto loop_top
  has_arg_string:
    has_string = 1
    goto loop_top

  loop_bottom:
    set_attribute, self, "row", args
.end

.sub 'get_row'
    $P0 = get_attribute self, "row"
    .return($P0)
.end
