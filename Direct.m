classdef Direct < Solver 

    methods (Access = public, Static)

        function [u,R] = solve(parameters)
            vL = parameters.vL;
            vR = parameters.vR;
            uR = parameters.uR;
            KG = parameters.KG;
            Fext = parameters.Fext;

            KLL = KG(vL, vL);
            KLR = KG(vL, vR);
            KRL = KG(vR, vL);
            KRR = KG(vR, vR);
            FL = Fext(vL, 1);
            FR = Fext(vR, 1);
            
            uL = inv(KLL)*(FL-KLR*uR);
            RR = KRR*uR+KRL*uL-FR;
            
            u(vL,1) = uL;
            u(vR,1) = uR;
            
            R(vL,1) = 0;
            R(vR,1) = RR;
        end
        
    end

end


