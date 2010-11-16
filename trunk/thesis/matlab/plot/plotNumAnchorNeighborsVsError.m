function plotNumAnchorNeighborsVsError( results,anchors,radii,folder,threshold)
% Plot number of unique anchor neighbors (unique among all anchors in the
% set) vs location error

network=results(1).network;
numAnchorSets=size(anchors,1);

%% Plot By Number Covered Nodes
figName='Anchor Neighbors vs Error';
dataName='Number of Anchors Unique Neighbors';
numResults=size(results,2);
numNeighbors=zeros(numResults,numAnchorSets,1);
for r=1:numResults
    %     numNeighbors=zeros(numAnchorSets,1);
    for s=1:numAnchorSets
        % For one start node
        anchorNodes=anchors(s,:);
        n=getNumUnique(network,anchorNodes);
        numNeighbors(r,s,1)=numNeighbors(r,s,1) + n;
    end
end

if (exist('threshold','var')==0)
    threshold=100;
end

plotSingleDataSet(figName,dataName,results,anchors,radii,numNeighbors,...
    folder,threshold);

end

function [num] = getNumUnique(network,anchorSet)
n=[];
for i=1:size(anchorSet,2)
    n=[n network.nodes(anchorSet(1,i)).neighbors]; %#ok<AGROW>
end
num=size(unique(n),2);
end
