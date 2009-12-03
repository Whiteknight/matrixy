function what = iscell(var)
	mytype = parrot_typeof(var);
	what = (mytype == 'PMCMatrix2D');
endfunction
