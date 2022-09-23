classdef IterativeTester < handle

    properties (Access = public)
        results
    end
    
    properties (Access = private)
        freeDOF
        fixDOF
        fixDispl
        kGlobalMatrix
        forcesExt
        calcDisplacement
        solverType
        expDisplacement
    end

    methods (Access = public)

        function obj = IterativeTester(cParams)
            obj.init(cParams);
        end

        function test (obj)
            obj.getDisplacement();
            obj.testDisplacement();
        end

    end

    methods (Access = private)

        function init(obj,cParams)
            obj.expDisplacement = cParams.displacements;
            obj.freeDOF = cParams.freeDOF;
            obj.fixDOF = cParams.fixDOF;
            obj.fixDispl = cParams.fixDispl;
            obj.kGlobalMatrix = cParams.kGlobalMatrix;
            obj.forcesExt = cParams.forcesExt;
        end

        function getDisplacement(obj)
            s.vL = obj.freeDOF;
            s.vR = obj.fixDOF;
            s.uR = obj.fixDispl;
            s.KG = obj.kGlobalMatrix;
            s.Fext = obj.forcesExt;
            s.solverType = "iterative";
            sol = DisplacementReactionComputer(s);
            sol.compute();
            obj.calcDisplacement = sol.displacement;
        end

        function testDisplacement (obj)
            A = obj.expDisplacement;
            B = obj.calcDisplacement;
            c = matrixTester(A, B); 
            obj.results = c.results;
        end

    end

end