plan(10);

# power
is(10^2 , 100, "simple exponent")
ok(10*10^2 == 1000, "power is tighter than product")
is(10+10^2 , 110, "power is tighter than sum")
is(10-10^2 , -90, "power is tighter than difference")
is(2^3^4 , 4096, "power of power")

# product
is(10 * 20, 200, "simple product");
is(10i * 20, 200i, "simple complex product");
is((10i + 5) * 20, 200i +100, "simple complex product");
is(10i + 5 * 20, 10i +100, "tighter than plus");
is(0*100, 0, "check nothing crazy happening");
