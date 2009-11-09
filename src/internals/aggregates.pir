
.namespace []

.sub '!hash'
    .param pmc fields :slurpy :named
    .return (fields)
.end

.sub '!array'
    .param pmc ary :slurpy
    .return(ary)
.end

# used in the parser
.sub '_new_empty_array'
    $P0 = new ['ResizablePMCArray']
    .return($P0)
.end

