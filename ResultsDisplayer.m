classdef ResultsDisplayer < handle

    properties (Access = public)
        table1
        table2
    end

    properties (Access = private)
        results
    end

    methods (Access = public)

        function obj = ResultsDisplayer(cParams)
            obj.init(cParams);
        end

        function show (obj)
            obj.displayResults();
        end

    end

    methods (Access = private)

        function init(obj,cParams)
            obj.results = cParams;
        end

        function displayResults(obj)
            S = obj.results;
            names = fieldnames(S);
            for i = 1:length(names)
                res(i) = S.(names{i});
            end
            for i = 1:length(names)
                if (res(i)==1)
                    disp("Test passed:")
                    disp(names(i))
                else
                    disp("Test not passed:")
                    disp(names(i))
                end
            end
        end

    end

end