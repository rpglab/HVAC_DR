% This work is under the open license of the Creative Commons Attribution 4.0 (CC BY 4.0) license.
%    https://rpglab.github.io/resources/HVAC_DR/
%
% If you use this code or part of the code, please cite the following paper
%
%   Praveen Dhanasekar, Cunzhi Zhao and Xingpeng Li, "Quantitative Analysis
%   of Demand Response Using Thermostatically Controlled Loads", IEEE PES
%   Innovative Smart Grid Technology, New Orleans, LA, USA, Apr. 2022. 
%
%   https://rpglab.github.io/papers/Praveen-CunzhiZhao-ISGT-TCL-DR-MG/
%

% Start of the program
% Initialize basic parameters

clc;
clear;
tic;
fid = fopen('InitializationStructure.txt');
baseParameters = textscan(fid, '%q %q %q %q %q %q %q %q  %q %q %q %q %q %q %q %q' , 'delimiter', '\n');
baseData = struct( 'Number_of_houses', str2double(baseParameters{1}) , 'ThermalResistanceUpperLimit' , str2double(baseParameters{2}) ,'ThermalResistanceLowerLimit' , str2double(baseParameters{3}) , 'KW_ratings_of_HVAC' ,baseParameters{4} , 'Temp_deadband' , str2double(baseParameters{5}) , 'InternalTemperatureUpperLimit' , str2double(baseParameters{6}), 'InternalTemperatureLowerLimit'  , str2double(baseParameters{7}) , 'HeatRateUpperLimit' , str2double(baseParameters{8}), 'HeatRateLowerLimit' , str2double(baseParameters{9}), 'HeatOutRateUpperLimit' , str2double(baseParameters{10}) , 'HeatOutRateLowerLimit' , str2double(baseParameters{11}) , 'AirHeatUpperLimit' , str2double(baseParameters{12}), 'AirHeatLowerLimit' , str2double(baseParameters{13}),  'TempSetUpperLimit' , str2double(baseParameters{14}), 'TempSetLowerLimit' , str2double(baseParameters{15}) , 'simulationTimeinMin' , (1*60),'DRStartTime' , str2double(baseParameters{16}) ); %,'Hours' , str2double(baseParameters{5}) ,'Interval' , str2double(baseParameters{6})
fclose(fid);
msg= TemperatureInitializationMode.startTemperatureSimulation(baseData);
timeE=toc;
timeElapsed= toc;
