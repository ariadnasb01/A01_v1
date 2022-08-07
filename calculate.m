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
            
            Td = zeros(n_el, n_nod*n_i);
            for i = 1:4
                Td(:,1) = 2*Tn(:,1)-1;
                Td(:,3) = 2*Tn(:,2)-1;
                Td(:,2) = 2*Tn(:,1);
                Td(:,4) = 2*Tn(:,2);
            end

            obj.nodalConnect = Td;
            
        end


        function computeKelBar(obj)
            n_el = obj.dimensions.n_el;
            n_d = obj.dimensions.n_d;
            x = obj.datas.x;
            Tn = obj.datas.Tn;
            mat = obj.datas.mat;
            Tmat = obj.datas.Tmat;

            Kel = zeros(n_d, n_d, n_el);
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

            obj.KElementalMatrix = Kel;

        end


        function assemblyKG(obj)
            n_el = obj.dimensions.n_el;
            n_el_dof = obj.dimensions.n_el_dof;
            n_dof = obj.dimensions.n_dof;
            Td = obj.nodalConnect;
            Kel = obj.KElementalMatrix;

            KG = zeros(n_dof, n_dof);
            for e = 1:n_el
                for i = 1:n_el_dof
                    I = Td(e,i);
                    for j = 1:n_el_dof
                        J = Td(e,j);
                        KG(I,J) = KG(I,J)+Kel(i,j,e);
                    end
                end
            end

            obj.KGlobalMatrix = KG;

        end


        function computeF(obj)
            n_dof = obj.dimensions.n_dof;
            Fdata = obj.datas.Fdata;

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

            obj.ForcesExt = Fext;

        end


        function applyCond(obj)
            fixNod = obj.datas.fixNod;

            vR = zeros(size(fixNod,1),1);
            uR = zeros(size(fixNod,1),1);
            v = linspace(1,16,16);
            for i = 1:size(fixNod,1)
                a = fixNod(i,1);
                b = fixNod(i,2);
                if (mod(b,2)==0)
                    vR(i,1) = 2*a;
                    uR(i,1) = fixNod(i,3);
                else
                    vR(i,1) = 2*a-1;
                    uR(i,1) = fixNod(i,3);
                end
            end
            vL = setdiff(v,vR);

            obj.FreeDOF = vL;
            obj.FixDOF = vR;
            obj.FixDispl = uR;

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

            for e = 1:n_el
                x1 = x(Tn(e,1),1);
                y1 = x(Tn(e,1),2);
                x2 = x(Tn(e,2),1);
                y2 = x(Tn(e,2),2);
                l = sqrt((x2-x1)^2+(y2-y1)^2);
                s = (y2-y1)/l;
                c = (x2-x1)/l;
            
                R = [c s 0 0
                    -s c 0 0
                    0 0 c s
                    0 0 -s c];
                
                for i = 1:2*n_d
                    I = Td(e,i);
                    u1(i,1) = u(I);
                end
                
                u2 = R*u1;
                eps(e,1) = 1/l*[-1 0 1 0]*u2;
                sig(e,1) = mat(Tmat(e),1)*eps(e,1);
            end

            obj.strain = eps;
            obj.stress = sig;

        end

    end

end