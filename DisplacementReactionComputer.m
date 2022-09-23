classdef DisplacementReactionComputer < handle

    properties (Access = public)
        displacement
        reaction
    end

    properties (Access = private)
        parameters
        solverType
        LHSMatrix
        RHSMatrix
        freeDispl
    end

    methods (Access = public)

        function obj = DisplacementReactionComputer(cParams)
            obj.init(cParams);
        end
        
        function compute(obj)
            obj.obtainEquation();
            obj.computeDisplacement();
            obj.computeReactions();
        end

    end

    methods (Access = private)

        function init(obj,cParams)
            obj.parameters = cParams;
            obj.solverType = cParams.solverType;
        end

        function obtainEquation(obj)
            vL   = obj.parameters.vL;
            vR   = obj.parameters.vR;
            uR   = obj.parameters.uR;
            KG   = obj.parameters.KG;
            Fext = obj.parameters.Fext;
            KLL  = KG(vL, vL);
            KLR  = KG(vL, vR);
            FL   = Fext(vL, 1);

            obj.LHSMatrix = KLL;
            obj.RHSMatrix = FL-KLR*uR;
        end

        function computeDisplacement(obj)
            s.type = obj.solverType;
            s.LHS  = obj.LHSMatrix;
            s.RHS  = obj.RHSMatrix;
            vL     = obj.parameters.vL;
            vR     = obj.parameters.vR;
            uR     = obj.parameters.uR;

            c = Solver(s);
            uL = c.solve();
            disp(vL,1) = uL;
            disp(vR,1) = uR;

            obj.freeDispl = uL;
            obj.displacement = disp;
        end

        function computeReactions(obj)
            vL   = obj.parameters.vL;
            uL   = obj.freeDispl;
            vR   = obj.parameters.vR;
            uR   = obj.parameters.uR;
            KG   = obj.parameters.KG;
            Fext = obj.parameters.Fext;
            KRL  = KG(vR, vL);
            KRR  = KG(vR, vR);
            FR   = Fext(vR, 1);

            RR  = KRR*uR+KRL*uL-FR;
            R(vL,1) = 0;
            R(vR,1) = RR;

            obj.reaction = R;
        end

    end
    
end





