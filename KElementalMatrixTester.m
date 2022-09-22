classdef KElementalMatrixTester < handle

    properties (Access = public)
        results
    end
    
    properties (Access = private)
        calcKElementalMatrix
        expKElementalMatrix
    end

    methods (Access = public)

        function obj = KElementalMatrixTester(cParams)
            obj.init(cParams);
        end

        function test (obj)
            obj.testKElementalMatrix();
        end

    end

    methods (Access = private)

        function init(obj,cParams)
            obj.expKElementalMatrix = cParams.expKElementalMatrix;
            obj.calcKElementalMatrix = cParams.calcKElementalMatrix;
        end

        function testKElementalMatrix (obj)
            A = obj.expKElementalMatrix;
            B = obj.calcKElementalMatrix;

            if (abs(A-B) < 1e4*eps(min(abs(A),abs(B))))
                obj.results = 1;
            else
                obj.results = 0;
            end
        end

    end

end