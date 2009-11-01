function plotAnchorAngleVsError( results,anchors,radii,folder )
% Plot average anchor-triangle-angle vs error

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
numAnchorSets=size(anchors,1);

angles=zeros(numAnchorSets,3);
for s=1:numAnchorSets
    anchorNodes=anchors(s,:);
    numAnchors=size(anchorNodes,2);
    d=zeros(numAnchors*2-1,1);
    d(1)=network.distanceMatrix(anchorNodes(1),anchorNodes(2));
    d(2)=network.distanceMatrix(anchorNodes(2),anchorNodes(3));
    d(3)=network.distanceMatrix(anchorNodes(3),anchorNodes(1));
   
    x=acos( (d(2)^2 + d(3)^2 - d(1)^2) / (2*d(2)*d(3)) );
    y=acos( (d(1)^2 + d(3)^2 - d(2)^2) / (2*d(1)*d(3)) );
    z=acos( (d(1)^2 + d(2)^2 - d(3)^2) / (2*d(1)*d(2)) );
    a=[x y z].*(180/pi);
    angles(s,1)=max(a);
    angles(s,2)=median(a);
    angles(s,3)=min(a);
end

figure('Name','Average Anchor-Triangle Angle vs Error');
plotTitle=sprintf('Network %s',network.shape);
title({'Average Anchor-Triangle Angle vs Localization Error',...
    plotTitle});
hold all
grid on
labels=cell(1, size(results,2));
li=1;
for r=1:size(results,2)
    errorPerAnchorSet=zeros(numAnchorSets,1);
    for s=1:numAnchorSets
        % For one start node
        errorPerAnchorSet(s)=[results(r).errors(s,1).median];
    end    
    
    stats={'Max','Median','Min'};
    for i=1:3
        dataToPlot=[angles(:,i), errorPerAnchorSet];
        dataToPlot=sortrows(dataToPlot,1);
        plot(dataToPlot(:,1),dataToPlot(:,2),'-o');
        labels{li}=sprintf('%s angle radius=%.1f',stats{i},results(r).radius);
        li=li+1;
    end
end
legend(labels,'Location',' ');
xlabel('Angle (degrees)');
ylabel('Location Error');
hold off

filename=sprintf('AnchorTriangleAnglesVsError-%s-Radius%.1f-to-%.1f',...
    network.shape,minRadius,maxRadius);
saveFigure(folder,filename);

end
