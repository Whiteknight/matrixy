=item computer()

Retrieves computer information.

i.e.

i386-MSWin32
i386-linux
amd64-linux

TODO: eventually also include subsystem, ie. cygwin, gnu, mingw, msvc

=cut


.sub 'computer'
    .param int nargout
    .param int nargin

    $P0 = new 'ResizablePMCArray'

    $S4 = sysinfo 4
    $S7 = sysinfo 7
    push $P0, $S7
    push $P0, $S4

    $S0 = sprintf "%s-%s" , $P0
    .return ($S0)
.end


