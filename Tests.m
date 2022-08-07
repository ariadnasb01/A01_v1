classdef Tests < matlab.unittest.TestCase
    
    properties (TestParameter)
        KElementalMatrix = {0}
        KGlobalMatrix = {0}
        ForcesExt = {0}
        FreeDOF = {0}
        FixDOF = {0}
        FixDispl = {0}
    end


    methods (Test)

        function testKel (testCase, KElementalMatrix)
            expected = load('exactSolution.mat');
            exactKel = expected.Kel;

            calculatedKel = KElementalMatrix;

            testCase.verifyEqual(exactKel,calculatedKel,'AbsTol', sqrt(eps));
        end


        function testKG (testCase, KGlobalMatrix)
            expected = load('exactSolution.mat');
            exactKG = expected.KG;

            calculatedKG = KGlobalMatrix;

            testCase.verifyEqual(exactKG,calculatedKG,'AbsTol', sqrt(eps));
        end


        function testForces (testCase, ForcesExt)
            
            calculatedFext = ForcesExt;

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


        function testIterative(testCase,FreeDOF,FixDOF,FixDispl,KGlobalMatrix,ForcesExt)
            expected = load('exactSolution.mat');
            exactU = expected.u;

            [calculatedU,R] = Solver.solve(FreeDOF,FixDOF,FixDispl,KGlobalMatrix,ForcesExt,"iterative");

            testCase.verifyEqual(exactU,calculatedU,'AbsTol', sqrt(eps));
        end


        function testDirect(testCase,FreeDOF,FixDOF,FixDispl,KGlobalMatrix,ForcesExt)
            expected = load('exactSolution.mat');
            exactU = expected.u;

            [calculatedU,R] = Solver.solve(FreeDOF,FixDOF,FixDispl,KGlobalMatrix,ForcesExt,"direct");

            testCase.verifyEqual(exactU,calculatedU,'AbsTol', sqrt(eps));
        end

    end

end