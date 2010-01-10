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

% Plot a network diff diagram for each anchor set
for j=1:numAnchorSets
    filename=sprintf('networkdiffs/NetDiff-Radius%.1f-AnchorSet%i-%s',r,j,prefix);
    if figureExists(folder,filename) ~= 0
        fprintf('Plot for Network Difference for Anchor Set #%i %s already exists\n',j,prefix);
        continue;
    end
    
    startPlotting=tic;
    h=figure('Name',['Network Difference' plottitle],'visible','off');
    fprintf('Plotting Network Difference for Anchor Set #%i %s',j,prefix);
    mappedPoints=patchedMaps(j).mappedPoints;
    anchors=allAnchors(j,:);
    
    subplotTitle=sprintf('Anchor Set %i',j);
    title({subplotTitle,prefix});
    hold all
    
    % Include connectivity in plots
%     dataToPlot=[realPoints(:,1) realPoints(:,2)];
%     gplot(network.connectivity, dataToPlot,':db');
%     foo=findobj('type','line');
%     set(foo,'MarkerSize',3);
%     
%     dataToPlot=[mappedPoints(:,1) mappedPoints(:,2)];
%     gplot(network.connectivity, dataToPlot,':oc');
%     foo=findobj('type','line');
%     set(foo,'MarkerSize',3);
    
    % Show a line from each real to each mapped point (red circles)
    for i=1:size(realPoints,1)
        pa=plot([realPoints(i,1),mappedPoints(i,1)],...
            [realPoints(i,2),mappedPoints(i,2)],'-or','MarkerSize',3);
    end
    labels={'Difference'};

    % Overlay the real points with blue diamonds
    % to distinguish them from the mapped points
    pb=plot(realPoints(:,1),realPoints(:,2),'db','MarkerSize',3);
    labels{end+1} = 'Real Points';  %#ok<AGROW>

    % Overlay the mapped points with cyan circles
    % to distinguish them from the mapped points
    pc=plot(mappedPoints(:,1),mappedPoints(:,2),'oc','MarkerSize',3);
    labels{end+1} = 'Mapped Points';  %#ok<AGROW>
    
    % Show the worst (max error) points with stars
    differenceVector=patchedMaps(j).differenceVector;
    m=getMaxErrorPoints(differenceVector,NUM_MAX_TO_SHOW);
    for i=1:size(m,1)
        %p=pentagram(star),k=black
        pd=plot(realPoints(m(i),1),realPoints(m(i),2),'pk','MarkerSize',12);
    end
    labels{end+1} = 'Max Error';  %#ok<AGROW>
    m=getMinErrorPoints(differenceVector,NUM_MAX_TO_SHOW);
    for i=1:size(m,1)
        %p=pentagram(star),g=green
        pe=plot(realPoints(m(i),1),realPoints(m(i),2),'pg','MarkerSize',12);
    end
    labels{end+1} = 'Min Error';  %#ok<AGROW>
    
    % Show a circle of the radius around each anchor point
    % and Draw the Anchor Triangle
    pf=plotAnchorTriangle(anchors,realPoints,r,'green');
    labels{end+1} = 'Anchor Node (real)';  %#ok<AGROW>
    pg=plotAnchorTriangle(anchors,mappedPoints,r,'magenta');
    labels{end+1} = 'Anchor Node (mapped)';  %#ok<AGROW>

    % Draw a rectangle around the "real" area
    width=ceil(max(realPoints(:,1)));
    height=ceil(max(realPoints(:,2)));
    rectangle('Position',[0,0,width,height],'Curvature',[0,0],...
        'LineWidth',2,'LineStyle','--');

    minX=floor(min(min(realPoints(:,1),min(mappedPoints(:,1)))));
    minY=floor(min(min(realPoints(:,1),min(mappedPoints(:,1)))));
    maxX=ceil(max(max(realPoints(:,1),max(mappedPoints(:,1)))));
    maxY=ceil(max(max(realPoints(:,2),max(mappedPoints(:,2)))));
    minAll=min(minX,minY);
    maxAll=max(maxX,maxY);
    axis([minAll maxAll minAll maxAll]);
    grid on
    
    legend([pa pb pc pd pe pf pg],labels,'Location','BestOutside');
    
    textLeft=1.0;
    
    %% Error Stats
    stats=sprintf('Max: %.3f\nMean: %.3f\nMin: %.3f',...
        result.errorsPerAnchorSet(j).max,...
        result.errorsPerAnchorSet(j).mean,...
        result.errorsPerAnchorSet(j).min);
    text(textLeft,0.7,stats,...
        'Units','normalized ','VerticalAlignment','Top');

    %% Triangle Stats
    triangle=zeros(3,2);
    for i=1:size(anchors,2)
        triangle(i,:)=network.points(anchors(1,i),:);
    end
    [d,slopes]=deviationOfSlopes(triangle);
    stats=sprintf('Area: %.2f\nSlopes: %.2f %.2f %.2f\nDevSlopes: %.2f',...
        triangleArea(triangle),...
        slopes,d);
    text(textLeft,0.6,'Triangle Stats',...
        'Units','normalized ','VerticalAlignment','Top','FontWeight','bold');
    text(textLeft,0.56,stats,...
        'Units','normalized ','VerticalAlignment','Top');

    %% Transform Stats
    transform=result.transform(j);
    rot=(acos(transform.T(1,1)))*180/pi;
    ref=(acos(transform.T(1,1))/2)*180/pi;
    scalarString=sprintf('Scalar: %.2f ',transform.b);
    rotateString=sprintf('Rotate/Reflect:\n[ %.4f %.4f ] \n[ %.4f %.4f ]\ndet=%.2f ref=%.2f rot=%.2f',...
        transform.T(1,1),transform.T(1,2),...
        transform.T(2,1),transform.T(2,2),...
        det(transform.T),rot,ref);
    translateString=sprintf(' %.2f ',transform.c(1,:));
    transformString=sprintf('%s\nTranslate:\n[%s]\n%s',scalarString,translateString,rotateString);
    text(textLeft,0.4,'Transform',...
        'Units','normalized ','VerticalAlignment','Top','FontWeight','bold');
    text(textLeft,0.36,transformString,...
        'Units','normalized ','VerticalAlignment','Top');
    
    %% Anchor Stats
    anchorString='';
    for a=1:size(anchors,2)
      xDiff=realPoints(anchors(a),1)-mappedPoints(anchors(a),1);
      yDiff=realPoints(anchors(a),2)-mappedPoints(anchors(a),2);
      anchorString=sprintf('%sR:%.2f,%.2f M:%.2f,%.2f diff:%.2f,%.2f\n',...
          anchorString,...
          realPoints(anchors(a),:)',...
          mappedPoints(anchors(a),:)',...
          xDiff,yDiff);
    end
    text(textLeft,0.1,'Anchors (R=real, M=mapped)',...
        'Units','normalized ','VerticalAlignment','Top','FontWeight','bold');
    text(textLeft,0.06,anchorString,...
        'Units','normalized ','VerticalAlignment','Top');
    
    %% FINISH
    hold off
    saveFigure(folder,filename,h);
    
    fprintf(' - done in %.2f seconds\n',toc(startPlotting));
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

function [m]=getMinErrorPoints(differenceVector,num)
m=ones(num,1);
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

function [h]=plotAnchorTriangle(anchors,points,r,color)
for a=1:size(anchors,2)
    xa=points(anchors(:,a),1);
    ya=points(anchors(:,a),2);
    h=plot(xa,ya,'-d',...
        'MarkerEdgeColor','black',...
        'MarkerFaceColor',color,...
        'MarkerSize',5);
    rectangle('Position',[xa-r,ya-r,r*2,r*2],'Curvature',[1,1],'EdgeColor',color,'LineStyle','--');

    % A line of the triangle
    triLine=mod(a,size(anchors,2))+1;
    xb=points(anchors(:,triLine),1);
    yb=points(anchors(:,triLine),2);
    line([xa,xb],[ya,yb],'LineWidth',1,'Color',color);
end

end
    


