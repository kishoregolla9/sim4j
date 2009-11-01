function [anchors]=selectNodesFromEachCorner(network)
% Picks 4 anchors, one from each corner

anchors=selectNodesCloseToPoints(network,[0,0;0,network.height;network.width,0;network.width,network.height]);
    
