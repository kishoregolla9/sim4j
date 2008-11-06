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
%  localMapTimeMean - the average computing time for each local map at each different radius levels as given in connectivityLevels

nn=size(connectivityLevels,2);
for ii=1:nn
radius=connectivityLevels(1,ii);
if option==1 %cca range based
    localMaps{ii}=vitUpdateLocalMapLocalization(network,100,radius);
end
if option==0 %cca range free
    localMaps{ii}=localMapConnectivityOnly(network,100,radius);
end

if option==2 %cca grid range free. if use one level of LEM, use localMapConnectivityOnlyGrid1
    localMaps{ii}=localMapConnectivityOnlyGrid(network,100,radius);
end

if option==3 %range free mds grid
    localMaps{ii}=MDSLocalMapConnectivityOnlyGrid(network,radius);
end
end


%calculate the compute time
net_size=size(network,1);
for ii=1:nn
    computationTime=zeros(net_size,1);
    for jj=1:net_size
        computationTime(jj)=localMaps{ii}(jj).local_map_compuTime
    end
    computationTime
    computationTime'
    localMapTimeMean(ii)=mean(computationTime');
    localMapTimeMedian(ii)=median(computationTime');
    clear computationTime;
end