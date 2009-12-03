function what = ischar(var)
	mytype = parrot_typeof(var);
	if mytype == "String"
		what = 1;
	else
		if mytype == "CharMatrix2D"
			what = 1;
	        else
			what = 0;
		endif
	endif
endfunction
