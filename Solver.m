classdef Solver

    methods (Access = public, Static)

        function [u,R] = solve(vL,vR,uR,KG,Fext,type)

            switch type 
                case "direct"
                [u,R] = Direct.solve(vL,vR,uR,KG,Fext);

                case "iterative"
                [u,R] = Iterative.solve(vL,vR,uR,KG,Fext);

            end

        end

    end
    
end





