classdef Direct < Solver 

    methods (Access = public, Static)

        function uL = solve(LHS, RHS)
            uL = LHS \ RHS;
        end
        
    end

end


