plan(1);

support = 0;
comp = computer();
if comp == "i386-MSWin32"
    support = 1;
endif
if comp == "i386-linux"
    support = 1;
endif
if comp == "amd64-linux"
    support = 1;
endif


ok(support, "check we run on a supported platform");

