plan(5);

function foo()
    global a;
    printf("ok %d\n", a);
endfunction

function bar()
    global a;
    a = a + 1;
    printf("ok %d\n", a);
endfunction

function baz(x)
    global a;
    a = a + x;
    printf("ok %d\n", a);
endfunction

function woot(a)
    printf("ok %d\n", a);
endfunction

global a;
a = 1;
foo();
bar();
baz(1);
a = 4;
foo();
woot(5);
