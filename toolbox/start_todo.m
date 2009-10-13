function start_todo(todocomment)
%% start_todo(comment)
%% Tells the TAP test suite that tests following this statement are
%% TODO tests that are not expected to pass. Calling end_todo clears
%% the todo flag and expects tests to pass like normal
    global _TAP_TODO;
    global _TAP_TODO_MSG;
    _TAP_TODO = 1;
    _TAP_TODO_MSG = todocomment;
endfunction