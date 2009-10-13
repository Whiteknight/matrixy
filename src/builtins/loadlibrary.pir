=item loadlibrary(STRING shared_lib, VECTOR function_signatures)

Loads a shared library into memory with the signatures provided. On success 
returns 1 otherwise on failure returns 0.

NOTE: Matlab's function of same name returns a list of unloaded functions.

Each row of the vector is a flattened JSON string and specifies a function 
to load. The unfolded format of each string is as follows: -

    [
        "symbol name",
        "nci signature",
        {
            "1": {
                "type": "driver short code",
                "out": 1,
                "rows": "M",
                "cols": "N"
            },
            ...
            "n": {
                "type": "driver short code",
                "out": 1,
                "rows": "M",
                "cols": "N"
            }
        }
    ]

Symbol name is the name of function being exported from the shared
library.

NCI signature is a string containing any of the following valid types v, c, 
s, i, l, f, d, P, p, 2, 3, 4, t or U. See Parrot documentation for more
information.

The 3rd array element is a hash table containing optional parameter
driver instructions. 

The "type" keyword can be any compatible compatable driver code. See below.

Driver codes currently include: -

    fadr - Fortran Array Double Real
    fadc - Fortran Array Double Complex
    fai  - Fortran Array Integers

The "out" parameter if present will force the respective paramater to be
passed by reference.

The "rows" and "cols" represent the array row and column counts respectively.
If these are not provided the driver will default to using the parameters 
original dimensions.

TODO: The "row" and "cols" values can include Matrixy functions where p1, p2, ..
represent input parameters to a function.

NOTE: loadlibrary is not compatable with Matlab's function of the same name.
Octave does not support loading libraries dynamically.

=cut

.namespace ["_Matrixy";"builtins"]

.sub 'loadlibrary'
    .param int nargout
    .param int nargin
    .param string libpath
    .param pmc signatures
    .param string alias :optional
    .param int has_alias :opt_flag

    .local pmc lib
    lib = loadlib libpath
    if lib goto loaded_ok

    $P1 = new 'ResizablePMCArray'
    push $P1, libpath

    $S1 = sprintf "library failed to load: ensure path '%s' exists!\n", $P1
    printerr $S1

    .return (0)

  loaded_ok:

    load_bytecode 'compilers/json/JSON.pbc'

    .local pmc JSON, config
    JSON = compreg "JSON"

    .local pmc PIR
    PIR = compreg "PIR"

    .local string libname
    libname = libpath
    unless has_alias goto do_load
    libname = alias

    # TODO param to force reload of library (need named params)
    # do not reload if already loaded
    $P0 = get_hll_global ['_Matrixy';'LoadedLibrary'], libname
    $I0 = defined $P0
    if $I0 goto finish

  do_load:
    set_hll_global ['_Matrixy';'LoadedLibrary'], libname, lib

    .local pmc i1
    i1 = iter signatures
    next_i1:
        unless i1, end_i1
        $S0 = shift i1
        $P0 = JSON($S0)
        $S1 = '!get_sub_code_string'($P0)
        #say $S1
        $P1 = PIR($S1)
        $S2 = $P0[0]
        set_hll_global ['_Matrixy';'LoadedLibraryFunctions';libname], $S2, $P1
        goto next_i1
   end_i1:

   finish:
    .return (1)

.end

.sub '!get_in_driver_code_from_mnemonic'
    .param string index
    .param string type

    .local string dc

    $P1 = new 'ResizablePMCArray'
    push $P1, index

    dc = sprintf ".local pmc q%s\n", $P1

    push $P1, index

    if type == "fadr" goto fadr
    if type == "fadc" goto fadc
    if type == "fai" goto fai

    fadr:
        $S0 = sprintf "q%s = '!matrixy_to_fortran_array'(p%s)\n", $P1
        concat dc, $S0
        .return (dc)

    fadc:
        $S0 = sprintf "q%s = '!matrixy_to_fortran_array'(p%s, 'Complex')\n", $P1
        concat dc, $S0
        .return (dc)

    fai:
        $S0 = sprintf "q%s = '!matrixy_to_fortran_array'(p%s, 'Integer')\n", $P1
        concat dc, $S0
        .return (dc)
.end

.sub '!get_out_driver_code_from_mnemonic'
    .param string index
    .param pmc param_config


    $P1 = new 'ResizablePMCArray'
    push $P1, index
    push $P1, index

    .local string sr

    $I0 = exists param_config[index;"type"]
    if $I0 goto construct_driver
    sr = sprintf "setref p%s, p%s\n\n", $P1
    .return (sr)

  construct_driver:
    sr = sprintf "setref p%s, q%s\n\n", $P1

    .local string type
    type = param_config[index;"type"]

    .local string dc
    .local string M, N
    do_M:
        $I0 = exists param_config[index;"rows"]
        unless $I0 goto default_M
        M = param_config[index;"rows"]
        goto end_M
    default_M:
        concat dc, "$P0 = get_hll_global ['_Matrixy';'builtins'], 'rows'\n"
        M = sprintf "$P0(1,1,p%s)", $P1
    end_M:

    do_N:
        $I0 = exists param_config[index;"cols"]
        unless $I0 goto default_N
        N = param_config[index;"cols"]
        goto end_N
    default_N:
        concat dc, "$P1 = get_hll_global ['_Matrixy';'builtins'], 'columns'\n"
        N = sprintf "$P1(1,1,p%s)", $P1
    end_N:

    # TODO: this needs to take string from parameter and compile
    # it using compreg matrixy. Currently only works for integer
    # values.
    $P0 = new 'ResizablePMCArray'
    push $P0, M
    push $P0, N
    $S0 = sprintf "$I100 = %s\n$I101 = %s\n", $P0
    concat dc, $S0

    push $P1, "$I100"
    push $P1, "$I101"

    if type == "fadr" goto fadr
    if type == "fadc" goto fadc
    if type == "fai" goto fai

    fadr:
        $S0 = sprintf "q%s = '!fortran_to_matrixy_array'(q%s, %s, %s)\n", $P1
        concat dc, $S0
        concat dc, sr
        .return (dc)

    fadc:
        $S0 = sprintf "q%s = '!fortran_to_matrixy_array'(q%s, %s, %s, 'Complex')\n", $P1
        concat dc, $S0
        concat dc, sr
        .return (dc)

    fai:
        $S0 = sprintf "q%s = '!fortran_to_matrixy_array'(q%s, %s, %s, 'Integer')\n", $P1
        concat dc, $S0
        concat dc, sr
        .return (dc)
.end

.sub '!get_param_list_from_nci_string'
    .param string nci_string
    .param pmc param_config

    .local string param_list
    param_list = ""

    .local int i1, i1_max
    i1_max = length nci_string
    i1 = 0 # first char is return type
    next_i1:
        i1 = i1 + 1
        unless i1 < i1_max goto end_i1
        $S0 = substr nci_string, i1,1 

        $P1 = new 'ResizablePMCArray'
        push $P1, i1

        $I0 = exists param_config[i1;"out"]
        if $I0 goto have_pmc
        $I0 = index "vPp", $S0
        unless $I0 == -1 goto have_pmc
        $I0 = index "csi234", $S0
        unless $I0 == -1 goto have_int
        $I0 = index "t", $S0 
        unless $I0 == -1 goto have_string
        $I0 = index "fd", $S0 
        unless $I0 == -1 goto have_num

        have_pmc:
            $S1 = sprintf ".param pmc p%s\n", $P1
            concat param_list, $S1
            goto next_i1

        have_int:
            $S1 = sprintf ".param int p%s\n", $P1
            concat param_list, $S1
            goto next_i1

        have_string:
            $S1 = sprintf ".param string p%s\n", $P1
            concat param_list, $S1
            goto next_i1

        have_num:
            $S1 = sprintf ".param num p%s\n", $P1
            concat param_list, $S1
            goto next_i1
    end_i1:


    .return (param_list)

.end

.sub '!get_return_type_from_nci_string'
    .param string nci_string

    $S0 = substr nci_string, 0, 1 

    $I0 = index "Pp234", $S0
    unless $I0 == -1 goto have_pmc
    $I0 = index "csi", $S0
    unless $I0 == -1 goto have_int
    $I0 = index "t", $S0
    unless $I0 == -1 goto have_string
    $I0 = index "fd", $S0
    unless $I0 == -1 goto have_num
    $I0 = index "v", $S0
    unless $I0 == -1 goto have_void

    have_pmc:
      .return("$P0 = ", "$P0")

    have_int:
      .return("$I0 = ", "$I0")

    have_string:
      .return("$S0 = ", "$S0")

    have_num:
      .return("$N0 = ", "$N0")

    have_void:
      .return("", "")

.end

.sub '!get_sub_code_string'
    .param pmc config

    .local int config_param_count
    config_param_count = config

    .local pmc str_parts
    str_parts = new 'ResizablePMCArray'

    .local pmc symbol_name
    symbol_name = config[0]

    .local string symbol_sig
    symbol_sig = config[1]

    .local pmc param_config
    param_config = config[2]

    .local string param_list
    param_list = '!get_param_list_from_nci_string'(symbol_sig, param_config)

    .local int pcount
    pcount = length symbol_sig

    .local string preamble
    .local string postamble
    preamble = ""
    postamble = ""

    .local pmc func_params
    func_params = new 'ResizablePMCArray'
    .local int i4
    i4 = 0
    next_i4:
        i4 = i4 + 1
        unless i4 < pcount goto end_i4
        $S0 = i4 

        $I0 = exists param_config[i4;"type"]
        if $I0 goto convert_in_param

        leave_in_param:
            $S1 = concat "p", $S0
            goto push_param

        convert_in_param:
            $S2 = param_config[i4;"type"]
            $S3 = '!get_in_driver_code_from_mnemonic'($S0, $S2)
            concat preamble, $S3
            $S1 = concat "q", $S0

        push_param:
            push func_params, $S1
            
        # construct postamble
        $I0 = exists param_config[i4;"out"] # TODO check non-zero
        unless $I0 goto next_i4
        $S3 = '!get_out_driver_code_from_mnemonic'(i4, param_config)
        concat postamble, $S3

        goto next_i4
    end_i4:

    .local string func_param_list
    func_param_list = join ",", func_params

    .local string func_ret_type_we, func_ret_type
    (func_ret_type_we, func_ret_type) = '!get_return_type_from_nci_string'(symbol_sig)

    push str_parts, param_list
    push str_parts, preamble
    push str_parts, symbol_name
    push str_parts, symbol_sig
    push str_parts, func_ret_type_we
    push str_parts, func_param_list
    push str_parts, postamble
    push str_parts, func_ret_type

    .local string template_sub

template_sub = <<"End_Template"

.sub '' :anon 
.param pmc lib
%s

.local string error_message

%s

.local pmc func
func = dlfunc lib, '%s', '%s'

%s func(%s)

success:
%s

.return (%s)

fail:
printerr error_message
.return ()

.end

End_Template

    .local string str_sub
    sprintf str_sub, template_sub, str_parts  

  finish:
    .return (str_sub)
.end

=item calllib(STRING libname, STRING function, arg_1, ..., arg_n) 

Calls a library function from "libname" called "function" with the arguments
specified. This function and library must have been loaded with the loadlibrary
function defined above.

=cut

.sub 'calllib'
    .param int nargout
    .param int nargin
    .param string libname
    .param string func_name
    .param pmc args :slurpy

    .local string error_message

    $P0 = get_hll_global ['_Matrixy';'LoadedLibrary'], libname
    $I0 = defined $P0
    if $I0 goto load_function
    error_message =  'cannot find lib!'
    goto fail

  load_function:
    $P1 = get_hll_global ['_Matrixy';'LoadedLibraryFunctions';libname], func_name
    $I0 = defined $P1
    if $I0 goto run_function
    error_message =  'cannot find function!'
    goto fail

  run_function:

    $P2 = $P1($P0, args :flat)
    setref args, args

    .return($P2)

  fail:
    printerr error_message
    .return()

.end


=item libisloaded(STRING libname) 

Returns 1 if library is loaded, 0 otherwise.

=cut

.sub 'libisloaded'
    .param int nargout
    .param int nargin
    .param string libname

    $P0 = get_hll_global ['_Matrixy';'LoadedLibrary'], libname
    $I0 = defined $P0
    if $I0 goto have_library
    .return (0)

    have_library:
        .return (1)
.end

