% function [patchTime,coordinates_median,coordinates_median_average,allResults]=...
%     mapPatch(network,localMaps,startNodes,anchorSets)

function [result]=mapPatch(network,localMaps,startNodes,anchorSets,radius)

%This function patches local maps into the global map for all the local maps
%computed for each radius value stored in the localMaps.
%input:
%  network - Nx2 matrix of the network
%  localMaps - computed using localMapComputing.m
%  startNodes - 1xM matrix containing M starting nodes that want to be
%    experimented with
%  anchorSets - SxT matrix containing S anchorSets sets that want to be experimented
%    with. Each anchorSets set has T anchorSets nodes.

result.connectivity=network.networkConnectivityLevel;
result.radius=radius;

node=startNodes;
numStartNodes=size(node,2);  % number of starting nodes
numAnchorSets=size(anchorSets,1);  % number of anchorSets sets for testing
numRadiusLevels=size(localMaps,2); % number of radius levels computed

for startNodeIndex=1:numStartNodes % for each starting node
    fprintf(1,'+++ Starting Node %i: %i of %i\n', startNodeIndex, node(startNodeIndex), numStartNodes);
    
    for radiusIndex=1:numRadiusLevels %for each radius level
        fprintf(1,'++++++ Radius Level %i of %i\n', radiusIndex,numRadiusLevels);
        
        A=zeros(numAnchorSets,1);
        times=zeros(numAnchorSets,1);
        for anchorSetIndex=1:numAnchorSets % for each anchorSets set
            fprintf(1,'+++++++++ Anchor Set %i of %i\n', anchorSetIndex,numAnchorSets);
            %       localMaps{radiusIndex}(1).radius=connectivityLevels(1,radiusIndex);
            localMaps{radiusIndex}= ...
                mapVitPatch(network,localMaps{radiusIndex},node(startNodeIndex),...
                anchorSets(anchorSetIndex,:),localMaps{radiusIndex}(1).radius);
            localMaps{radiusIndex}(node(startNodeIndex));
            A(anchorSetIndex)=...
                (localMaps{radiusIndex}(node(startNodeIndex)).patched_net_coordinates_error_median(1)+...,
                localMaps{radiusIndex}(node(startNodeIndex)).patched_net_coordinates_error_median(2))/2;
            times(anchorSetIndex)=localMaps{radiusIndex}(node(startNodeIndex)).map_patchTime;
        end

        result.anchorResults(radiusIndex,:,startNodeIndex)=A;
        result.patchTime(startNodeIndex,radiusIndex)=median(times');
        % A=A(1:3);
        result.medianErrorByAnchor(startNodeIndex,radiusIndex)=median(A');
        result.meanErrorByAnchor(startNodeIndex,radiusIndex)=mean(A');
        result.minErrorByAnchor(startNodeIndex,radiusIndex)=min(A');
        result.maxErrorByAnchor(startNodeIndex,radiusIndex)=max(A');

        
        clear A;
        clear times;
    end % for radiusIndex
end % for startNodeIndex

result.medianError=median(result.meanErrorByAnchor);
result.meanError=mean(result.meanErrorByAnchor);
result.minError=min(result.meanErrorByAnchor);
result.maxError=max(result.meanErrorByAnchor);
return
