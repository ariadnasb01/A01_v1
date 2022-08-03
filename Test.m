classdef Test < matlab.unittest.TestCase

    methods (Test)
        function testKel (testCase)
            expected = load('exactSolution.mat');
            exactKel = expected.Kel;

            calculated = load('calculatedSolution.mat');
            calculatedKel = calculated.Kel;

            testCase.verifyEqual(exactKel,calculatedKel,'AbsTol', sqrt(eps));
        end

        function testKG (testCase)
            expected = load('exactSolution.mat');
            exactKG = expected.KG;

            calculated = load('calculatedSolution.mat');
            calculatedKG = calculated.KG;

            testCase.verifyEqual(exactKG,calculatedKG,'AbsTol', sqrt(eps));
        end

        function testForces (testCase)
            calculated = load('calculatedSolution.mat');
            calculatedFext = calculated.Fext;

            assert((calculatedFext(1,1)==0) & (calculatedFext(2,1)==0) & ...
                (calculatedFext(3,1)==0) & (calculatedFext(5,1)==0) & ...
                (calculatedFext(7,1)==0) & (calculatedFext(9,1)==0) & ...
                (calculatedFext(10,1)==0) & (calculatedFext(11,1)==0) & ...
                (calculatedFext(12,1)==0) & (calculatedFext(13,1)==0) & ...
                (calculatedFext(14,1)==0) & (calculatedFext(15,1)==0) & ...
                (calculatedFext(16,1)==0));
        
            assert(calculatedFext(4,1) == 3*calculatedFext(8,1));
        
            assert(calculatedFext(6,1) == 2*calculatedFext(8,1)); 
        end

        function testIterative(testCase)
            expected = load('exactSolution.mat');
            exactU = expected.u;

            calculatedBeforeSolve = load('calculatedBeforeSolve.mat');
            vL = calculatedBeforeSolve.vL;
            vR = calculatedBeforeSolve.vR;
            uR = calculatedBeforeSolve.uR;
            KG = calculatedBeforeSolve.KG;
            Fext = calculatedBeforeSolve.Fext;
            [calculatedU,R] = Solver.solve(vL,vR,uR,KG,Fext,"iterative");

            testCase.verifyEqual(exactU,calculatedU,'AbsTol', sqrt(eps));
        end

        function testDirect(testCase)
            expected = load('exactSolution.mat');
            exactU = expected.u;

            calculatedBeforeSolve = load('calculatedBeforeSolve.mat');
            vL = calculatedBeforeSolve.vL;
            vR = calculatedBeforeSolve.vR;
            uR = calculatedBeforeSolve.uR;
            KG = calculatedBeforeSolve.KG;
            Fext = calculatedBeforeSolve.Fext;
            [calculatedU,R] = Solver.solve(vL,vR,uR,KG,Fext,"direct");

            testCase.verifyEqual(exactU,calculatedU,'AbsTol', sqrt(eps));
        end
    end
end
