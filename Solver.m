classdef Solver

    methods (Access = public, Static)

        function [u,R] = solve(vL,vR,uR,KG,Fext,type)

            if type == "direct"
                [u,R] = Direct.solve(vL,vR,uR,KG,Fext);

             elseif type == "iterative"
                [u,R] = Iterative.solve(vL,vR,uR,KG,Fext);

            end
        end
    end
end





