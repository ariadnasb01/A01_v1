classdef KGlobalMatrixTester < handle

    properties (Access = public)
        results
    end
    
    properties (Access = private)
        calcKGlobalMatrix
        expKGlobalMatrix
    end

    methods (Access = public)

        function obj = KGlobalMatrixTester(cParams)
            obj.init(cParams);
        end

        function test (obj)
            obj.testKGlobalMatrix();
        end

    end

    methods (Access = private)

        function init(obj,cParams)
            obj.expKGlobalMatrix = cParams.expKGlobalMatrix;
            obj.calcKGlobalMatrix = cParams.calcKGlobalMatrix;
        end

        function testKGlobalMatrix (obj)
            A = obj.expKGlobalMatrix;
            B = obj.calcKGlobalMatrix;

            if (abs(A-B) < 1e4*eps(min(abs(A),abs(B))))
                obj.results = 1;
            else
                obj.results = 0;
            end
        end

    end

end