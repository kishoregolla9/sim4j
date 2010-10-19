function plotAnchorDistanceVsError( results,anchors,radii,folder,threshold )
% Plot distance between the anchors themselves vs error

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
numAnchorSets=size(anchors,1);

%% Plot by Perimeter
figName='Anchor Distance vs Error';
dataName='Distance between Anchors';
dataLabels={'Sum' 'Minimum' 'Mean'};

distances=zeros(1,numAnchorSets,3);
for s=1:numAnchorSets
    anchorNodes=anchors(s,:);
%     numAnchors=size(anchorNodes,2);
    d=zeros(3,1);
    d(1)=network.distanceMatrix(anchorNodes(1),anchorNodes(2));
    d(2)=network.distanceMatrix(anchorNodes(2),anchorNodes(3));
    d(3)=network.distanceMatrix(anchorNodes(3),anchorNodes(1));
    distances(1,s,1)=sum(d);
    distances(1,s,2)=min(d);
    distances(1,s,3)=mean(d);
end

if (exist('threshold','var')==0)
    threshold=100;
end

for i=1:size(dataLabels,2)
    f=sprintf('%s %s',dataLabels{i}, figName);
    plotSingleDataSet(f,dataName,results,anchors,radii,...
        distances(:,:,i),...
        folder,threshold,{ dataLabels{i} });
end

end
