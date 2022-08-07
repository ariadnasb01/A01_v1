classdef dimension < handle 
    properties
        n_d       % Number of dimensions
        n_i       % Number of DOFs for each node
        n         % Total number of nodes
        n_dof     % Total number of degrees of freedom
        n_el      % Total number of elements
        n_nod     % Number of nodes for each element
        n_el_dof  % Number of DOFs for each element
    end

    methods (Access = public, Static)
        function obj = setDimension (x, Tn)
            obj.n_d = size(x,2);
            obj.n_i = obj.n_d;
            obj.n = size(x,1);
            obj.n_dof = obj.n_i*obj.n;
            obj.n_el = size(Tn,1);  
            obj.n_nod = size(Tn,2); 
            obj.n_el_dof = obj.n_i*obj.n_nod; 
        end
    end
end