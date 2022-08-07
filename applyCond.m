classdef applyCond < handle

    properties
        vL
        vR
        uR
    end

    methods (Access = public)

        function obj = applyCond(fixNod)

            vR = zeros(size(fixNod,1),1);
            uR = zeros(size(fixNod,1),1);
            v = linspace(1,16,16);

            for i = 1:size(fixNod,1)
                a = fixNod(i,1);
                b = fixNod(i,2);

                if (mod(b,2)==0)
                    vR(i,1) = 2*a;
                    uR(i,1) = fixNod(i,3);

                else
                    vR(i,1) = 2*a-1;
                    uR(i,1) = fixNod(i,3);
                end

            end

            vL = setdiff(v,vR);

            obj.vL = vL;
            obj.vR = vR;
            obj.uR = uR;

        end

    end

end