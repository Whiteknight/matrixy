
.namespace["indexer"]

.sub '__indexer_row_onload' :load :init :anon
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