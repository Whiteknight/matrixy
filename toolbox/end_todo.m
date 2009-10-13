function end_todo()
%% end_todo()
%% clears the TAP TODO flag. Calls to functions ok() and is() are expected
%% to pass like normal after this function is called
    global _TAP_TODO;
    global _TAP_TODO_MSG;
    _TAP_TODO = 0;
    _TAP_TODO_MSG = "";
endfunction