=item computer()

Retrieves computer information.

Standard forms:
    platform = computer()
    arch = computer('arch')

Parrot-only forms:
    parrotos = computer('parrotos')
    parrotpc = computer('parrotpc')

=cut

# TODO: Need to handle [str, maxsize] = computer form
# TODO: Need to handle [str, maxsize, endian] = computer form
.sub 'computer'
    .param int nargout
    .param int nargin
    .param string arch :optional
    .param int has_arch :opt_flag

    .local string os
    .local string proc
    os = sysinfo 4
    proc = sysinfo 7

    if has_arch goto maybe_show_arch_string
    if os == 'MSWin32' goto show_windows_string
    if os == 'linux' goto show_linux_string
    $S0 = "Unknown"
    .return($S0)

  show_windows_string:
    if proc == "i386" goto show_windows32_string
    $S0 = "PCWIN64"
    .return($S0)
  show_windows32_string:
    $S0 = "PCWIN"
    .return($S0)

  show_linux_string:
    if proc == "i386" goto show_linux32_string
    $S0 = "GLNXA64"
    .return($S0)
  show_linux32_string:
    $S0 = "GLNX86"
    .return($S0)

  maybe_show_arch_string:
    if arch == 'arch' goto show_arch_string
    if arch == 'parrotos' goto show_parrotos_string
    if arch == 'parrotpc' goto show_parrotpc_string
    $S0 = 'Unknown'
    .return($S0)

  show_arch_string:
    if os == 'MSWin32' goto show_windows_arch_string
    if os == 'linux' goto show_linux_arch_string
    $S0 = "Unknown"
    .return($S0)

  show_windows_arch_string:
    if proc == "i386" goto show_windows32_arch_string
    $S0 = "win64"
    .return($S0)
  show_windows32_arch_string:
    $S0 = "win32"
    .return($S0)

  show_linux_arch_string:
    if proc == "i386" goto show_linux32_arch_string
    $S0 = "glnxa64"
    .return($S0)
  show_linux32_arch_string:
    $S0 = "glnx32"
    .return($S0)

  show_parrotos_string:
    .return(os)
  show_parrotpc_string:
    .return(proc)
.end


