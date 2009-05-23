function plotAnchorDistanceVsError( results,anchors,radii,folder )
% Plot distance between the anchors themselves vs error

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
numAnchorSets=size(anchors,1);

figure('Name','Anchor Distance vs Error');

distances=zeros(numAnchorSets,1);
for i=1:numAnchorSets
    anchors=results(1).anchors(i,:);
    numAnchors=size(anchors,2);
    d=zeros(numAnchors-1,1);
    for a=1:numAnchors
        b=mod(a+1,numAnchors) + 1;
        d(a)=network.distanceMatrix(anchors(a),anchors(b));
    end
	distances(i)=sum(d);
end

hold all

labels=cell(1, size(results,2));
for r=1:size(results,2)
    plot(distances,results(r).medianErrorPerAnchorSet);
    labels{r}=sprintf('Radius=%.1f',results(r).radius);
end
legend(labels,'Location','NorthWest');
xlabel('Sum of Distance between Anchors');
ylabel('Median Location Error');
hold off

filename=sprintf('AnchorDistanceVsError-%s-Radius%.1f-to-%.1f-AnchorSet%i',...
    network.shape,minRadius,maxRadius,i);
saveFigure(folder,filename);
end
