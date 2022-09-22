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
            obj.solve();
            obj.computeStrainStressBar;
        end

    end

    methods (Access = private)
        
        function init(obj,cParams)
            obj.datas = Data.setData(cParams);
            obj.dimensions = Dimension.setDimension(obj.datas.x, obj.datas.Tn);
            obj.type = cParams.type;
        end

        function computeConnectivities(obj)
            s.dimensions = obj.dimensions;
            s.Tn = obj.datas.Tn;
            s.fixNod = obj.datas.fixNod;
            c = ConnectivitiesComputer(s);
            c.compute();
            obj.nodalConnect = c.Td;
            obj.freeDOF = c.vL;
            obj.fixDOF = c.vR;
            obj.fixDispl = c.uR;
        end

        function assemblyStiffnesMatrix(obj)
            s.dimensions = obj.dimensions;
            s.datas = obj.datas;
            s.nodalConnect = obj.nodalConnect;
            k = StiffnesMatrixAssembler(s);
            k.compute();
            obj.kElementalMatrix = k.kElementalMatrix;
            obj.kGlobalMatrix = k.kGlobalMatrix;
        end

        function computeForces(obj)
            s.nDofTotal = obj.dimensions.nDofTotal;
            s.Fdata = obj.datas.Fdata;
            f = ForcesComputer(s);
            Fext = f.compute();
            obj.forcesExt = Fext;
        end

        function solve(obj)
            s.vL = obj.freeDOF;
            s.vR = obj.fixDOF;
            s.uR = obj.fixDispl;
            s.KG = obj.kGlobalMatrix;
            s.Fext = obj.forcesExt;
            s.solverType = obj.type;
            sol = Solver(s);
            sol.solve();
            obj.displacements = sol.u;
            obj.reactions = sol.R;
        end


        function computeStrainStressBar(obj)
            s.dimensions = obj.dimensions;
            s.datas = obj.datas;
            s.nodalConnect = obj.nodalConnect;
            s.displacements = obj.displacements;

            StrainStress = StrainStressBarComputer(s);
            StrainStress.compute();

            obj.strain = StrainStress.strain;
            obj.stress = StrainStress.stress;
        end

    end

end