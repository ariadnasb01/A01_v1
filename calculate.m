classdef StructuralComputer < handle
   
    properties (Access = public)
        kElementalMatrix
        kGlobalMatrix
        forcesExt
        freeDOF
        FixDOF
        FixDispl
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
            obj.computeKelBar();
            obj.assemblyStiffnesMatrix();
            obj.computeForces();
            obj.applyBoundaryConditions();
            obj.solve;
            obj.computeStrainStressBar;
        end

    end

    methods (Access = private)

        function init(obj,cParams)

        end

        function getAllData(obj, F, Young, Area, thermalCoeff, Inertia, type)
            obj.datas = data.setData(F, Young, Area, thermalCoeff, Inertia);
            obj.dimensions = dimension.setDimension(obj.datas.x, obj.datas.Tn);
            obj.type = type;
        end


        function computeConnectivities(obj)
            nElem  = obj.dimensions.n_el;
            nNodes = obj.dimensions.n_nod;
            nDim   = obj.dimensions.n_i;
            Tn     = obj.datas.Tn;
            
            s.dimensions = obj.dimensions;
            c = ConnectivitiesComputer(s);
            T = c.compute();
            obj.nodalConnect = T;
        end


        function computeKelBar(obj)
            n_d = obj.dimensions.n_d;
            n_el = obj.dimensions.n_el;
            x = obj.datas.x;
            Tn = obj.datas.Tn;
            mat = obj.datas.mat;
            Tmat = obj.datas.Tmat;

            Kel = computeKelBar(n_d,n_el,x,Tn,mat,Tmat);
            obj.kElementalMatrix = Kel.KElementalMatrix;

        end


        function assemblyKG(obj)
            n_el = obj.dimensions.n_el;
            n_el_dof = obj.dimensions.n_el_dof;
            n_dof = obj.dimensions.n_dof;
            Td = obj.nodalConnect;
            Kel = obj.kElementalMatrix;

            KG = assemblyKG(n_el,n_el_dof,n_dof,Td,Kel);
            obj.kGlobalMatrix = KG.KGlobalMatrix;

        end


        function computeF(obj)
            n_dof = obj.dimensions.n_dof;
            Fdata = obj.datas.Fdata;

            Fext = computeF.calculate(n_dof, Fdata);
            obj.forcesExt = Fext; %.ForcesExt;

        end


        function applyCond(obj)
            fixNod = obj.datas.fixNod;

            DisplAndDOFs = applyCond(fixNod);

            obj.freeDOF = DisplAndDOFs.vL;
            obj.fixDOF = DisplAndDOFs.vR;
            obj.fixDispl = DisplAndDOFs.uR;

        end


        function solve(obj)
            vL = obj.freeDOF;
            vR = obj.FixDOF;
            uR = obj.FixDispl;
            KG = obj.kGlobalMatrix;
            Fext = obj.forcesExt;
            solverType = obj.type;

            [u,R] = Solver.solve(vL,vR,uR,KG,Fext,solverType);
            
            obj.displacements = u;
            obj.reactions = R;

        end


        function computeStrainStressBar(obj)
            n_d = obj.dimensions.n_d;
            n_el = obj.dimensions.n_el;
            u = obj.displacements;
            Td = obj.nodalConnect;
            x = obj.datas.x;
            Tn = obj.datas.Tn;
            mat = obj.datas.mat;
            Tmat = obj.datas.Tmat;

            StrainStress = computeStrainStressBar(n_d,n_el,u,Td,x,Tn,mat,Tmat);

            obj.strain = StrainStress.strain;
            obj.stress = StrainStress.stress;

        end

    end

end