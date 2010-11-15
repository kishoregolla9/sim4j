function []=plotNetworkContours(...
    result,allAnchors,folder,prefix)
% Plot the network difference, showing the anchor nodes with green squares
% Blue points are real point locations
% Red points are mapped point locations

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
    doNetworkContours(1,data(1,1),plottitle,patchedMaps,realPoints,...
        network,result,allAnchors,folder,prefix);
else
    % Plot a network diff diagram for 10best and 10worst anchor sets
    for j=1:5
        doNetworkContours(j,data(j,1),plottitle,patchedMaps,realPoints,...
            network,result,allAnchors,folder,prefix);
    end
    j=floor(size(data,1)/2);
    doNetworkContours(j,data(j,1),plottitle,patchedMaps,realPoints,...
        network,result,allAnchors,folder,prefix);
    for j=numAnchorSets-4:numAnchorSets
        doNetworkContours(j,data(j,1),plottitle,patchedMaps,realPoints,...
            network,result,allAnchors,folder,prefix);
    end
end

end

