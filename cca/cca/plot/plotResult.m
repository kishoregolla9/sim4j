function [h1]=plotResult(results,radii,folder)

h1=plotConnectivityVsError(results,radii,folder);
plotAnchorSetVsError(results,radii,folder);
plotAnchorNeighborsVsError(results,radii,folder);



