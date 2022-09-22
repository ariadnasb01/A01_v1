classdef ForcesComputer < handle

    properties (Access = public)
        forcesExt
    end

    properties (Access = private)
        nDofTotal
        Fdata
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
            obj.nDofTotal = cParams.nDofTotal;
            obj.Fdata = cParams.Fdata;
        end


        function Fext = computeF(obj)
            nDofTotal = obj.nDofTotal;
            Fdata = obj.Fdata;

            Fext = zeros(nDofTotal, 1);

            for i = 1:length(Fdata)
                m = Fdata(i,1);
                n = Fdata(i,2);

                if mod(n,2)==0
                    Fext(m*2,1) = Fdata(i,3);
                else
                    Fext(m*2-1,1) = Fdata(i,3);
                end

            end

        end

   end

end