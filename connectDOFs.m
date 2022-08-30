classdef ConnectivitiesComputer < handle

    properties (Access = private)
        dimensions
    end

    methods (Access = public)

        function obj = ConnectivitiesComputer(cParams)
            obj.init(cParams)
        end

   
        function Td = compute(obj)
            n_el = obj.dimensions.n_el;
            Td = zeros(n_el, n_nod*n_i);
            for i = 1:4
                Td(:,1) = 2*Tn(:,1)-1;
                Td(:,3) = 2*Tn(:,2)-1;
                Td(:,2) = 2*Tn(:,1);
                Td(:,4) = 2*Tn(:,2);
            end
        end

    end

    methods (Access = private)

        function init(obj,cParams)
         obj.dimensions = cParams.dimensions;
        end
    end

end