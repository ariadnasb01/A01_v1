function Td = connectDOFs(n_el,n_nod,n_i,Tn)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_el     Total number of elements
%                  n_nod    Number of nodes per element
%                  n_i      Number of DOFs per node
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - Td    DOFs connectivities table [n_el x n_el_dof]
%            Td(e,i) - DOF i associated to element e
%--------------------------------------------------------------------------
% Hint: Use the relation between the DOFs numbering and nodal numbering.

Td = zeros(n_el, n_nod*n_i);

for i = 1:4
    Td(:,1) = 2*Tn(:,1)-1;
    Td(:,3) = 2*Tn(:,2)-1;
    Td(:,2) = 2*Tn(:,1);
    Td(:,4) = 2*Tn(:,2);
end

end