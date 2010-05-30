function [ h ] = plotAnchorSpreadVsError( results,anchors,radii,folder )

network=results.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));
distanceMatrix=network.distanceMatrix;

anchorSets=anchors;
numAnchorSets=size(anchorSets,1);
%% Calculate anchor spread
spread=zeros(numAnchorSets,1);
for a=1:numAnchorSets
    anchors=anchorSets(a,:);
    for i=1:size(anchors,2)
        x=anchors(i);
        if i == size(anchors,2)
            y=anchors(1);
        else
            y=anchors(i+1);
        end
        spread(a) = spread(a) + distanceMatrix(x, y);
        fprintf('%i: Spread from %i to %i\n', a,x,y);
    end
end

dataToPlot=[spread mean(results(2).meanErrorPerAnchorSet,2)];
dataToPlot=sortrows(dataToPlot);


h=figure('Name','The Results by Anchor Spread','visible','off');
plot(dataToPlot(:,1),dataToPlot(:,2),'-d');

grid on
plotTitle=sprintf('Network %s',network.shape);
title({'Localization Error',plotTitle});
xlabel('Anchor Spread');
ylabel('Location Error (factor of radius)');
% hold all
% plot([results.connectivity],mean([results.medianError]),'-x');
% plot([results.connectivity],mean([results.maxError]),'-d');
% plot([results.connectivity],mean([results.minError]),'-s');
% plot([results.connectivity],mean([results.stdError]),'-o');
% legend('Mean Error','Median Error','Max Error','Min Error','StdDev');
% hold off
% 
% filename=sprintf('AnchorSpread-vs-Error-%s-Radius%.1f-to-%.1f',...
%    network.shape,minRadius,maxRadius);
% saveFigure(folder,filename);
