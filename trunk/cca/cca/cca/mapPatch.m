function [patchTime,coordinates_median,coordinates_median_average,allResults]=...
    mapPatch(network,localMaps,startNodes,anchorSets)
%This function patches local maps into the global map for all the local maps
%computed for each radius value stored in the localMaps.
%input:
%  network - Nx2 matrix of the network
%  localMaps - computed using localMapComputing.m
%  startNodes - 1xM matrix containing M starting nodes that want to be
%    experimented with
%  anchorSets - SxT matrix containing S anchorSets sets that want to be experimented
%    with. Each anchorSets set has T anchorSets nodes.

node=startNodes
points=network.points;
numStartNodes=size(startNodes,2);%number of starting nodes
numAnchorSets=size(anchorSets,1); %nubmer of anchorSets sets for testing
numRadiusLevels=size(localMaps,2); %number of radius levels computed

for startNodeIndex=1:numStartNodes % for each starting node
    sprintf('++++ Starting Node %i', startNodeIndex)
    for radiusIndex=1:numRadiusLevels %for each radius level
        sprintf('++++ Radius Level %i', radiusIndex)
        A=zeros(numAnchorSets,1);
        times=zeros(numAnchorSets,1);
        for anchorSetIndex=1:numAnchorSets % for each anchorSets set
            sprintf('++++ Anchor Set %i', anchorSetIndex)
            %       localMaps{radiusIndex}(1).radius=connectivityLevels(1,radiusIndex);
            localMaps{radiusIndex}= ...
                mapVitPatch(points,localMaps{radiusIndex},node(startNodeIndex),...
                anchorSets(anchorSetIndex,:),localMaps{radiusIndex}(1).radius);
            localMaps{radiusIndex}(node(startNodeIndex))
            A(anchorSetIndex)=...
                (localMaps{radiusIndex}(node(startNodeIndex)).patched_net_coordinates_error_median(1)+...,
                localMaps{radiusIndex}(node(startNodeIndex)).patched_net_coordinates_error_median(2))/2
            times(anchorSetIndex)=localMaps{radiusIndex}(node(startNodeIndex)).map_patchTime;
        end

        allResults(radiusIndex,:,startNodeIndex)=A;
        patchTime(startNodeIndex,radiusIndex)=median(times')
        % A=A(1:3);
        coordinates_median(startNodeIndex,radiusIndex)=median(A')
        coordinates_median_average(startNodeIndex,radiusIndex)=mean(A')

        clear A;
        clear times;
    end % for radiusIndex
end % for startNodeIndex

