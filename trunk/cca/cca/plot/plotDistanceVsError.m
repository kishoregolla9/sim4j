function plotDistanceVsError( results,radii,folder )

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
points=network.points;
numAnchorSets=size(network.anchors,1);

%for i=1:numAnchorSets
for i=1:1
    hold off
    t=sprintf('Anchor Set %i',i);
    title(t);
    hold all
    distances=zeros(size(points,1),1);

    for p=1:size(distances,1)
        numAnchors=size(network.anchors,2);
        distToAnchor=zeros(numAnchors,1);
        for a=1:numAnchors
            distToAnchor(i)=distance(points(network.anchors(a),:),points(p,:));
        end
        distances(p)=sum(distToAnchor);
    end
    
    for r=1:size(results,2)
        errors=sum(results(r).localMaps(i).differenceVector,2)/results(r).radius;
        dataToPlot=sort([distances,errors],1);
        plot(dataToPlot(:,1),dataToPlot(:,2));
        labels{r}=sprintf('Radius=%.1f',results(r).radius);
    end
    legend(labels);
end
filename=sprintf('%s\\DistanceVsError-%s-Radius%.1f-to-%.1f.eps',...
    folder,network.shape,minRadius,maxRadius);
print('-depsc',filename);
filename=sprintf('%s\\DistanceVsError-%s-Radius%.1f-to-%.1f.png',...
    folder,network.shape,minRadius,maxRadius);
print('-dpng',filename);

end

function [d]=distance(p1,p2)
    d=sqrt( ((p2(1)-p1(1))^2) + ((p2(2)-p1(2))^2) );
end