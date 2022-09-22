classdef ForcesTester < handle

    properties (Access = public)
        results
    end
    
    properties (Access = private)
        calcForces
        expForces
        resultsTests
    end

    methods (Access = public)

        function obj = ForcesTester(cParams)
            obj.init(cParams);
        end

        function test (obj)
            obj.testForcesEqual();
            obj.testForcesZeros();
            obj.testForcesDouble();
            obj.testForcesTriple();
            obj.allTests();
        end

    end

    methods (Access = private)

        function init(obj,cParams)
            obj.expForces = cParams.expForces;
            obj.calcForces = cParams.calcForces;
        end

        function testForcesEqual (obj)
            A = obj.expForces;
            B = obj.calcForces;

            if (abs(A-B) < 1e4*eps(min(abs(A),abs(B))))
                obj.resultsTests.test1 = 1;
            else
                obj.resultsTests.test1 = 0;
            end
        end

        function testForcesZeros(obj)
            A = obj.calcForces;
            if ((A(1,1)==0) && (A(2,1)==0) && (A(3,1)==0) && ...
                (A(5,1)==0) && (A(7,1)==0) && (A(9,1)==0) && ...
                (A(10,1)==0) && (A(11,1)==0) && (A(12,1)==0) && ...
                (A(13,1)==0) && (A(14,1)==0) && (A(15,1)==0) && ...
                (A(16,1)==0))
                obj.resultsTests.test2 = 1;
            else 
                obj.resultsTests.test2 = 0;
            end
        end

        function testForcesDouble(obj)
            A = obj.calcForces;
            if (A(6,1) == 2*A(8,1))
                obj.resultsTests.test3 = 1;
            else 
                obj.resultsTests.test3 = 0;
            end
        end

        function testForcesTriple(obj)
            A = obj.calcForces;
            if (A(4,1) == 3*A(8,1))
                obj.resultsTests.test4 = 1;
            else 
                obj.resultsTests.test4 = 0;
            end
        end

        function allTests(obj)
            test1 = obj.resultsTests.test1;
            test2 = obj.resultsTests.test2;
            test3 = obj.resultsTests.test3;
            test4 = obj.resultsTests.test4;
            if (test1==1 && test2==1 && test3==1 && test4==1)
                obj.results = 1;
            else
                obj.results = 0;
            end
        end

    end

end