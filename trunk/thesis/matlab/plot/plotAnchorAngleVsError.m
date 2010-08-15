function plotAnchorAngleVsError( results,anchors,radii,folder )
% Plot average anchor-triangle-angle vs error

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
numAnchorSets=size(anchors,1);

angles=zeros(numAnchorSets,2);
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
    %angles(s,2)=median(a);
    angles(s,2)=min(a);
end

figure('Name','Anchor-Triangle Angle vs Error','visible','off');
plotTitle=sprintf('Network %s',strrep(network.shape,'-',' '));
title({'Average Anchor-Triangle Angle vs Localization Error',...
    plotTitle});
hold all
grid on
labels=cell(1, 4);
li=1;
for r=1:size(results,2)
    errorPerAnchorSet=zeros(numAnchorSets,2);
    for s=1:numAnchorSets
        % For one start node
        errorPerAnchorSet(s,1)=[results(r).errors(s,1).max];
        errorPerAnchorSet(s,2)=[results(r).errors(s,1).mean];
    end    
    
    dataToPlot=[angles(:,1),errorPerAnchorSet(:,1),errorPerAnchorSet(:,2)];
    dataToPlot=sortrows(dataToPlot,1);
    plot(dataToPlot(:,1),dataToPlot(:,2),'-^k');
    plot(dataToPlot(:,1),dataToPlot(:,3),'--sk');
    labels{1}=sprintf('Max angle, max error');
    labels{2}=sprintf('Max angle, mean error');
    
    dataToPlot=[angles(:,2), errorPerAnchorSet];
    dataToPlot=sortrows(dataToPlot,1);
    plot(dataToPlot(:,1),dataToPlot(:,2),'-vk');
    plot(dataToPlot(:,1),dataToPlot(:,3),'--ok');
    labels{3}=sprintf('Min angle, max error');
    labels{4}=sprintf('Min angle, mean error');
    
end
legend(labels,'Location','Best');
xlabel('Angle (degrees)');
ylabel('Location Error (factor of radius)');
hold off

filename=sprintf('AnchorTriangleAnglesVsError-%s-Radius%.1f-to-%.1f',...
    network.shape,minRadius,maxRadius);
saveFigure(folder,filename);

end
