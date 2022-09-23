classdef Iterative < Solver 

    methods (Access = public, Static)

        function uL = solve(LHS, RHS)
            uL = pcg(LHS, RHS);
        end

    end
    
end

