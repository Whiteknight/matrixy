if libisloaded('CLAPACK')
    plan(2)

    A1 = [ 1 2 ; 3 4];
    B1 = [-2, 1; 1.5, -0.5];
    C1 = inverse(A1);
    is(round(10.*B1), round(10.*C1), "invert 2x2")

    A1 = [1,5,2; 1,1,7; 0,-3,4];
    B1 = [-25,26,-33; 4,-4,5; 3,-3,4];
    C1 = inverse(A1);
    is(B1, C1, "invert 3x3")
else
    plan(0)
end


