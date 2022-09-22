classdef testClass < handle

    properties (Access = public)
        results
        table1
        table2
    end

    properties (Access = private)
        expectedResults
        calculatedResults
    end


    methods (Access = public)

        function obj = testClass(cParams)
            obj.init(cParams);
        end

        function check(obj)
            obj.testKElementalMatrix();
            obj.testKGlobalMatrix();
            obj.testForces();
            obj.testIterative();
            obj.testDirect();
            obj.showResults();
        end

    end

    methods (Access = private)

        function init(obj,cParams)
            expRes = load('exactSolution.mat');
            obj.expectedResults = expRes;
            obj.calculatedResults = cParams;
        end
        
        function testKElementalMatrix(obj)
            s.expKElementalMatrix = obj.expectedResults.Kel;
            s.calcKElementalMatrix = obj.calculatedResults.kElementalMatrix;
            c = KElementalMatrixTester(s); 
            c.test();
            obj.results.kElementalMatrix = c.results;
        end

        function testKGlobalMatrix(obj)
            s.expKGlobalMatrix = obj.expectedResults.KG;
            s.calcKGlobalMatrix = obj.calculatedResults.kGlobalMatrix;
            c = KGlobalMatrixTester(s); 
            c.test();
            obj.results.kGlobalMatrix = c.results;
        end

        function testForces(obj)
            s.expForces = obj.expectedResults.Fext;
            s.calcForces = obj.calculatedResults.forcesExt;
            c = ForcesTester(s); 
            c.test();
            obj.results.forcesExt = c.results;
        end

        function testIterative(obj)
            s.expDisplacement = obj.expectedResults.u;
            s.calculatedValues = obj.calculatedResults;            
            c = IterativeTester(s); 
            c.test();
            obj.results.iterativeTest = c.results;
        end
        
        function testDirect(obj)
            s.expDisplacement = obj.expectedResults.u;
            s.calculatedValues = obj.calculatedResults;            
            c = DirectTester(s); 
            c.test();
            obj.results.directTest = c.results;
        end

        function showResults(obj)
            res = obj.results;
            c = ResultsDisplayer(res);
            c.show();
        end

    end

end