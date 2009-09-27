function [anchors]=buildAnchors(network,anchorPlacement,A,S)
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
        fprintf(1,'Choosing %i spread out anchors\n', S);
        rIncrement=sqrt((network.height/2).^2+(network.height/2).^2)/S;
        for a=1:S
            anchors(a,:)=selectNodesAtCenter(network,A,r);
            r=r+rIncrement;
        end
        
    case NET.ANCHORS_RANDOM
        start=tic;
        fprintf(1,'Building %i random anchor sets from all choices\n', S);
        allAnchorChoices=nchoosek(1:network.numberOfNodes,A);
        numChoices=size(allAnchorChoices,1);
        fprintf(1,'n choose k took %.2fsec resulting in %i choices\n',...
            toc(start),numChoices);
        % number of anchorSets sets for testing
        increment=floor(numChoices/S);  
        choice=0;
        % for each anchorSets set
        for anchorSetIndex=1:S
            choice = choice + increment;
            anchors(anchorSetIndex,:)=allAnchorChoices(choice,:);
        end
        fprintf(1,'Building anchors took %.2fsec\n',toc(start));
end
end
