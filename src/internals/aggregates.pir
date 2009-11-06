
.namespace []

.sub '!hash'
    .param pmc fields :slurpy :named
    .return (fields)
.end

.sub '!array'
    .param pmc ary :slurpy
    .return(ary)
.end

