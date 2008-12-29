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
    fprintf(1,'+++ Starting Node %i of %i: %i \n', startNodeIndex, numStartNodes, node(startNodeIndex));
    
    for radiusIndex=1:numRadiusLevels %for each radius level
        fprintf(1,'++++ Radius Level %i of %i\n', radiusIndex,numRadiusLevels);
        
        medians=zeros(numAnchorSets,1);
        means=zeros(numAnchorSets,1);
        maxs=zeros(numAnchorSets,1);
        mins=zeros(numAnchorSets,1);
        times=zeros(numAnchorSets,1);
        for anchorSetIndex=1:numAnchorSets % for each anchorSets set
            fprintf(1,'+++++ Anchor Set %i of %i\n', anchorSetIndex,numAnchorSets);
            
            localMaps{radiusIndex}= ...
                mapVitPatch(network,localMaps{radiusIndex},node(startNodeIndex),...
                anchorSets(anchorSetIndex,:),localMaps{radiusIndex}(1).radius);

            % localMaps{radiusIndex}(node(startNodeIndex))
            resultNode=localMaps{radiusIndex}(node(startNodeIndex));
            medians(anchorSetIndex)=mean(resultNode.patched_net_coordinates_error_median);
            means(anchorSetIndex)=mean(resultNode.patched_net_coordinates_error_mean);
            maxs(anchorSetIndex)=mean(resultNode.patched_net_coordinates_error_max);
            mins(anchorSetIndex)=mean(resultNode.patched_net_coordinates_error_min);

            times(anchorSetIndex)=localMaps{radiusIndex}(node(startNodeIndex)).map_patchTime;
        end

        result.patchTime(startNodeIndex,radiusIndex)=median(times);
        result.medianErrorByAnchor(startNodeIndex,radiusIndex)=median(medians);
        result.meanErrorByAnchor(startNodeIndex,radiusIndex)=median(means);
        result.maxErrorByAnchor(startNodeIndex,radiusIndex)=median(maxs);
        result.minErrorByAnchor(startNodeIndex,radiusIndex)=median(mins);
        
        clear A;
        clear times;
    end % for radiusIndex
end % for startNodeIndex

result.medianError=median(result.meanErrorByAnchor);
result.meanError=mean(result.meanErrorByAnchor);
result.minError=min(result.meanErrorByAnchor);
result.maxError=max(result.meanErrorByAnchor);
return
