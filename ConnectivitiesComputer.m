classdef ConnectivitiesComputer < handle

    properties (Access = public)
        Td
        vL
        vR
        uR
    end

    properties (Access = private)
        dimensions
        Tn
        fixNod
    end

    methods (Access = public)

        function obj = ConnectivitiesComputer(cParams)
            obj.init(cParams);
        end
        
        function compute(obj)
            obj.computeConnect();
            obj.applyBoundaryCond();
        end

    end

    methods (Access = private)

        function init(obj,cParams)
            obj.dimensions = cParams.dimensions;
            obj.Tn = cParams.Tn;
            obj.fixNod = cParams.fixNod;
        end

        function computeConnect(obj)
            nElem = obj.dimensions.nElem;
            nNodeElem = obj.dimensions.nNodeElem;
            nDofNode = obj.dimensions.nDofNode;
            Tn = obj.Tn;
            
            Td = zeros(nElem, nNodeElem*nDofNode);
            for i = 1:4
                Td(:,1) = 2*Tn(:,1)-1;
                Td(:,3) = 2*Tn(:,2)-1;
                Td(:,2) = 2*Tn(:,1);
                Td(:,4) = 2*Tn(:,2);
            end
            obj.Td = Td;
        end

        function applyBoundaryCond(obj)
            fixNod = obj.fixNod;

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