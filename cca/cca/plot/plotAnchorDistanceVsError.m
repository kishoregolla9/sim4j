function plotAnchorDistanceVsError( results,anchors,radii,folder )
% Plot distance between the anchors themselves vs error

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
numAnchorSets=size(anchors,1);

figure('Name','Anchor Distance vs Error');
plotTitle=sprintf('Network %s',network.shape);
title({'Sum of Distance between All Anchors vs Localization Error',plotTitle});

distances=zeros(numAnchorSets,1);
for i=1:numAnchorSets
    anchorNodes=anchors(i,:);
    numAnchors=size(anchorNodes,2);
    d=zeros(numAnchors*2-1,1);
    j=0;
    for a=1:numAnchors
        for b=a:numAnchors
            if (a ~= b)
                j=j+1;
                d(j)=network.distanceMatrix(anchorNodes(a),anchorNodes(b));
                fprintf('Set %i: Distance between %i and %i: %.1f\n',i,a,b,d(a));
            end
        end
    end
	distances(i)=sum(d);
end

hold all

labels=cell(1, size(results,2));
for r=1:size(results,2)
    dataToPlot=[distances, results(r).errorsPerAnchorSet.median];
    dataToPlot=sortrows(dataToPlot,1);    
    plot(dataToPlot(:,1),dataToPlot(:,2),'-o');
    labels{r}=sprintf('Radius=%.1f',results(r).radius);
end
legend(labels,'Location','NorthWest');
xlabel('Sum of Distance between Anchors');
ylabel('Median Location Error');
hold off

filename=sprintf('AnchorDistanceVsError-%s-Radius%.1f-to-%.1f',...
    network.shape,minRadius,maxRadius);
saveFigure(folder,filename);
end
