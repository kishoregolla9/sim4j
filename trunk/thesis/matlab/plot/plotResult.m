function plotResult(results,anchors,radii,folder,allMaps)

if (size(results,1) > 1)
    plotConnectivityVsError(results,radii,folder);
    close all
    hold off
end
if (size(anchors,1) > 1)
    plotAllAnchorSetErrors(results,anchors,radii,folder);
    plotAllAnchorSetErrors(results,anchors,radii,folder,2);
    close all
    hold off
    plotAnchorErrorsVsError(results,anchors,folder);
    close all
    hold off
    
    % plotIndependentXY(results,anchors,folder);
    close all
    hold off
    plotSingleStartNode(results,folder);
    close all
    hold off
    plotAnchorSetVsError(results,anchors,radii,folder);
    close all
    hold off
    plotAnchorLocalMapErrorVsError(results,anchors,radii,folder,allMaps);
    % close all
    % hold off
    % plotDistanceVsError(results,anchors,radii,folder);
    % close all
    % hold off
    % plotHopCountVsError(results,anchors,radii,folder);
    % close all
    % hold off
    plotAnchorAreaVsError(results,anchors,radii,folder);
    plotAnchorAreaVsError(results,anchors,radii,folder,2);
    plotAnchorTriangleHeightVsError(results,anchors,radii,folder);
    plotAnchorTriangleHeightVsError(results,anchors,radii,folder,2);
%     plotNumAnchorNeighborsVsError(results,anchors,radii,folder);
%     plotNumAnchorNeighborsVsError(results,anchors,radii,folder,2);
    
    plotAnchorDistanceVsError(results,anchors,radii,folder);
    plotAnchorDistanceVsError(results,anchors,radii,folder,2);
    
    plotRotRef(results,anchors,radii,folder);
    plotDissimilarity(results,anchors,radii,folder);
    plotDirections(results,anchors,radii,folder);
%     plotRegression(results,anchors,radii,folder,2);
    plotAnchorErrorVsNeighbors(results,anchors,radii,folder);
    
    close all
    hold off
    % plotAnchorNeighborsVsError(results,anchors,radii,folder);
    close all
    %hold off
    %plotHistograms(results,anchors,folder);
    
end

