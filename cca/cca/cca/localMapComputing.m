function [localMaps,localMapTimeMean,localMapTimeMedian]=localMapComputing(network,connectivityLevels,option)

%This function computes local maps for a given network
%Input:
%network - the deployed sensor network 
%connectivityLevels - the selected radio radius that we would compute maps against
%option - 
%   0/1: cca range free/cca range based option; 
%   2: cca grid range free; 
%   3: mds grid range free
%output:
%  localMaps{} - cell of computed local maps for each radius levels given in connectivityLevels;
%  localMapTimeMean - the average computing time for each local map at each
%  different radius levels as given in connectivityLevels

numberOfLevels=size(connectivityLevels,2);
for i = 1:numberOfLevels
  radius=connectivityLevels(1,i);
  if option==0 % cca range free
    localMaps{i}=localMapConnectivityOnly(network,100,radius);
  end
  if option==1 % cca range based
    localMaps{i}=vitUpdateLocalMapLocalization(network,100,radius);
  end
  if option==2 % cca grid range free. if use one level of LEM, use localMapConnectivityOnlyGrid1
    localMaps{i}=localMapConnectivityOnlyGrid(network,100,radius);
  end
  if option==3 %range free mds grid
    localMaps{i}=MDSLocalMapConnectivityOnlyGrid(network,radius);
  end
end


%calculate the compute time
numberOfNodes=size(network,1);
localMapTimeMean=zeros(numberOfLevels);
localMapTimeMedian=zeros(numberOfLevels);
for i=1:numberOfLevels
    computationTime=zeros(numberOfNodes,1);
    for j=1:numberOfNodes
        computationTime(j) = localMaps{i}(j).local_map_compuTime;
    end
    localMapTimeMean(i) = mean(computationTime,1);
    localMapTimeMedian(i) = median(computationTime,1);
    clear computationTime;
end
