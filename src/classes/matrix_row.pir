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

.sub 'row_members'
    .param pmc args :slurpy
    set_attribute, self, "row", args
.end
