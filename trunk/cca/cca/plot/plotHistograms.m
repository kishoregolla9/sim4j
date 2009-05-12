function plotHistograms( results,folder )

network=results(1).network;
numAnchorSets=size(network.anchors,1);
numResults=size(results,2);

figure('Name','Histograms');
p=1;
for r=1:numResults
    for i=1:numAnchorSets
        hold off
        subplot(numResults,numAnchorSets,p);
        p=p+1;
        hold all
        diffVector=results(r).patchedMap(i).differenceVector;
        standardDeviation=std(median(diffVector,2));
        t=sprintf('Radius %.2f - Anchor Set %i\nStdDev=%.3f',results(r).radius,i,standardDeviation);
        title(t);
        hist(diffVector);
    end
end
hold off

maximize(gcf);

filename=sprintf('%s\\Histogram-%s.eps',...
    folder,network.shape);
print('-depsc',filename);
filename=sprintf('%s\\Histogram-%s.png',...
    folder,network.shape);
print('-dpng',filename);

hold off

end
