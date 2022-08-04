classdef data
    properties
        x
        Tn
        Fdata
        fixNod
        mat
        Tmat
    end

    methods (Access = public, Static)
        function obj = setData (F, Young, Area, thermalCoeff, Inertia)
            obj.x = [0 0
                    0.5 0.2
                    1 0.4
                    1.5 0.6
                    0 0.5
                    0.5 0.6
                    1 0.7
                    1.5 0.8];

            obj.Tn = [1 2
                    2 3
                    3 4
                    5 6
                    6 7
                    7 8
                    1 5
                    1 6
                    2 5
                    2 6
                    2 7
                    3 6
                    3 7
                    3 8
                    4 7
                    4 8];

            obj.Fdata = [2 2 3*F
                    3 2 2*F
                    4 2 F];

            obj.fixNod = [1 1 0
                    1 2 0
                    5 1 0
                    5 2 0];

            obj.mat = [Young, Area, thermalCoeff, Inertia;
                    ];

            obj.Tmat = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];

        end
    end


end