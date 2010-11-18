function [h]=plotAnchorTriangle(anchors,points,r,color,markerStyle,lineStyle,circleStyle)

plotLineSpec=sprintf('%s%sk',markerStyle,lineStyle);
h=plot(points(anchors,1),points(anchors,2),plotLineSpec,...
        'MarkerEdgeColor','black',...
        'MarkerSize',10);

for a=1:size(anchors,2)
    xa=points(anchors(:,a),1);
    ya=points(anchors(:,a),2);

    if r>0
        theCircle=rectangle('Position',[xa-r,ya-r,r*2,r*2],'Curvature',[1,1],...
            'LineStyle',circleStyle);
    end

    % A line of the triangle
    triLine=mod(a,size(anchors,2))+1;
    xb=points(anchors(:,triLine),1);
    yb=points(anchors(:,triLine),2);
    l=line([xa,xb],[ya,yb],'LineStyle',lineStyle,'LineWidth',1,'Color','k','HandleVisibility','off');
    
    if ~isempty(color)
        set(h,'MarkerFaceColor',color);
        set(theCircle,'EdgeColor',color);
        set(l,'Color',color);
    end
end