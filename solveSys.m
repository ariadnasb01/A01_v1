function [u,R] = solveSys(vL,vR,uR,KG,Fext)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - vL      Free degree of freedom vector
%   - vR      Prescribed degree of freedom vector
%   - uR      Prescribed displacement vector
%   - KG      Global stiffness matrix [n_dof x n_dof]
%              KG(I,J) - Term in (I,J) position of global stiffness matrix
%   - Fext    Global force vector [n_dof x 1]
%              Fext(I) - Total external force acting on DOF I
%--------------------------------------------------------------------------
% It must provide as output:
%   - u       Global displacement vector [n_dof x 1]
%              u(I) - Total displacement on global DOF I
%   - R       Global reactions vector [n_dof x 1]
%              R(I) - Total reaction acting on global DOF I
%--------------------------------------------------------------------------

KLL = KG(vL, vL);
KLR = KG(vL, vR);
KRL = KG(vR, vL);
KRR = KG(vR, vR);
FL = Fext(vL, 1);
FR = Fext(vR, 1);

uL = inv(KLL)*(FL-KLR*uR);
RR = KRR*uR+KRL*uL-FR;

u(vL,1) = uL;
u(vR,1) = uR;

R(vL,1) = 0;
R(vR,1) = RR;

Fx = 0.0; Fy = 0.0; Rx = 0.0; Ry = 0.0;

for i = 1:length(Fext)
    if mod(i,2)==0
        Fy = Fext(i,1)+Fy;
        Ry = Ry+R(i,1);
    else
        Fx = Fext(i,1)+Fx;
        Rx = Rx+R(i,1);
    end
end

if Rx-Fx<=10^-5 && Ry-Fy<=10^-5
    fprintf('The structure presents equilibrium.\n\n');
else
    fprintf('The structure does not present equilibrium.\n\n');
end

end

% prova