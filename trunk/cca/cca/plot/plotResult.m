function plotResult(results,anchors,radii,folder)

plotConnectivityVsError(results,radii,folder);
close all
hold off
plotAnchorSetVsError(results,radii,folder);
close all
hold off
plotAnchorLocalMapErrorVsError(results,anchors,radii,folder);
close all
hold off
%plotDistanceVsError(results,anchors,radii,folder);
% close all
% hold off
%plotHopCountVsError(results,anchors,radii,folder);
%close all
%hold off
plotAnchorDistanceVsError(results,anchors,radii,folder);
close all
hold off
%plotAnchorNeighborsVsError(results,anchors,radii,folder);
%close all
%hold off
plotHistograms(results,anchors,folder);



