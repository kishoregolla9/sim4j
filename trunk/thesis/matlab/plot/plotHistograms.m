function plotHistograms( results,anchors,folder )

network=results(1).network;
numAnchorSets=size(anchors,1);
numResults=size(results,2);

figure('Name','Histograms','visible','off');
p=1;
for r=1:numResults
    for i=1:numAnchorSets
        hold off
        subplot(numResults,numAnchorSets,p);
        p=p+1;
        hold all
        distanceVector=results(r).patchedMap(i).distanceVector;
        standardDeviation=std(median(distanceVector,2));
        t=sprintf('Radius %.2f - Anchor Set %i\nStdDev=%.3f',results(r).radius,i,standardDeviation);
        title(t);
        hist(distanceVector);
    end
end
hold off

maximize(gcf);

filename=sprintf('%s/Histogram-%s.eps',...
    folder,network.shape);
print('-depsc',filename);
filename=sprintf('%s/Histogram-%s.png',...
    folder,network.shape);
print('-dpng',filename);

hold off

end
