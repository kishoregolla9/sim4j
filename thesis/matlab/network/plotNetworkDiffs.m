function []=plotNetworkDiffs(result,allAnchors,folder,prefix)
% Plot the network difference, showing the anchor nodes with green squares
% Blue points are real point locations
% Red points are mapped point locations

NUM_MAX_TO_SHOW=3;

r=result.radius;
network=result.network;
plottitle=sprintf('%s Radius %.1f',network.shape,r);

numAnchorSets=size(allAnchors,1);
patchedMaps=result.patchedMap;
realPoints=network.points;

data(:,1)=1:numAnchorSets;
data(:,2)=[result.errorsPerAnchorSet(:).mean];
data=sortrows(data,2);

if (size(allAnchors,1) == 1)
    doNetworkDiff(1,data(1,1),NUM_MAX_TO_SHOW,plottitle,patchedMaps,realPoints,...
        network,result,allAnchors,folder,prefix);
else
    % Plot a network diff diagram for 10best and 10worst anchor sets
    for j=1:10
        doNetworkDiff(j,data(j,1),NUM_MAX_TO_SHOW,plottitle,patchedMaps,realPoints,...
            network,result,allAnchors,folder,prefix);
    end
    j=size(data,1)/2;
    doNetworkDiff(j,data(j,1),NUM_MAX_TO_SHOW,plottitle,patchedMaps,realPoints,...
        network,result,allAnchors,folder,prefix);
    for j=numAnchorSets-9:numAnchorSets
        doNetworkDiff(j,data(j,1),NUM_MAX_TO_SHOW,plottitle,patchedMaps,realPoints,...
            network,result,allAnchors,folder,prefix);
    end
end

end

