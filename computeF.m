classdef computeF < handle

%     properties
%         ForcesExt
%     end

    methods (Access = public, Static)

        function Fext = calculate(n_dof,Fdata)

            Fext = zeros(n_dof, 1);

            for i = 1:length(Fdata)
                m = Fdata(i,1);
                n = Fdata(i,2);

                if mod(n,2)==0
                    Fext(m*2,1) = Fdata(i,3);

                else
                    Fext(m*2-1,1) = Fdata(i,3);
                end

            end

%             obj.ForcesExt = Fext;

        end

    end

end