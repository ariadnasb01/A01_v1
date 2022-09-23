classdef Solver < handle

    properties (Access = private)
        solverType
        LHS
        RHS
    end

    methods (Access = public)
        
        function obj = Solver(cParams)
            obj.init(cParams);
        end

        function uL = solve(obj)
            uL = obj.compute();
        end

    end

    methods (Access = private)

        function init(obj, cParams)
            obj.solverType = cParams.type;
            obj.LHS = cParams.LHS;
            obj.RHS = cParams.RHS;
        end

        function uL = compute(obj)
            A = obj.LHS;
            B = obj.RHS;
            type = obj.solverType;
            switch type 
                case "direct"
                uL = Direct.solve(A, B);
                case "iterative"
                uL = Iterative.solve(A, B);
            end
        end

    end

end