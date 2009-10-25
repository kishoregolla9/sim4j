% function [patchTime,coordinates_median,coordinates_median_average,allResults]=...
%     mapPatch(network,localMaps,startNodes,anchorSets)

function [result]=mapPatch(network,localMaps,startNodes,anchorSets,...
    radius,patchNumber,folder,operations)

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

numStartNodes=size(startNodes,2);  % number of starting nodes
%numAnchorSets=floor(size(anchorSets,1)/MOD_ANCHORS);  % number of anchorSets sets for testing
numAnchorSets=size(anchorSets,1); 

% preallocate
errorsPerStart(numStartNodes,1) = struct(...
            'mean',0,...
            'median',0,...
            'max',0,...
            'min',0,...
            'std',0,...
            'time',0);

errors(numAnchorSets,numStartNodes) = struct(...
            'mean',0,...
            'median',0,...
            'max',0,...
            'min',0,...
            'std',0,...
            'time',0);

bestNodes=zeros(numAnchorSets,numStartNodes);
worstNodes=zeros(numAnchorSets,numStartNodes);

for startNodeIndex=1:numStartNodes   % for each starting node
    filename=sprintf('%s/patchedMaps/patchedMaps_startNode%i_index-%i.mat',folder,startNodes(startNodeIndex),startNodeIndex);
    if (exist(filename,'file') == 0)
        fprintf(1,'+++ %s Start Node %i (%i of %i)\n', patchNumber, startNodes(startNodeIndex), startNodeIndex, numStartNodes);
        [localMaps,rawResult]=mapVitPatch(network,localMaps,startNodeIndex);
        save(filename,'localMaps','rawResult');
    else
        load(filename);
    end
    refineResult=rawResult; %no refinement
    
    for anchorSetIndex=1:numAnchorSets % for each anchorSets set
        startAnchor=tic;
        anchorNodes=anchorSets(anchorSetIndex,:);
        mappedResult=transformMap(network.points, refineResult, ...
            anchorNodes, operations);
        resultNode=compareMaps(network, localMaps(startNodeIndex), ...
            mappedResult, radius);
        
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
        coordinatesError = struct('mean',mean(differenceVector)/radius,...
            'median',median(differenceVector)/radius,...
            'max',max(differenceVector)/radius,...
            'min',min(differenceVector)/radius,...
            'std',std(differenceVector)/radius);
        
%         for i=1:size(anchorNodes,2)
%             fprintf('Anchor Node Error: %i - %.2f\n', anchorNodes(i),differenceVector(i));
%         end
        errors(anchorSetIndex,startNodeIndex) = struct(...
            'mean',sum(coordinatesError.mean),...
            'median',sum(coordinatesError.median),...
            'max',sum(coordinatesError.max),...
            'min',sum(coordinatesError.min),...
            'std',sum(coordinatesError.std),...
            'time',resultNode.map_patchTime);
       
        fprintf(1,'++++ %s Patched Maps with Start #%i/%i, Anchor Set %i/%i in %.2f sec\n', ...
           patchNumber,startNodeIndex,numStartNodes, anchorSetIndex, numAnchorSets, toc(startAnchor));
    end

    errorsPerStart(startNodeIndex)=struct(...
        'mean',mean([errors(:,startNodeIndex).mean]),...
        'median',mean([errors(:,startNodeIndex).median]),...
        'max',mean([errors(:,startNodeIndex).max]),...
        'min',mean([errors(:,startNodeIndex).min]),...
        'std',mean([errors(:,startNodeIndex).std]),...
        'time',mean([errors(:,startNodeIndex).time]));

    clear A;
    clear times;

end % for startNodeIndex

% Average over the start nodes
result.errors=errors;
result.errorsPerStart=errorsPerStart;
result.bestNodesPerAnchorSet=bestNodes;
result.worstNodesPerAnchorSet=worstNodes;

for a=1:numAnchorSets % for each anchorSets set
    result.errorsPerAnchorSet=errors(a,:);
end

result.mapPatchTime=toc(startMapPatch);

return
