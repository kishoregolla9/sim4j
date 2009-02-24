function plotResult(results,radii,folder)

plotConnectivityVsError(results,radii,folder);
close all
hold off
plotAnchorSetVsError(results,radii,folder);
close all
hold off
plotDistanceVsError(results,radii,folder);
close all
hold off
plotAnchorDistanceVsError(results,radii,folder);
close all
hold off
plotAnchorNeighborsVsError(results,radii,folder);



