classdef StrainStressBarComputer < handle

    properties (Access = public)
        strain
        stress
    %end

    %properties (Access = private)
        dimensions
        datas
        nodalConnect
        displacements
    end

    methods (Access = public)

        function obj = StrainStressBarComputer(cParams)
            obj.init(cParams);
        end
        
        function compute(obj)
            obj.computeStrainStressBar();
        end

    end

    methods (Access = private)

        function init(obj,cParams)
            obj.dimensions = cParams.dimensions;
            obj.datas = cParams.datas;
            obj.nodalConnect = cParams.nodalConnect;
            obj.displacements = cParams.displacements;
        end
        
        function computeStrainStressBar(obj)
            nDim = obj.dimensions.nDim;
            nElem = obj.dimensions.nElem;
            u = obj.displacements;
            Td = obj.nodalConnect;
            x = obj.datas.x;
            Tn = obj.datas.Tn;
            mat = obj.datas.mat;
            Tmat = obj.datas.Tmat;

            for e = 1:nElem
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
                
                for i = 1:2*nDim
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