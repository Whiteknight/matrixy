function nok(bad, comment)
%% nok(bad, comment)
%% the opposite of ok()
%% succeeds if the first argument is false, fails if it is true. Calls ok()
%% internally, so has all the same behaviors as that.
    % TODO: We need a logical inversion "!" operator to make this simpler
    if bad == 0
        bad = 1;
    else
        bad = 0;
    end
    ok(bad, comment);
endfunction
