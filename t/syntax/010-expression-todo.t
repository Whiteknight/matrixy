disp("1..2") 

# these are a few common idioms that don't work right now and
# should be fixed.

# this works
# x = -10
# but this doesn't
# x = +10
disp("not ok 1 # TODO plus should be valid before int/float")

# array constructs with minus signs break
A = [1 -1 ; 2 -2];
B = [1, -1; 2, -2];

if A == B 
    disp("ok 2")
else
    disp("not ok 2 # TODO minus signs should be tighter than spaces")
end


