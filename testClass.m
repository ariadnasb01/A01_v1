classdef testClass < handle

    properties (Access = public)
        results
    end

    properties (Access = private)
        solution

        exactKElementalMatrix
        exactKGlobalMatrix
        exactDisplacements
    end


    methods (Access = public)

        function obj = testClass(Solution)
            obj.getCalcSolution(Solution);
            obj.getExactSolution;
            obj.runTests;
        end

    end

    methods (Access = private)

        function getCalcSolution(obj,Solution)
            obj.calcKElementalMatrix = Solution.KElementalMatrix;
            obj.calcKGlobalMatrix = Solution.KGlobalMatrix;
            obj.calcForcesExt = Solution.ForcesExt;
            obj.calcFreeDOF = Solution.FreeDOF;
            obj.calcFixDOF = Solution.FixDOF;
            obj.calcFixDispl = Solution.FixDispl;

            obj.solution = cParams.solution;
        end


        function getExactSolution(obj)
            expected = load('exactSolution.mat');

            obj.exactKElementalMatrix = expected.Kel;
            obj.exactKGlobalMatrix = expected.KG;
            obj.exactDisplacements = expected.u;
        end


        function runTests(obj)
            import matlab.unittest.parameters.Parameter
            import matlab.unittest.TestSuite
            
            param = Parameter.fromData('calcKElementalMatrix', {obj.calcKElementalMatrix}, ...
                'calcKGlobalMatrix', {obj.calcKGlobalMatrix}, ...
                'calcForcesExt', {obj.calcForcesExt}, ...
                'calcFreeDOF', {obj.calcFreeDOF}, ...
                'calcFixDOF', {obj.calcFixDOF}, ...
                'calcFixDispl', {obj.calcFixDispl}, ...
                'exactKElementalMatrix', {obj.exactKElementalMatrix}, ...
                'exactKGlobalMatrix', {obj.exactKGlobalMatrix}, ...
                'exactDisplacements', {obj.exactDisplacements});
            
            suite = TestSuite.fromClass(?Tests,'ExternalParameters',param);
            
            obj.results = suite.run;
            disp(obj.results)
        end

    end

end