.namespace ["_Matrixy";"index_reference"]

.sub "" :load :init :anon
    $P0 = newclass ["_Matrixy";"index_reference"]
    addattribute $P0, "matrix"
    addattribute $P0, "indices"
.end

.sub 'create_reference' :method
    .param pmc matrix
    .param pmc indices :slurpy
    setattribute self, "matrix", matrix
    setattribute self, "indices", indices
.end

# self = x
.sub 'assign_from' :method
    .param pmc value
    # TODO: add the !indexed_assign logic here
.end

# x = self
.sub 'assign_to' :method
    .param pmc lvalue
    # TODO: add the !dispatch logic here
.end
