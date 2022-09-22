classdef DirectTester < handle

    properties (Access = public)
        results
    end
    
    properties (Access = private)
        calcFreeDOF
        calcFixDOF
        calcFixDispl
        calcKGlobalMatrix
        calcForcesExt
        calcDisplacement
        solverType
        expDisplacement
    end

    methods (Access = public)

        function obj = DirectTester(cParams)
            obj.init(cParams);
        end

        function test (obj)
            obj.getDisplacement();
            obj.testDisplacement();
        end

    end

    methods (Access = private)

        function init(obj,cParams)
            obj.expDisplacement = cParams.expDisplacement;
            obj.calcFreeDOF = cParams.calculatedValues.freeDOF;
            obj.calcFixDOF = cParams.calculatedValues.fixDOF;
            obj.calcFixDispl = cParams.calculatedValues.fixDispl;
            obj.calcKGlobalMatrix = cParams.calculatedValues.kGlobalMatrix;
            obj.calcForcesExt = cParams.calculatedValues.forcesExt;
        end

        function getDisplacement(obj)
            s.vL = obj.calcFreeDOF;
            s.vR = obj.calcFixDOF;
            s.uR = obj.calcFixDispl;
            s.KG = obj.calcKGlobalMatrix;
            s.Fext = obj.calcForcesExt;
            s.solverType = "direct";
            sol = Solver(s);
            sol.solve();
            obj.calcDisplacement = sol.u;
        end

        function testDisplacement (obj)
            A = obj.expDisplacement;
            B = obj.calcDisplacement;

            if (abs(A-B) < 1e4*eps(min(abs(A),abs(B))))
                obj.results = 1;
            else
                obj.results = 0;
            end
        end

    end

end