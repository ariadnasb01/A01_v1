classdef Tests < matlab.unittest.TestCase
    
    properties (TestParameter)
        calcKElementalMatrix = {0}
        calcKGlobalMatrix = {0}
        calcForcesExt = {0}
        calcFreeDOF = {0}
        calcFixDOF = {0}
        calcFixDispl = {0}

        exactKElementalMatrix = {0}
        exactKGlobalMatrix = {0}
        exactDisplacements = {0}
    end


    methods (Test)

        function testKel (testCase, calcKElementalMatrix, exactKElementalMatrix)
            testCase.verifyEqual(exactKElementalMatrix,calcKElementalMatrix,'AbsTol', sqrt(eps));
        end


        function testKG (testCase, calcKGlobalMatrix, exactKGlobalMatrix)
            testCase.verifyEqual(exactKGlobalMatrix,calcKGlobalMatrix,'AbsTol', sqrt(eps));
        end


        function testForces (testCase, calcForcesExt)
            
            assert((calcForcesExt(1,1)==0) & (calcForcesExt(2,1)==0) & ...
                (calcForcesExt(3,1)==0) & (calcForcesExt(5,1)==0) & ...
                (calcForcesExt(7,1)==0) & (calcForcesExt(9,1)==0) & ...
                (calcForcesExt(10,1)==0) & (calcForcesExt(11,1)==0) & ...
                (calcForcesExt(12,1)==0) & (calcForcesExt(13,1)==0) & ...
                (calcForcesExt(14,1)==0) & (calcForcesExt(15,1)==0) & ...
                (calcForcesExt(16,1)==0));
        
            assert(calcForcesExt(4,1) == 3*calcForcesExt(8,1));
        
            assert(calcForcesExt(6,1) == 2*calcForcesExt(8,1)); 
        end


        function testIterative(testCase,calcFreeDOF,calcFixDOF,calcFixDispl,calcKGlobalMatrix,calcForcesExt,exactDisplacements)
            [calcDisplacements,R] = Solver.solve(calcFreeDOF,calcFixDOF,calcFixDispl,calcKGlobalMatrix,calcForcesExt,"iterative");
            testCase.verifyEqual(exactDisplacements,calcDisplacements,'AbsTol', sqrt(eps));
        end


        function testDirect(testCase,calcFreeDOF,calcFixDOF,calcFixDispl,calcKGlobalMatrix,calcForcesExt,exactDisplacements)
            [calcDisplacements,R] = Solver.solve(calcFreeDOF,calcFixDOF,calcFixDispl,calcKGlobalMatrix,calcForcesExt,"direct");
            testCase.verifyEqual(exactDisplacements,calcDisplacements,'AbsTol', sqrt(eps));
        end

    end

end