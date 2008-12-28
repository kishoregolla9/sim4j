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

node=startNodes %#ok<NOPRT>
numStartNodes=size(node,2);  % number of starting nodes
numAnchorSets=size(anchorSets,1);  % number of anchorSets sets for testing
numRadiusLevels=size(localMaps,2); % number of radius levels computed

for startNodeIndex=1:numStartNodes % for each starting node
    sprintf('+++ Starting Node %i: %i', startNodeIndex, node(startNodeIndex))
    
    for radiusIndex=1:numRadiusLevels %for each radius level
        sprintf('++++++ Radius Level %i', radiusIndex)
        
        A=zeros(numAnchorSets,1);
        times=zeros(numAnchorSets,1);
        for anchorSetIndex=1:numAnchorSets % for each anchorSets set
            sprintf('+++++++++ Anchor Set %i', anchorSetIndex)
            %       localMaps{radiusIndex}(1).radius=connectivityLevels(1,radiusIndex);
            localMaps{radiusIndex}= ...
                mapVitPatch(network,localMaps{radiusIndex},node(startNodeIndex),...
                anchorSets(anchorSetIndex,:),localMaps{radiusIndex}(1).radius);
            localMaps{radiusIndex}(node(startNodeIndex))
            A(anchorSetIndex)=...
                (localMaps{radiusIndex}(node(startNodeIndex)).patched_net_coordinates_error_median(1)+...,
                localMaps{radiusIndex}(node(startNodeIndex)).patched_net_coordinates_error_median(2))/2
            times(anchorSetIndex)=localMaps{radiusIndex}(node(startNodeIndex)).map_patchTime;
        end

        result.anchorResults(radiusIndex,:,startNodeIndex)=A;
        result.patchTime(startNodeIndex,radiusIndex)=median(times')
        % A=A(1:3);
        result.medianErrorByAnchor(startNodeIndex,radiusIndex)=median(A')
        result.meanErrorByAnchor(startNodeIndex,radiusIndex)=mean(A')
        result.minErrorByAnchor(startNodeIndex,radiusIndex)=min(A')
        result.maxErrorByAnchor(startNodeIndex,radiusIndex)=max(A')

        
        clear A;
        clear times;
    end % for radiusIndex
end % for startNodeIndex

result.medianError=median(result.medianErrorByAnchor)
result.meanError=median(result.meanErrorByAnchor)        
result.minError=median(result.minErrorByAnchor)
result.maxError=median(result.maxErrorByAnchor)
fieldnames(result)
return
