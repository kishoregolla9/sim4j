function [anchors]=buildAnchors(network,anchorPlacement,A,S, MOD_ANCHORS)
% anchorPlacement: see networkconstants.m
% A:            number of anchors per anchor set
% S:            number of anchor sets
% targets:      anchor target locations, if applicable to anchorPlacement
networkconstants;
anchors=zeros(S,A);
switch anchorPlacement
    case NET.ANCHORS_CLUMPED
    
    case NET.ANCHORS_CORNERS
        anchors(1,:)=selectNodesFromEachCorner(network);

    case NET.ANCHORS_SPREAD
        % Choose anchor sets equally spread from the center of the network 
        % over axis (determinedod by number of anchors, eg, if 4, along 45deg axis) 
        r=0;
        fprintf(1,'Choosing %i spread out anchors\n', A);
        rIncrement=sqrt((network.height/2).^2+(network.height/2).^2)/S;
        for a=1:S
            anchors(a,:)=selectNodesAtCenter(network,A,r);
            r=r+rIncrement;
        end
        
    case NET.ANCHORS_RANDOM
        start=tic;
        fprintf(1,'Building ALL %i random anchor sets\n', A);
        allAnchors=nchoosek(1:network.numberOfNodes,A);
        fprintf(1,'n choose k took %.2fsec\n',toc(start));
        % number of anchorSets sets for testing
        numAnchorSets=floor(size(allAnchors,1)/MOD_ANCHORS);  
        anchor=0;
        for anchorSetIndex=1:numAnchorSets % for each anchorSets set
            anchor=anchor+MOD_ANCHORS;
            anchors(anchorSetIndex,:)=allAnchors(anchor,:);
        end
        fprintf(1,'Building anchors took %.2fsec\n',toc(start));
end
end
