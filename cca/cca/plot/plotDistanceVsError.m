function plotDistanceVsError( results,radii,folder )

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
points=network.points;
numAnchorSets=size(network.anchors,1);

figure('Name','Distance to Anchor vs Error');

for i=1:numAnchorSets
    hold off
    subplot(ceil(numAnchorSets/2),ceil(numAnchorSets/2),i);
    hold all
    t=sprintf('Anchor Set %i',i);
    title(t);
    distances=zeros(size(points,1),1);

    for p=1:size(distances,1)
        numAnchors=size(network.anchors,2);
        distToAnchor=zeros(numAnchors,1);
        for a=1:numAnchors
            distToAnchor(a)=distance(points(network.anchors(a),:),points(p,:));
        end
        distances(p)=sum(distToAnchor);
    end
    
    labels=cell(1, size(results,2));
    for r=1:size(results,2)
        errors=sum(results(r).localMaps(i).differenceVector,2)/results(r).radius;
        dataToPlot=sortrows([distances,errors]);
        x=dataToPlot(:,1);
        y=dataToPlot(:,2);
        windowSize=25;
        yy=filter(ones(1,windowSize)/windowSize,1,y);
        plot(x,yy);
        labels{r}=sprintf('Radius=%.1f',results(r).radius);
    end
    legend(labels,'Location','NorthWest');
    xlabel('Distance to Nearest Anchor');
    ylabel('Location Error (factor of radius)');

    maximize(gcf);
    
    filename=sprintf('%s\\DistanceVsError-%s-Radius%.1f-to-%.1f-AnchorSet%i.eps',...
        folder,network.shape,minRadius,maxRadius,i);
    print('-depsc',filename);
    filename=sprintf('%s\\DistanceVsError-%s-Radius%.1f-to-%.1f-AnchorSet%i.png',...
        folder,network.shape,minRadius,maxRadius,i);
    print('-dpng',filename);
end

hold off

end

function [d]=distance(p1,p2)
    d=sqrt( ((p2(1)-p1(1))^2) + ((p2(2)-p1(2))^2) );
end