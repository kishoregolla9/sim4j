function [h]=plotNetworkDiffs(result,allAnchors,folder,prefix)
% Plot the network difference, showing the anchor nodes with green squares
% Blue points are real point locations
% Red points are mapped point locations

NUM_MAX_TO_SHOW=3;

r=result.radius;
network=result.network;
plottitle=sprintf('%s Radius %.1f',network.shape,r);

numAnchorSets=size(allAnchors,1);

% Plot a network diff diagram for each anchor set
for j=1:numAnchorSets
    h=figure('Name',['Network Difference' plottitle],'visible','off');
    fprintf('Plotting Network Difference for Anchor Set #%i\n',j);
    mappedPoints=result.patchedMap(j).mappedPoints;
    realPoints=network.points;
    anchors=allAnchors(j,:);
    
    subplotTitle=sprintf('Anchor Set %i',j);
    title(subplotTitle);
    hold all
    % Show a line from each real to each mapped point (red circles)
    for i=1:size(realPoints,1)
        plot([realPoints(i,1),mappedPoints(i,1)],...
            [realPoints(i,2),mappedPoints(i,2)],'-or','MarkerSize',3);
    end
    % Overlay the real points with blue diamonds
    % to distinguish them from the mapped points
    plot(realPoints(:,1),realPoints(:,2),'db','MarkerSize',3);
    
    % Show the worst (max error) points with stars
    differenceVector=result.patchedMap(j).differenceVector;
    m=getMaxErrorPoints(differenceVector,NUM_MAX_TO_SHOW);
    for i=1:size(m,1)
        %p=pentagram(star),k=black
        plot(realPoints(m(i),1),realPoints(m(i),2),'pk','MarkerSize',7);
    end
    
    % Show a circle of the radius around each anchor point
    for a=1:size(anchors,2)
        x=realPoints(anchors(:,a),1);
        y=realPoints(anchors(:,a),2);
        plot(x,y,'-d',...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','g',...
            'MarkerSize',3);
        rectangle('Position',[x-r,y-r,r*2,r*2],'Curvature',[1 1]);
    end
    axis([0 ceil(max(realPoints(:,1))) 0 ceil(max(realPoints(:,2)))]);
    axis square
    hold off    
    
    filename=sprintf('networkdiffs/%sNetworkDifference-%s-Radius%.1f-AnchorSet%i',prefix,network.shape,r,j);
    saveFigure(folder,filename,h);
    hold off
    close
end

end

function [m]=getMaxErrorPoints(differenceVector,num)
m=zeros(num,1);
errors=zeros(num,1);
for i=1:size(differenceVector,1)
    thisError=sum(differenceVector(i,:));
    [c,minIndex]=min(errors);
    if thisError > c
        m(minIndex)=i;
        errors(minIndex)=thisError;
    end
end
end

