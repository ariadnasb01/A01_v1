
clc;
clear;
close all;

%% INPUT DATA

type = "iterative"; % solver used: direct or iterative

F = 920; % [N]
Young = 75000e6; % [Pa]
Area = 120e-6; % [m^2]
thermalCoeff = 23e-6; % [K^(-1)]
Inertia = 1400e-12; % [m^4]



s.F = F;
s.Young = Young;
s.Area = Area...
structComputer = StructuralComputer(s);
structComputer.compute();

Solution = calculate(F, Young, Area, thermalCoeff, Inertia, type);

test = testClass(Solution);


% loop in Tests
% classes names, functions are verbs,
% minimize inputs in classes (cParams, init,...)
% compose classes with classes
% decompose tests by classes
