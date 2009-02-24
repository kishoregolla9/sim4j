function plotAnchorDistanceVsError( results,radii,folder )

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
points=network.points;
numAnchorSets=size(network.anchors,1);

figure('Name','Anchor Distance vs Error');


distances=zeros(numAnchorSets,1);
for i=1:numAnchorSets
    anchors=results(i).network.anchors(i,:);
    numAnchors=size(anchors,2);
    d=zeros(numAnchors-1,1);
    for a=1:numAnchors
        b=mod(a+1,numAnchors) + 1;
        d(a)=distance(points(anchors(a),:),points(anchors(b),:));
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
ylabel('Location Error');
hold off

maximize(gcf);

filename=sprintf('%s\\AnchorDistanceVsError-%s-Radius%.1f-to-%.1f-AnchorSet%i.eps',...
    folder,network.shape,minRadius,maxRadius,i);
print('-depsc',filename);
filename=sprintf('%s\\AnchorDistanceVsError-%s-Radius%.1f-to-%.1f-AnchorSet%i.png',...
    folder,network.shape,minRadius,maxRadius,i);
print('-dpng',filename);
end


function [d]=distance(p1,p2)
    d=sqrt( ((p2(1)-p1(1))^2) + ((p2(2)-p1(2))^2) );
end