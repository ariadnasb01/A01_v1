classdef ForcesComputer < handle

    properties (Access = public)
        forcesExt
    end

    properties (Access = private)
        nDofTotal
        forcesData
    end

    methods (Access = public)
        
        function obj = ForcesComputer(cParams)
            obj.init(cParams);
        end

        function Fext = compute(obj)
            Fext = obj.computeF();
        end

    end 

    methods (Access = private)

        function init(obj,cParams)
            obj.nDofTotal  = cParams.nDofTotal;
            obj.forcesData = cParams.forcesData;
        end

        function Fext = computeF(obj)
            nDofT = obj.nDofTotal;
            F     = obj.forcesData;

            Fext = zeros(nDofT, 1);
            for iDOF = 1:length(F)
                m = F(iDOF,1);
                n = F(iDOF,2);
                if mod(n,2)==0
                    Fext(m*2,1) = F(iDOF,3);
                else
                    Fext(m*2-1,1) = F(iDOF,3);
                end
            end
        end

    end
    
end