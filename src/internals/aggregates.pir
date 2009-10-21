
.namespace []

.sub '!hash'
.param pmc fields :slurpy :named
.return (fields)
.end

.sub '_new_empty_array'
$P0 = new 'ResizablePMCArray'
.return($P0)
.end
