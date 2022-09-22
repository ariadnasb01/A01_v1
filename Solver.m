classdef Solver < handle

    properties (Access = public)
        u
        R
    end

    properties (Access = private)
        parameters
        solverType
    end

    methods (Access = public)

        function obj = Solver(cParams)
            obj.init(cParams);
        end
        
        function solve(obj)
            obj.compute();
        end

    end

    methods (Access = private)

        function init(obj,cParams)
            obj.parameters = cParams;
            obj.solverType = cParams.solverType;
        end

        function compute(obj)
            type = obj.solverType;
            params = obj.parameters;

            switch type 
                case "direct"
                [u,R] = Direct.solve(params);

                case "iterative"
                [u,R] = Iterative.solve(params);
            end

            obj.u = u;
            obj.R = R;

        end

    end
    
end





