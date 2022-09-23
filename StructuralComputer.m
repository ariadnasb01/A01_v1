classdef StructuralComputer < handle
    
    properties (Access = public)
        kElementalMatrix
        kGlobalMatrix
        forcesExt
        freeDOF
        fixDOF
        fixDispl
        displacements
    end

    properties (Access = private)
        datas
        dimensions
        type
        nodalConnect
        reactions
        strain
        stress
    end

    methods (Access = public)

        function obj = StructuralComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.computeConnectivities();
            obj.assemblyStiffnesMatrix();
            obj.computeForces();
            obj.computeDisplacements();
            obj.computeStrainStressBar;
        end

    end

    methods (Access = private)
        
        function init(obj,cParams)
            obj.datas      = Data.setData(cParams);
            obj.dimensions = Dimension.setDimension(obj.datas);
            obj.type       = cParams.type;
        end

        function computeConnectivities(obj)
            s.dimensions          = obj.dimensions;
            s.nodalConnectivities = obj.datas.nodalConnectivities;
            s.fixedNodes          = obj.datas.fixedNodes;
            c = ConnectivitiesComputer(s);
            c.compute();
            obj.nodalConnect = c.DOFsConnectivities;
            obj.freeDOF      = c.freeDOF;
            obj.fixDOF       = c.fixDOF;
            obj.fixDispl     = c.fixDispl;
        end

        function assemblyStiffnesMatrix(obj)
            s.dimensions   = obj.dimensions;
            s.datas        = obj.datas;
            s.nodalConnect = obj.nodalConnect;
            k = StiffnesMatrixAssembler(s);
            k.compute();
            obj.kElementalMatrix = k.kElementalMatrix;
            obj.kGlobalMatrix    = k.kGlobalMatrix;
        end

        function computeForces(obj)
            s.nDofTotal  = obj.dimensions.nDofTotal;
            s.forcesData = obj.datas.forcesData;
            f = ForcesComputer(s);
            Fext = f.compute();
            obj.forcesExt = Fext;
        end

        function computeDisplacements(obj)
            s.vL         = obj.freeDOF;
            s.vR         = obj.fixDOF;
            s.uR         = obj.fixDispl;
            s.KG         = obj.kGlobalMatrix;
            s.Fext       = obj.forcesExt;
            s.solverType = obj.type;
            sol = DisplacementReactionComputer(s);
            sol.compute();
            obj.displacements = sol.displacement;
            obj.reactions     = sol.reaction;
        end

        function computeStrainStressBar(obj)
            s.dimensions    = obj.dimensions;
            s.datas         = obj.datas;
            s.nodalConnect  = obj.nodalConnect;
            s.displacements = obj.displacements;
            StrainStress = StrainStressBarComputer(s);
            StrainStress.compute();
            obj.strain = StrainStress.strain;
            obj.stress = StrainStress.stress;
        end
    end
end