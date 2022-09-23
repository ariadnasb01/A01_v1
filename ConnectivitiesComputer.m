classdef ConnectivitiesComputer < handle

    properties (Access = public)
        DOFsConnectivities
        freeDOF
        fixDOF
        fixDispl
    end

    properties (Access = private)
        dimensions
        nodalConnectivities
        fixedNodes
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
            obj.dimensions          = cParams.dimensions;
            obj.nodalConnectivities = cParams.nodalConnectivities;
            obj.fixedNodes          = cParams.fixedNodes;
        end

        function computeConnect(obj)
            nElem       = obj.dimensions.nElem;
            nNodeElem   = obj.dimensions.nNodeElem;
            nDofNode    = obj.dimensions.nDofNode;
            Tn          = obj.nodalConnectivities;

            Td = zeros(nElem, nNodeElem*nDofNode);
            for i = 1:4
                Td(:,1) = 2*Tn(:,1)-1;
                Td(:,3) = 2*Tn(:,2)-1;
                Td(:,2) = 2*Tn(:,1);
                Td(:,4) = 2*Tn(:,2);
            end
            obj.DOFsConnectivities = Td;
        end

        function applyBoundaryCond(obj)
            fixNod = obj.fixedNodes;
            vR = zeros(size(fixNod,1),1);
            uR = zeros(size(fixNod,1),1);
            v = linspace(1,16,16);
            for iDOF = 1:size(fixNod,1)
                a = fixNod(iDOF,1);
                b = fixNod(iDOF,2);
                if (mod(b,2)==0)
                    vR(iDOF,1) = 2*a;
                    uR(iDOF,1) = fixNod(iDOF,3);
                else
                    vR(iDOF,1) = 2*a-1;
                    uR(iDOF,1) = fixNod(iDOF,3);
                end
            end
            vL = setdiff(v,vR);
            
            obj.freeDOF = vL;
            obj.fixDOF = vR;
            obj.fixDispl = uR;
        end
        
    end

end