.namespace ["_Matrixy";"builtins"]

.sub 'clearscreen'
    .param int nargout
    .param int nargin
    print binary:"\027[2J"
    print binary:"\027[H"
    #print binary:"\e[2J"
    #print binary:"\e[H"
.end

.namespace []




