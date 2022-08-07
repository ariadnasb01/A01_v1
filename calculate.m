classdef calculate < handle
    properties (Access = public)
        datas
        dimensions
        type
        nodalConnect
        KElementalMatrix
        KGlobalMatrix
        ForcesExt
        FreeDOF
        FixDOF
        FixDispl
        displacements
        reactions
        strain
        stress
    end

    properties (Access = private)
        %datas
    end

    methods (Access = public)

        function obj = calculate(F, Young, Area, thermalCoeff, Inertia, type)
            obj.getAllData(F, Young, Area, thermalCoeff, Inertia, type);
            obj.connectDOFs;
            obj.computeKelBar;
            obj.assemblyKG;
            obj.computeF;
            obj.applyCond;
            obj.solve;
            obj.computeStrainStressBar;
        end

    end

    methods (Access = private)

        function getAllData(obj, F, Young, Area, thermalCoeff, Inertia, type)
            obj.datas = data.setData(F, Young, Area, thermalCoeff, Inertia);
            obj.dimensions = dimension.setDimension(obj.datas.x, obj.datas.Tn);
            obj.type = type;
        end


        function connectDOFs(obj)
            n_el = obj.dimensions.n_el;
            n_nod = obj.dimensions.n_nod;
            n_i = obj.dimensions.n_i;
            Tn = obj.datas.Tn;
            
            Td = connectDOFs(n_el,n_nod,n_i,Tn);
            obj.nodalConnect = Td.nodalConnect;
        end


        function computeKelBar(obj)
            n_d = obj.dimensions.n_d;
            n_el = obj.dimensions.n_el;
            x = obj.datas.x;
            Tn = obj.datas.Tn;
            mat = obj.datas.mat;
            Tmat = obj.datas.Tmat;

            Kel = computeKelBar(n_d,n_el,x,Tn,mat,Tmat);
            obj.KElementalMatrix = Kel.KElementalMatrix;

        end


        function assemblyKG(obj)
            n_el = obj.dimensions.n_el;
            n_el_dof = obj.dimensions.n_el_dof;
            n_dof = obj.dimensions.n_dof;
            Td = obj.nodalConnect;
            Kel = obj.KElementalMatrix;

            KG = assemblyKG(n_el,n_el_dof,n_dof,Td,Kel);
            obj.KGlobalMatrix = KG.KGlobalMatrix;

        end


        function computeF(obj)
            n_dof = obj.dimensions.n_dof;
            Fdata = obj.datas.Fdata;

            Fext = computeF.calculate(n_dof, Fdata);
            obj.ForcesExt = Fext; %.ForcesExt;

        end


        function applyCond(obj)
            fixNod = obj.datas.fixNod;

            DisplAndDOFs = applyCond(fixNod);

            obj.FreeDOF = DisplAndDOFs.vL;
            obj.FixDOF = DisplAndDOFs.vR;
            obj.FixDispl = DisplAndDOFs.uR;

        end


        function solve(obj)
            vL = obj.FreeDOF;
            vR = obj.FixDOF;
            uR = obj.FixDispl;
            KG = obj.KGlobalMatrix;
            Fext = obj.ForcesExt;
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