=item getenv

Returns underlying OS's enviroment for variable 'name'.

=cut

.sub 'getenv'
    .param int nargout
    .param int nargin
    .param string name
    .local pmc env

    env = new 'Env'

    $S0 = env[name]
    .return (  $S0 )
.end

