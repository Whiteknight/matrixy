plan(4);

signatures = [ "[]" ];
x = loadlibrary('nonexistent', signatures, 'FOOBAR');
is(x, 0, "nonexistent library")

x = libisloaded('FOOBAR');
is(x, 0, "nonexistent library not loaded")

start_todo("Need to figure out how to load the NCITEST library from Parrot");

signatures = [ '["nci_c", "c"]' ];
x = loadlibrary('../../runtime/parrot/dynext/libnci_test', signatures, 'NCITEST');
is(x, 1, "can load ncitest lib");

x = libisloaded('NCITEST');
is(x, 1, "existent library is loaded");

end_todo();
