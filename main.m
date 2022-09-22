
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
s.Area = Area;
s.thermalCoeff = thermalCoeff;
s.Inertia = Inertia;
s.type = type;

structComputer = StructuralComputer(s);
structComputer.compute();




 test = testClass(structComputer);
 test.check();


% loop in Tests (test la Kel tot i que la faci servir pels desplaçaments,
% etc)
% classes names, functions are verbs,
% minimize inputs in classes (cParams, init,...)
% compose classes with classes
% decompose tests by classes

