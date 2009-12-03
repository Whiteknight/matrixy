function what = ismatrix(var)
	code = [".sub '' :anon"
		"    .param pmc x"
		"    $I0 = does x, 'matrix'"
		"    .return($I0)"
		".end"];
	what = pir(code, var);
endfunction
