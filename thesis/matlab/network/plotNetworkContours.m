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

filename=sprintf('networkcontours/NetDensity-R%.1f%s',r,prefix);
h=figure('Name',['Network Density' plottitle],'visible','off');
grid on
x=network.points(:,1);
y=network.points(:,2);
z=zeros(size(x,1),1);
for i=1:size(z,1)
    z(i,1)=size(network.nodes(i).neighbors,2);
end
plotContours(x,y,z,summer(128));
hold off
saveFigure(folder,filename,h);

if (size(allAnchors,1) == 1)
    doNetworkContours(1,data(1,1),plottitle,patchedMaps,realPoints,...
        network,result,allAnchors,folder,prefix);
else
    % Plot a network diff diagram for 5best and 5worst 
    % and 10 in the middle anchor sets
    for j=1:5
        doNetworkContours(j,data(j,1),plottitle,patchedMaps,realPoints,...
            network,result,allAnchors,folder,prefix);
    end
    
    m=floor(size(data,1)/2) - 4;
    for j=m:m+10
        doNetworkContours(j,data(j,1),plottitle,patchedMaps,realPoints,...
            network,result,allAnchors,folder,prefix);
    end
    
    for j=numAnchorSets-4:numAnchorSets
        doNetworkContours(j,data(j,1),plottitle,patchedMaps,realPoints,...
            network,result,allAnchors,folder,prefix);
    end
end

end

