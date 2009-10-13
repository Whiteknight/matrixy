function ok(good, comment)
%% ok(num, comment)
%% Indicate that test num has passed with comment.
%% The behavior of ok() might be altered by other functions, such as
%% start_todo() or end_todo()
    global _TAP_TODO;       % if this is 1, we're in todo mode
    global _TAP_TODO_MSG;   % the todo message,
    global _TAP_TEST_CNT;   % the number of the current test

    if good == 0
        printf("not ok %d %s", _TAP_TEST_CNT, comment);
    else
        printf("ok %d %s", _TAP_TEST_CNT, comment);
    end

    if _TAP_TODO == 1
        printf(" # TODO %s", _TAP_TODO_MSG);
    end
    printf("\n");
    _TAP_TEST_CNT = _TAP_TEST_CNT + 1;
endfunction
