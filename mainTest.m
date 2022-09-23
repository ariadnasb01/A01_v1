
clc;
clear;
close all;

%% INPUT DATA

expRes = load('exactSolution.mat');

test = testClass(expRes);
test.check();