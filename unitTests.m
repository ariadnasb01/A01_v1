function unitTests (R, F, KG, u, Fext, x, testCase)

    % Sum of forces in the horizontal and vertical axes
    assert(abs(R(1,1)+R(9,1)) < 1e-8);

    assert(abs(R(2,1)+R(10,1)+F+2*F+3*F) < 1e-8);


    % Solution of the global system of equations
    A = KG*u;
    B = Fext+R;
    for i = 1:length(R)
        a = A(i,1);
        b = B(i,1);
        assert(abs(a-b) < 1e-8);
    end


    % Array size
    verifyLength(testCase, R, size(x,2)*size(x,1));
    

    % Check forces
    assert((Fext(1,1)==0) & (Fext(2,1)==0) & (Fext(3,1)==0) & ...
        (Fext(5,1)==0) & (Fext(7,1)==0) & (Fext(9,1)==0) & ...
        (Fext(10,1)==0) & (Fext(11,1)==0) & (Fext(12,1)==0) & ...
        (Fext(13,1)==0) & (Fext(14,1)==0) & (Fext(15,1)==0) & ...
        (Fext(16,1)==0));

    assert(Fext(4,1) == 3*Fext(8,1));

    assert(Fext(6,1) == 2*Fext(8,1));  


end

