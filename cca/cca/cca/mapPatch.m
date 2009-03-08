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

result.network=network;
result.connectivity=network.networkConnectivityLevel;
result.radius=radius;
result.anchors=anchorSets;

node=startNodes;
numStartNodes=size(node,2);  % number of starting nodes
numAnchorSets=size(anchorSets,1);  % number of anchorSets sets for testing

patchTimePerStart=zeros(numStartNodes,1);
medianErrorPerStart=zeros(numStartNodes,1);
meanErrorPerStart=zeros(numStartNodes,1);
maxErrorPerStart=zeros(numStartNodes,1);
minErrorPerStart=zeros(numStartNodes,1);

medianError=zeros(numAnchorSets,numStartNodes);
meanError=zeros(numAnchorSets,numStartNodes);
maxError=zeros(numAnchorSets,numStartNodes);
minError=zeros(numAnchorSets,numStartNodes);
times=zeros(numAnchorSets,numStartNodes);
bestNodes=zeros(numAnchorSets,numStartNodes);
worstNodes=zeros(numAnchorSets,numStartNodes);
for startNodeIndex=1:numStartNodes % for each starting node
    fprintf(1,'+++ Starting Node %i of %i: %i \n', startNodeIndex, numStartNodes, node(startNodeIndex));

    for anchorSetIndex=1:numAnchorSets % for each anchorSets set
        fprintf(1,'+++++ Anchor Set %i of %i\n', anchorSetIndex,numAnchorSets);

        anchorNodes=anchorSets(anchorSetIndex,:);
        
        localMaps{1}=mapVitPatch(network,localMaps{1},node(startNodeIndex),...
            anchorNodes,radius);
        resultNode=localMaps{1}(node(startNodeIndex));
        differenceVector=resultNode.differenceVector;
        result.localMaps(anchorSetIndex)=resultNode;

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
        
%         for i=1:size(anchorNodes,2)
%             fprintf('Anchor Node Error: %i - %.2f\n', anchorNodes(i),differenceVector(i));
%         end
        medianError(anchorSetIndex,startNodeIndex)=sum(coordinates_error_median);
        meanError(anchorSetIndex,startNodeIndex)=sum(coordinates_error_mean);
        maxError(anchorSetIndex,startNodeIndex)=sum(coordinates_error_max);
        minError(anchorSetIndex,startNodeIndex)=sum(coordinates_error_min);
        
        times(anchorSetIndex,startNodeIndex)=resultNode.map_patchTime;
    end

    patchTimePerStart(startNodeIndex)=median(times(:,startNodeIndex));
    medianErrorPerStart(startNodeIndex)=median(medianError(:,startNodeIndex));
    meanErrorPerStart(startNodeIndex)=median(meanError(:,startNodeIndex));
    maxErrorPerStart(startNodeIndex)=median(maxError(:,startNodeIndex));
    minErrorPerStart(startNodeIndex)=median(minError(:,startNodeIndex));

    clear A;
    clear times;

end % for startNodeIndex

% Average over the start nodes
result.patchTime=median(patchTimePerStart);
result.medianError=median(medianErrorPerStart);
result.meanError=median(meanErrorPerStart);
result.minError=median(minErrorPerStart);
result.maxError=median(maxErrorPerStart);

result.bestNodesPerAnchorSet=bestNodes;
result.worstNodesPerAnchorSet=worstNodes;

for a=1:numAnchorSets % for each anchorSets set
    result.medianErrorPerAnchorSet(a)=median(medianError(a,:));
    result.meanErrorPerAnchorSet(a)=median(meanError(a,:));
    result.minErrorPerAnchorSet(a)=median(minError(a,:));
    result.maxErrorPerAnchorSet(a)=median(maxError(a,:));
end

return
