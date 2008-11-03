function [patchTime,coordinates_median,coordinates_median_average,allResults]=mapPatch(network, radiusNet,startNode,anchor,CL_all)
%This function patches local maps into the global map for all the local maps
%computed for each radius value stored in the radiusNet.
%input:
%network - Nx2 matrix of the network
%radiusNet - computed using localMapComputing.m
%startNode - 1xM matrix containing M starting nodes that want to be
%experimented with
%anchor - SxT matrix containing S anchor sets that want to be experimented
%with. Each anchor set has T anchor nodes. 

node=startNode

sn=size(startNode,2);%number of starting nodes   
an=size(anchor,2); %number of anchor nodes
asn=size(anchor,1); %nubmer of anchor sets for testing
cl=size(radiusNet,2); %number of radius levels computed

for jj=1:sn % for each starting node
  disp('++++ Starting Node ' + jj)
  for ii=1:cl %for each radius level
    disp('++++ Radius Level ' + ii)
    for kk=1:asn % for each anchor set
        disp('++++ Anchor Node ' + kk)
%       radiusNet{ii}(1).radius=CL_all(1,ii);
        radiusNet{ii}=mapVitPatch(network,radiusNet{ii},node(jj),anchor(kk,:),radiusNet{ii}(1).radius)
        radiusNet{ii}(node(jj))
        A(kk)=(radiusNet{ii}(node(jj)).patched_net_coordinates_error_median(1)+...,
            radiusNet{ii}(node(jj)).patched_net_coordinates_error_median(2))/2
        T(kk)=radiusNet{ii}(node(jj)).map_patchTime;
    end

    allResults(ii,:,jj)=A;
    patchTime(jj,ii)=median(T')
    % A=A(1:3);
    coordinates_median(jj,ii)=median(A')
    coordinates_median_average(jj,ii)=mean(A')

    clear A;
    clear T;
  end %for ii
end %for jj 

