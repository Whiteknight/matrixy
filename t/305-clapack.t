function y = round2(N, d)
    y = round(N.*(10^d))./(10^d); 
endfunction

if libisloaded('CLAPACK')
    plan(8)

    A = [ 1.0  1.2  1.4  1.6  1.8  2.0  2.2  2.4  2.6 ; 1.2  1.0  1.2  1.4  1.6  1.8  2.0  2.2  2.4 ; 1.4  1.2  1.0  1.2  1.4  1.6  1.8  2.0  2.2 ; 1.6  1.4  1.2  1.0  1.2  1.4  1.6  1.8  2.0 ; 1.8  1.6  1.4  1.2  1.0  1.2  1.4  1.6  1.8 ; 2.0  1.8  1.6  1.4  1.2  1.0  1.2  1.4  1.6 ; 2.2  2.0  1.8  1.6  1.4  1.2  1.0  1.2  1.4 ; 2.4  2.2  2.0  1.8  1.6  1.4  1.2  1.0  1.2 ; 2.6  2.4  2.2  2.0  1.8  1.6  1.4  1.2  1.0 ];
    IP = [0;0;0;0;0;0;0;0;0];
    info = -1;

    calllib('CLAPACK', 'dgetrf_', 9,9,A,9,IP,info);

    A1=[2.6,2.4,2.2,2.0,1.8,1.6,1.4,1.2,1.0;0.4,0.3,0.6,0.8,1.1,1.4,1.7,1.9,2.2;0.5,-0.4,0.4,0.8,1.2,1.6,2.0,2.4,2.8;0.5,-0.3,0.0,0.4,0.8,1.2,1.6,2.0,2.4;0.6,-0.3,0.0,0.0,0.4,0.8,1.2,1.6,2.0;0.7,-0.2,0.0,0.0,0.0,0.4,0.8,1.2,1.6;0.8,-0.2,0.0,0.0,0.0,0.0,0.4,0.8,1.2;0.8,-0.1,0.0,0.0,0.0,0.0,0.0,0.4,0.8;0.9,-0.1,0.0,0.0,0.0,0.0,0.0,0.0,0.4];
    IP1 = [9;9;9;9;9;9;9;9;9];

    is(info, 0, "dgetrf correct info 1")
    is(round2(A,1), A1, "dgetrf correct A 1")
    is(IP, IP1, "dgetrf correct IP 1")


    # Ex 3
    #
    A = [ 1.0  1.0  1.0  1.0  0.0  0.0   0.0   0.0   0.0 ; 1.0  1.0  1.0  1.0  1.0  0.0   0.0   0.0   0.0 ; 4.0  1.0  1.0  1.0  1.0  1.0   0.0   0.0   0.0 ; 0.0  5.0  1.0  1.0  1.0  1.0   1.0   0.0   0.0 ; 0.0  0.0  6.0  1.0  1.0  1.0   1.0   1.0   0.0 ; 0.0  0.0  0.0  7.0  1.0  1.0   1.0   1.0   1.0 ; 0.0  0.0  0.0  0.0  8.0  1.0   1.0   1.0   1.0 ; 0.0  0.0  0.0  0.0  0.0  9.0   1.0   1.0   1.0 ; 0.0  0.0  0.0  0.0  0.0  0.0  10.0  11.0  12.0 ];
    IP = [0;0;0;0;0;0;0;0;0];
    info = -1;

    calllib('CLAPACK', 'dgetrf_', 9,9,A,9,IP,info);

    A1 = [4.0000,1.0000,1.0000,1.0000, 1.0000, 1.0000, 0.0000, 0.0000, 0.0000 ;0.0000,5.0000,1.0000,1.0000, 1.0000, 1.0000, 1.0000, 0.0000, 0.0000 ;0.0000,0.0000,6.0000,1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 0.0000 ;0.0000,0.0000,0.0000,7.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000 ;0.0000,0.0000,0.0000,0.0000, 8.0000, 1.0000, 1.0000, 1.0000, 1.0000 ;0.0000,0.0000,0.0000,0.0000, 0.0000, 9.0000, 1.0000, 1.0000, 1.0000 ;0.0000,0.0000,0.0000,0.0000, 0.0000, 0.0000,10.0000,11.0000,12.0000 ;0.2500,0.1500,0.1000,0.0714, 0.0536,-0.0694,-0.0306, 0.1806, 0.3111 ;0.2500,0.1500,0.1000,0.0714,-0.0714,-0.0556,-0.0194, 0.9385,-0.0031];
    IP1 = [3;4;5;6;7;8;9;8;9];

    is(info, 0, "dgetrf correct info 2")
    is(round2(A,4), A1, "dgetrf correct A 2")
    is(IP, IP1, "dgetrf correct IP 2")


    # Ex 1
    #
    info = -1;
    WORK = zeros(10, 1);

    calllib('CLAPACK', 'dgetri_', 9, A, 9, IP, WORK, 10, info);

    A1 = [0.333,-0.667,0.333,0.000,0.000,0.000,0.042,-0.042,0.000; 56.833,-52.167,-1.167,-0.500,-0.500,-0.357,6.836,-0.479,-0.500; -55.167,51.833,0.833,0.500,0.500,0.214,-6.735,0.521,0.500; -1.000,1.000,0.000,0.000,0.000,0.143,-0.143,0.000,0.000; -1.000,1.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000; -1.000,1.000,0.000,0.000,0.000,0.000,-0.125,0.125,0.000; -226.000,206.000,5.000,3.000,2.000,1.429,-27.179,1.750,2.000;560.000,-520.000,-10.000,-6.000,-4.000,-2.857,67.857,-5.000,-5.000; -325.000,305.000,5.000,3.000,2.000,1.429,-39.554,3.125,3.000];

    is(info, 0, "dgetri correct info 1")
    is(round2(A,3), A1, "dgetri correct A 1")
    
else
    plan(0)
end
