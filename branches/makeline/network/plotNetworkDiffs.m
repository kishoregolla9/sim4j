function []=plotNetworkDiffs(result,allAnchors,folder,prefix)
% Plot the network difference, showing the anchor nodes with green squares
% Blue points are real point locations
% Red points are mapped point locations

NUM_MAX_TO_SHOW=3;

r=result.radius;
network=result.network;
plottitle=sprintf('%s Radius %.1f',network.shape,r);

numAnchorSets=size(allAnchors,1);
patchedMaps=result.patchedMap;
realPoints=network.points;
shape=network.shape;
errors=result.errors;
% Plot a network diff diagram for each anchor set
parfor j=1:numAnchorSets
    startPlotting=tic;
    h=figure('Name',['Network Difference' plottitle],'visible','off');
    fprintf('Plotting Network Difference for Anchor Set #%i %s',j,prefix);
    mappedPoints=patchedMaps(j).mappedPoints;
    anchors=allAnchors(j,:);
    
    subplotTitle=sprintf('Anchor Set %i',j);

    stats=sprintf('Max: %.2f Mean: %.2f Min: %.2f',...
        mean([errors(j,:).max]),...
        mean([errors(j,:).mean]),...
        mean([errors(j,:).min]));
    
    title({subplotTitle,prefix,stats});
    hold all
    % Show a line from each real to each mapped point (red circles)
    for i=1:size(realPoints,1)
        plot([realPoints(i,1),mappedPoints(i,1)],...
            [realPoints(i,2),mappedPoints(i,2)],'-or','MarkerSize',3);
    end
    % Overlay the real points with blue diamonds
    % to distinguish them from the mapped points
    plot(realPoints(:,1),realPoints(:,2),'db','MarkerSize',3);
    % Overlay the mapped points with cyan circles
    % to distinguish them from the mapped points
    plot(mappedPoints(:,1),mappedPoints(:,2),'oc','MarkerSize',3);
    
    % Show the worst (max error) points with stars
    differenceVector=patchedMaps(j).differenceVector;
    m=getMaxErrorPoints(differenceVector,NUM_MAX_TO_SHOW);
    for i=1:size(m,1)
        %p=pentagram(star),k=black
        plot(realPoints(m(i),1),realPoints(m(i),2),'pk','MarkerSize',12);
    end
    m=getMinErrorPoints(differenceVector,NUM_MAX_TO_SHOW);
    for i=1:size(m,1)
        %p=pentagram(star),g=green
        plot(realPoints(m(i),1),realPoints(m(i),2),'pg','MarkerSize',12);
    end
    
    % Show a circle of the radius around each anchor point
    % and Draw the Anchor Triangle
    for a=1:size(anchors,2)
        xa=realPoints(anchors(:,a),1);
        ya=realPoints(anchors(:,a),2);
        plot(xa,ya,'-d',...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','g',...
            'MarkerSize',5);
        rectangle('Position',[xa-r,ya-r,r*2,r*2],'Curvature',[1 1]);
        
        % A line of the triangle
        b=mod(a,size(anchors,2))+1;
        xb=realPoints(anchors(:,b),1);
        yb=realPoints(anchors(:,b),2);
        line([xa,xb],[ya,yb],'LineWidth',1,'Color','green');
    end

    minX=floor(min(min(realPoints(:,1),min(mappedPoints(:,1)))));
    minY=floor(min(min(realPoints(:,1),min(mappedPoints(:,1)))));
    maxX=ceil(max(max(realPoints(:,1),max(mappedPoints(:,1)))));
    maxY=ceil(max(max(realPoints(:,2),max(mappedPoints(:,2)))));
    minAll=min(minX,minY);
    maxAll=max(maxX,maxY);
    axis([minAll maxAll minAll maxAll]);
    grid on
    hold off    
    
    filename=sprintf('networkdiffs/NetworkDifference-%s-Radius%.1f-AnchorSet%i-%s',shape,r,j,prefix);
    saveFigure(folder,filename,h);
    hold off
    close
    fprintf('(%i,%i)-(%i,%i) done in %f seconds\n',minX,minY,maxX,maxY,toc(startPlotting));
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

function [m]=getMinErrorPoints(differenceVector,num)
m=zeros(num,1);
errors=ones(num,1);
errors=errors.*1000000;
for i=1:size(differenceVector,1)
    thisError=sum(differenceVector(i,:));
    [c,maxIndex]=max(errors);
    if thisError < c
        m(maxIndex)=i;
        errors(maxIndex)=thisError;
    end
end

end
