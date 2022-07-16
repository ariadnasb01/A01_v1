function Kel = computeKelBar(n_d,n_el,x,Tn,mat,Tmat)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_d        Problem's dimensions
%                  n_el       Total number of elements
%   - x     Nodal coordinates matrix [n x n_d]
%            x(a,i) - Coordinates of node a in the i dimension
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%   - Tmat  Material connectivities table [n_el]
%            Tmat(e) - Material index of element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - Kel   Elemental stiffness matrices [n_el_dof x n_el_dof x n_el]
%            Kel(i,j,e) - Term in (i,j) position of stiffness matrix for element e
%--------------------------------------------------------------------------

%Kel = zeros(n_d, n_d, n_el);

for e = 1:n_el
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
    for r = 1:n_d*2
        for s = 1:n_d*2
            Kel(r,s,e) = K(r,s);
        end
    end
    
end


end