function [localMaps,localMapTimeMean,localMapTimeMedian]=localMapComputing(network,radius,option)

%This function computes local maps for a given network
%Input:
%network - the deployed sensor network
%connectivityLevels - the selected radio radius that we would compute maps against
%option -
%   0/1: cca range free/cca range based option;
%   2: cca grid range free;
%   3: mds grid range free
%output:
%  localMaps - computed local maps for the given each radius level
%  localMapTimeMean - the average computing time 

fprintf(1,'Calculating local map for radius %0.2f\n',radius);
if option==0 % cca range free
    localMaps{1}=localMapConnectivityOnly(network,100,radius);
end
if option==1 % cca range based
    localMaps{1}=vitUpdateLocalMapLocalization(network,100,radius);
end
if option==2 % cca grid range free. if use one level of LEM, use localMapConnectivityOnlyGrid1
    localMaps{1}=localMapConnectivityOnlyGrid(network,100,radius);
end
if option==3 %range free mds grid
    localMaps{1}=MDSLocalMapConnectivityOnlyGrid(network,radius);
end

%% Calculate Local Map Error
% error is the average of the distance error of each node
for k=1:size(network.points,1)
    
end

%% Calculate computation time
localMapTimeMean = mean([localMaps{1}(:).local_map_compuTime],2);
localMapTimeMedian = median([localMaps{1}(:).local_map_compuTime],2);
