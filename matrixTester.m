classdef matrixTester < handle

    properties (Access = public)
        results
    end

    methods (Access = public)

        function obj = matrixTester (A, B)
            obj.test(A, B);
        end

    end

    methods (Access = private)

        function test (obj, A, B)
            if (abs(A-B) < 1e4*eps(min(abs(A),abs(B))))
                obj.results = 1;
            else
                obj.results = 0;
            end
        end

    end

end