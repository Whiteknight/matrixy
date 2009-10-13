=item setenv

Sets underlying OS's enviroment for variable 'name' with value 'value'.

=cut

.sub 'setenv'
    .param int nargout
    .param int nargin
    .param string name
    .param string value :optional
    .param int has_value :opt_flag

    .local pmc env

    if has_value goto setenv
    value = ''

  setenv:
    env = new 'Env'
    env[name] = value

.end