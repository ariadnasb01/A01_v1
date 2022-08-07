
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


Solution = calculate(F, Young, Area, thermalCoeff, Inertia, type);

test = testClass(Solution);

