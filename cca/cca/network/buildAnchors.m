function [anchors]=buildAnchors(network,anchorPlacement,A,sets,targets)
% anchorPlacement: see networkconstants.m
% A:            number of anchors per anchor set
% sets:         number of anchor sets
% targets:      anchor target locations, if applicable to anchorPlacement
networkconstants;
anchors=zeros(sets,A);
switch anchorPlacement
    case NET.ANCHORS_CLUMPED
    
    case NET.ANCHORS_CORNERS
        anchors(1,:)=selectNodesFromEachCorner(network);

    case NET.ANCHORS_SPREAD
        % Choose anchor sets equally spread from the center of the network 
        % over axis (determinedod by number of anchors, eg, if 4, along 45deg axis) 
        r=0;
        rIncrement=sqrt((network.height/2).^2+(network.height/2).^2)/sets;
        for a=1:sets
            anchors(a,:)=selectNodesAtCenter(network,A,r);
            r=r+rIncrement;
        end
        
    case NET.ANCHORS_RANDOM
        anchors=nchoosek(1:network.numberOfNodes,A);
end
end
