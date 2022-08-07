classdef computeStrainStressBar < handle

    properties
        strain
        stress
    end

    methods (Access = public)

        function obj = computeStrainStressBar(n_d,n_el,u,Td,x,Tn,mat,Tmat)

            for e = 1:n_el
                x1 = x(Tn(e,1),1);
                y1 = x(Tn(e,1),2);
                x2 = x(Tn(e,2),1);
                y2 = x(Tn(e,2),2);
                l = sqrt((x2-x1)^2+(y2-y1)^2);
                s = (y2-y1)/l;
                c = (x2-x1)/l;
            
                R = [c s 0 0
                    -s c 0 0
                    0 0 c s
                    0 0 -s c];
                
                for i = 1:2*n_d
                    I = Td(e,i);
                    u1(i,1) = u(I);
                end
                
                u2 = R*u1;
                eps(e,1) = 1/l*[-1 0 1 0]*u2;
                sig(e,1) = mat(Tmat(e),1)*eps(e,1);
            end

            obj.strain = eps;
            obj.stress = sig;

        end

    end

end