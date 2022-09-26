classdef testClass < handle

    properties (Access = public)
        results
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
            obj.expectedResults = cParams;
        end
        
        function testKElementalMatrix(obj)
            s.expKElementalMatrix = obj.expectedResults.kElementalMatrix;
            s.dimensions          = obj.expectedResults.dimensions;
            s.datas               = obj.expectedResults.datas;
            s.nodalConnect        = obj.expectedResults.nodalConnect;
            k = StiffnesMatrixAssembler(s);
            k.compute();
            obj.calculatedResults.kGlobalMatrix = k.kGlobalMatrix;
            A = k.kElementalMatrix;
            B = obj.expectedResults.kElementalMatrix;
            c = matrixTester(A, B); 
            obj.results.kElementalMatrix = c.results;
        end

        function testKGlobalMatrix(obj)
            A = obj.calculatedResults.kGlobalMatrix;
            B = obj.expectedResults.kGlobalMatrix;
            c = matrixTester(A, B); 
            obj.results.kGlobalMatrix = c.results;
        end

        function testForces(obj)
            s.nDofTotal  = obj.expectedResults.dimensions.nDofTotal;
            s.forcesData = obj.expectedResults.datas.forcesData;
            f = ForcesComputer(s);
            a.calcForces = f.compute();
            a.expForces = obj.expectedResults.forcesExt;
            c = ForcesTester(a); 
            c.test();
            obj.results.forcesExt = c.results;
        end

        function testIterative(obj)
            expected = obj.expectedResults;
            c = IterativeTester(expected); 
            c.test();
            obj.results.iterativeTest = c.results;
        end
        
        function testDirect(obj)
            expected = obj.expectedResults;  
            c = DirectTester(expected); 
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