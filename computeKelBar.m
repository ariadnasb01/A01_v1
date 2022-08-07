classdef computeKelBar < handle

    properties
        KElementalMatrix
    end

    methods (Access = public)

        function obj = computeKelBar(n_d,n_el,x,Tn,mat,Tmat)

            Kel = zeros(n_d, n_d, n_el);

            for e = 1:n_el
                x1 = x(Tn(e,1),1);
                y1 = x(Tn(e,1),2);
                x2 = x(Tn(e,2),1);
                y2 = x(Tn(e,2),2);
                l = sqrt((x2-x1)^2+(y2-y1)^2);
                s = (y2-y1)/l;
                c = (x2-x1)/l;

                K = (mat(Tmat(e),1)*mat(Tmat(e),2)/l)*[c^2 c*s -c^2 -c*s
                    c*s s^2 -c*s -s^2
                    -c^2 -c*s c^2 c*s
                    -c*s -s^2 c*s s^2];

                for r = 1:n_d*2

                    for s = 1:n_d*2
                        Kel(r,s,e) = K(r,s);
                    end

                end

            end

            obj.KElementalMatrix = Kel;

        end

    end

end