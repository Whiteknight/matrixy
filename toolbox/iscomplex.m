function what = iscomplex(var)
	mytype = parrot_typeof(var);
	if mytype == "Complex"
		what = 1;
	else
		if mytype == "ComplexMatrix2D"
			what = 1;
		else
			what = 0;
		endif
	endif
endfunction
