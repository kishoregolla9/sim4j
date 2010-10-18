function plotAnchorDistanceVsError( results,anchors,radii,folder,threshold )
% Plot distance between the anchors themselves vs error

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
numAnchorSets=size(anchors,1);

%% Plot by Perimeter
figName='Anchor Distance vs Error';
dataName='Sum of Distance between Anchors';

distances=zeros(1,numAnchorSets,1);
for s=1:numAnchorSets
    anchorNodes=anchors(s,:);
    numAnchors=size(anchorNodes,2);
    d=zeros(numAnchors*2-1,1);
    d(1)=network.distanceMatrix(anchorNodes(1),anchorNodes(2));
    d(2)=network.distanceMatrix(anchorNodes(2),anchorNodes(3));
    d(3)=network.distanceMatrix(anchorNodes(3),anchorNodes(1));
    distances(1,s,1)=sum(d);
end

if (exist('threshold','var')==0)
    plotSingleDataSet(figName,dataName,results,anchors,radii,distances,...
        folder);
else
    plotSingleDataSet(figName,dataName,results,anchors,radii,distances,...
        folder,threshold);
end

end
