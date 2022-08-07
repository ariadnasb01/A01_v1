classdef connectDOFs < handle

    properties
        nodalConnect
    end

    methods (Access = public)

        function obj = connectDOFs(n_el,n_nod,n_i,Tn)
            
            Td = zeros(n_el, n_nod*n_i);

            for i = 1:4
                Td(:,1) = 2*Tn(:,1)-1;
                Td(:,3) = 2*Tn(:,2)-1;
                Td(:,2) = 2*Tn(:,1);
                Td(:,4) = 2*Tn(:,2);
            end

            obj.nodalConnect = Td;

        end

    end

end