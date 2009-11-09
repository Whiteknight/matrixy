
.namespace []

.sub '!hash'
    .param pmc fields :slurpy :named
    .return (fields)
.end

.sub '!array'
    .param pmc ary :slurpy
    .return(ary)
.end

.sub '!matrix'
    .param int x
    .param int y
    .param pmc ary :slurpy
    $P0 = new ['NumMatrix2D']
    $P0.'initialize_from_array'(x, y, ary)
    .return($P0)
.end

# used in the parser
.sub '_new_empty_array'
    $P0 = new ['ResizablePMCArray']
    .return($P0)
.end

