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

patchTimePerStart=zeros(numStartNodes,1);
medianErrorPerStart=zeros(numStartNodes,1);
meanErrorPerStart=zeros(numStartNodes,1);
maxErrorPerStart=zeros(numStartNodes,1);
minErrorPerStart=zeros(numStartNodes,1);

for startNodeIndex=1:numStartNodes % for each starting node
    fprintf(1,'+++ Starting Node %i of %i: %i \n', startNodeIndex, numStartNodes, node(startNodeIndex));
   
       
        medianError=zeros(numAnchorSets,1);
        meanError=zeros(numAnchorSets,1);
        maxError=zeros(numAnchorSets,1);
        minError=zeros(numAnchorSets,1);
        times=zeros(numAnchorSets,1);
        for anchorSetIndex=1:numAnchorSets % for each anchorSets set
            fprintf(1,'+++++ Anchor Set %i of %i\n', anchorSetIndex,numAnchorSets);
            
            localMaps{1}=mapVitPatch(network,localMaps{1},node(startNodeIndex),...
                anchorSets(anchorSetIndex,:),radius);

            resultNode=localMaps{1}(node(startNodeIndex));
            
            medianError(anchorSetIndex)=mean(resultNode.patched_net_coordinates_error_median);
            meanError(anchorSetIndex)=mean(resultNode.patched_net_coordinates_error_mean);
            maxError(anchorSetIndex)=mean(resultNode.patched_net_coordinates_error_max);
            minError(anchorSetIndex)=mean(resultNode.patched_net_coordinates_error_min);
            times(anchorSetIndex)=resultNode.map_patchTime;
        end

        patchTimePerStart(startNodeIndex)=median(times);
        medianErrorPerStart(startNodeIndex)=median(medianError);
        meanErrorPerStart(startNodeIndex)=median(meanError);
        maxErrorPerStart(startNodeIndex)=median(maxError);
        minErrorPerStart(startNodeIndex)=median(minError);
        
        clear A;
        clear times;

end % for startNodeIndex

result.patchTime=mean(patchTimePerStart);
result.medianError=mean(medianErrorPerStart);
result.meanError=mean(meanErrorPerStart);
result.minError=mean(minErrorPerStart);
result.maxError=mean(maxErrorPerStart);
return
