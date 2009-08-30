function plotResult(results,anchors,radii,folder,allMaps)

if (size(results,1) > 1)
    plotConnectivityVsError(results,radii,folder);
    close all
    hold off
end
plotStartNodeVsError(results,radii,folder);
close all
hold off
plotSingleStartNode(results,radii,folder);
close all
hold off
plotAnchorSetVsError(results,anchors,radii,folder);
close all
hold off
plotAnchorLocalMapErrorVsError(results,anchors,radii,folder,allMaps);
close all
hold off
plotDistanceVsError(results,anchors,radii,folder);

% close all
% hold off
% plotHopCountVsError(results,anchors,radii,folder);
% close all
% hold off
plotAnchorDistanceVsError(results,anchors,radii,folder);
close all
hold off
% plotAnchorNeighborsVsError(results,anchors,radii,folder);
close all
%hold off
%plotHistograms(results,anchors,folder);



