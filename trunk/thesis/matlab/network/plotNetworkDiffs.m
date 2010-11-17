function []=plotNetworkDiffs(result,allAnchors,folder,prefix,showStats)
% Plot the network difference, showing the anchor nodes with green squares
% Blue points are real point locations
% Red points are mapped point locations

NUM_MAX_TO_SHOW=3;

if exist('showStats','var') == 0
    showStats=false;
end 

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
        network,result,allAnchors,folder,prefix,showStats);
else
    % Plot a network diff diagram for 10best and 10worst anchor sets
    for j=1:5
        doNetworkDiff(j,data(j,1),NUM_MAX_TO_SHOW,plottitle,patchedMaps,realPoints,...
            network,result,allAnchors,folder,prefix,showStats);
    end
    
    m=floor(size(data,1)/2) - 4;
    for j=m:m+9
        doNetworkDiff(j,data(j,1),NUM_MAX_TO_SHOW,plottitle,patchedMaps,realPoints,...
            network,result,allAnchors,folder,prefix,showStats);
    end

    for j=numAnchorSets-4:numAnchorSets
        doNetworkDiff(j,data(j,1),NUM_MAX_TO_SHOW,plottitle,patchedMaps,realPoints,...
            network,result,allAnchors,folder,prefix,showStats);
    end
end

end

