% function [patchTime,coordinates_median,coordinates_median_average,allResults]=...
%     mapPatch(network,localMaps,startNodes,anchorSets)

function [result]=mapPatch(network,localMaps,startNodes,anchorSets,radius,patchNumber)

%This function patches local maps into the global map for all the local maps
%computed for each radius value stored in the localMaps.
%input:
%  network - Nx2 matrix of the network
%  localMaps - computed using localMapComputing.m
%  startNodes - 1xM matrix containing M starting nodes that want to be
%    experimented with
%  anchorSets - SxT matrix containing S anchorSets sets that want to be experimented
%    with. Each anchorSets set has T anchorSets nodes.

startMapPatch=tic;

result.network=network;
result.connectivity=network.networkConnectivityLevel;
result.radius=radius;

node=startNodes;
numStartNodes=size(node,2);  % number of starting nodes
%numAnchorSets=floor(size(anchorSets,1)/MOD_ANCHORS);  % number of anchorSets sets for testing
numAnchorSets=size(anchorSets,1);

patchTimePerStart=zeros(numStartNodes,1);
medianErrorPerStart=zeros(numStartNodes,1);
meanErrorPerStart=zeros(numStartNodes,1);
maxErrorPerStart=zeros(numStartNodes,1);
minErrorPerStart=zeros(numStartNodes,1);
stdErrorPerStart=zeros(numStartNodes,1);

medianError=zeros(numAnchorSets,numStartNodes);
meanError=zeros(numAnchorSets,numStartNodes);
maxError=zeros(numAnchorSets,numStartNodes);
minError=zeros(numAnchorSets,numStartNodes);
stdError=zeros(numAnchorSets,numStartNodes);

times=zeros(numAnchorSets,numStartNodes);
bestNodes=zeros(numAnchorSets,numStartNodes);
worstNodes=zeros(numAnchorSets,numStartNodes);
for startNodeIndex=1:numStartNodes % for each starting node
    fprintf(1,'+++ %s Start Node %i (%i of %i)\n', patchNumber, node(startNodeIndex), startNodeIndex, numStartNodes);
    for anchorSetIndex=1:numAnchorSets % for each anchorSets set
        startAnchor=tic;
        fprintf(1,'++++ %s Anchor Set %i of %i\n', patchNumber, anchorSetIndex, numAnchorSets);
        anchorNodes=anchorSets(anchorSetIndex,:);
         
        localMaps{1}=mapVitPatch(network,localMaps{1},node(startNodeIndex),...
            anchorNodes,radius);
        resultNode=localMaps{1}(node(startNodeIndex));
        differenceVector=resultNode.differenceVector;
        result.patchedMap(anchorSetIndex)=resultNode;

        % Remove the anchor node differences
%         for i=1:size(anchorNodes,2)
%             % Assumes anchorNodes are in order
%             if (anchorNodes(1,i) == 1) 
%                 index=1; 
%             else
%                 index=anchorNodes(1,i)-i-1;
%             end
%             differenceVector(index,:)=[];
%         end
        coordinates_error_mean=mean(differenceVector)/radius;
        coordinates_error_median=median(differenceVector)/radius;
        coordinates_error_max=max(differenceVector)/radius;
        coordinates_error_min=min(differenceVector)/radius;
        coordinates_error_std=std(differenceVector)/radius;
        
%         for i=1:size(anchorNodes,2)
%             fprintf('Anchor Node Error: %i - %.2f\n', anchorNodes(i),differenceVector(i));
%         end
        medianError(anchorSetIndex,startNodeIndex)=sum(coordinates_error_median);
        meanError(anchorSetIndex,startNodeIndex)=sum(coordinates_error_mean);
        maxError(anchorSetIndex,startNodeIndex)=sum(coordinates_error_max);
        minError(anchorSetIndex,startNodeIndex)=sum(coordinates_error_min);
        stdError(anchorSetIndex,startNodeIndex)=sum(coordinates_error_std);
        
        times(anchorSetIndex,startNodeIndex)=resultNode.map_patchTime;
        
        fprintf(1,'++++ %s Patched local map for anchor set %i of %i in %.2f sec\n', ...
           patchNumber, anchorSetIndex, numAnchorSets, toc(startAnchor));
    end

    patchTimePerStart(startNodeIndex)=mean(times(:,startNodeIndex));
    medianErrorPerStart(startNodeIndex)=mean(medianError(:,startNodeIndex));
    meanErrorPerStart(startNodeIndex)=mean(meanError(:,startNodeIndex));
    maxErrorPerStart(startNodeIndex)=mean(maxError(:,startNodeIndex));
    minErrorPerStart(startNodeIndex)=mean(minError(:,startNodeIndex));
    stdErrorPerStart(startNodeIndex)=mean(stdError(:,startNodeIndex));

    clear A;
    clear times;

end % for startNodeIndex

% Average over the start nodes
result.patchTime=patchTimePerStart;
result.medianError=medianErrorPerStart;
result.meanError=meanErrorPerStart;
result.maxError=maxErrorPerStart;
result.minError=minErrorPerStart;
result.stdError=stdErrorPerStart;

result.bestNodesPerAnchorSet=bestNodes;
result.worstNodesPerAnchorSet=worstNodes;

for a=1:numAnchorSets % for each anchorSets set
    result.medianErrorPerAnchorSet(a,:)=medianError(a,:);
    result.meanErrorPerAnchorSet(a,:)=meanError(a,:);
    result.maxErrorPerAnchorSet(a,:)=maxError(a,:);
    result.minErrorPerAnchorSet(a,:)=minError(a,:);
    result.stdErrorPerAnchorSet(a,:)=stdError(a,:);
end

result.mapPatchTime=toc(startMapPatch);

return
