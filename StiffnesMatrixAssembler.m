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
            obj.dimensions = cParams.dimensions;
            obj.datas = cParams.datas;
            obj.nodalConnect = cParams.nodalConnect;
        end


        function computeKElem(obj)
            nDim = obj.dimensions.nDim;
            nElem = obj.dimensions.nElem;
            Tn = obj.datas.Tn;
            x = obj.datas.x;
            mat = obj.datas.mat;
            Tmat = obj.datas.Tmat;

            Kel = zeros(nDim, nDim, nElem);

            for e = 1:nElem
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

                for r = 1:nDim*2
                    for s = 1:nDim*2
                        Kel(r,s,e) = K(r,s);
                    end
                end

            end

            obj.kElementalMatrix = Kel;

        end

        function computeKGlob(obj)
            nDofTotal = obj.dimensions.nDofTotal;
            nElem = obj.dimensions.nElem;
            nDofElem = obj.dimensions.nDofElem;
            Kel = obj.kElementalMatrix;
            Td = obj.nodalConnect;

            KG = zeros(nDofTotal, nDofTotal);

            for e = 1:nElem
            
                for i = 1:nDofElem
                    I = Td(e,i);
                
                    for j = 1:nDofElem
                        J = Td(e,j);
                        KG(I,J) = KG(I,J)+Kel(i,j,e);
                    end
                
                end

            end            

            obj.kGlobalMatrix = KG;
        end

    end

end