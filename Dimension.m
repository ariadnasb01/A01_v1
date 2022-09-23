classdef Dimension < handle 

    properties (Access = public)
        nDim        % Number of dimensions
        nDofNode    % Number of DOFs for each node
        nNode       % Total number of nodes
        nDofTotal   % Total number of degrees of freedom
        nElem       % Total number of elements
        nNodeElem   % Number of nodes for each element
        nDofElem    % Number of DOFs for each element
    end

    methods (Access = public, Static)

        function obj = setDimension (datas)
            x  = datas.nodalCoordinates;
            Tn = datas.nodalConnectivities;

            obj.nDim        = size(x,2);
            obj.nDofNode    = obj.nDim;
            obj.nNode       = size(x,1);
            obj.nDofTotal   = obj.nDofNode*obj.nNode;
            obj.nElem       = size(Tn,1);  
            obj.nNodeElem   = size(Tn,2); 
            obj.nDofElem    = obj.nDofNode*obj.nNodeElem; 
        end

    end
    
end