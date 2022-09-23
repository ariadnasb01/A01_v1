classdef StiffnesMatrixAssembler < handle

    properties (Access = public)
        kElementalMatrix
        kGlobalMatrix
    end

    properties (Access = private)
        dimensions
        datas
        nodalConnect
    end

    methods (Access = public)
        
        function obj = StiffnesMatrixAssembler(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.computeKElem();
            obj.computeKGlob();
        end
    end

    methods (Access = private)

        function init(obj,cParams)
            obj.dimensions   = cParams.dimensions;
            obj.datas        = cParams.datas;
            obj.nodalConnect = cParams.nodalConnect;
        end

        function computeKElem(obj)
            nDim    = obj.dimensions.nDim;
            nElem   = obj.dimensions.nElem;
            Tn      = obj.datas.nodalConnectivities;
            x       = obj.datas.nodalCoordinates;
            mat     = obj.datas.materialProperties;
            Tmat    = obj.datas.materialTable;

            Kel = zeros(nDim, nDim, nElem);
            for eElem = 1:nElem
                x1     = x(Tn(eElem,1),1);
                y1     = x(Tn(eElem,1),2);
                x2     = x(Tn(eElem,2),1);
                y2     = x(Tn(eElem,2),2);
                length = sqrt((x2-x1)^2+(y2-y1)^2);
                s      = (y2-y1)/length;
                c      = (x2-x1)/length;

                K = (mat(Tmat(eElem),1)*mat(Tmat(eElem),2)/length)*[c^2 c*s -c^2 -c*s
                    c*s s^2 -c*s -s^2
                    -c^2 -c*s c^2 c*s
                    -c*s -s^2 c*s s^2];
                for r = 1:nDim*2
                    for s = 1:nDim*2
                        Kel(r,s,eElem) = K(r,s);
                    end
                end
            end
            obj.kElementalMatrix = Kel;
        end

        function computeKGlob(obj)
            nDofTotal   = obj.dimensions.nDofTotal;
            nElem       = obj.dimensions.nElem;
            nDofElem    = obj.dimensions.nDofElem;
            Kel         = obj.kElementalMatrix;
            Td          = obj.nodalConnect;

            KG          = zeros(nDofTotal, nDofTotal);
            for eElem = 1:nElem
                for iDOF = 1:nDofElem
                    I = Td(eElem,iDOF);
                    for jDOF = 1:nDofElem
                        J = Td(eElem,jDOF);
                        KG(I,J) = KG(I,J)+Kel(iDOF,jDOF,eElem);
                    end
                end
            end            
            obj.kGlobalMatrix = KG;
        end

    end
    
end