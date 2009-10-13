function min(A,B)
%% min(A,B)
%% Returns the minimum of two numbers,
%% Currently only non complex scalar arguments are supported.
    if parrot_typeof(A) != 'Complex'
        if isscalar(A)
            if parrot_typeof(B) != 'Complex'
                if isscalar(B)
                    if A < B
                        return A
                    else
                        return B
                    end
                end
            end
        end
    end
    disp("unsupported type sorry :(")
endfunction
