function [ h ] = plotAllAnchorSetErrors( results,anchors,radii,folder,threshold)

network=results.network;

if (exist('threshold','var')==0)
    threshold=100;
end

for r=1:size(results,2)
    figureName=sprintf('Location Error - Radius %.1f by Anchor Set',results(r).radius);
    h=figure('Name',figureName,'visible','off');
    hold off
   
    grid on
    plotTitle=sprintf('%s Radius %.1f',...
        strrep(network.shape,'-',' '),results(r).radius);
    if (threshold < 100)
        plotTitle=sprintf('%s\nExcluding error <%0.1f',plotTitle,threshold);
    end
    ylabel('Location Error (factor of radius)');
    hold all
    
    numStartNodes=size(results(r).errors,2);
    startNodeData=zeros(numStartNodes,3);
    for s=1:numStartNodes
        startNodeData(s,1)=mean([results(r).errors(:,s).max],2);
        startNodeData(s,2)=mean([results(r).errors(:,s).mean],2);
        startNodeData(s,3)=mean([results(r).errors(:,s).min],2);
    end
    
    numAnchorSets=size(results(r).errors,1);
    data=zeros(numAnchorSets,18);
    realHeight=zeros(numAnchorSets,1);
    realEdges=zeros(numAnchorSets,3);
    mappedHeight=zeros(numAnchorSets,1);
    mappedEdges=zeros(numAnchorSets,3);
    for a=1:numAnchorSets
        data(a,1)=a;
        data(a,2)=results(r).errorsPerAnchorSet(a).max;
        data(a,3)=results(r).errorsPerAnchorSet(a).mean;
        data(a,4)=results(r).errorsPerAnchorSet(a).min;
        tr=results(r).transform(a);
        T=tr.T;
        data(a,5)=acos(T(1,1)) * 180/pi;
        % Anchor Error3
        anchorError=zeros(size(anchors,2),1);
        realTriangle=zeros(3,2);
        mappedTriangle=zeros(3,2);
        for i=1:size(anchors,2)
            anchorError(i)=...
                results(r).patchedMap(a).distanceVector(anchors(a,i),:);
            realTriangle(i,:)=results(r).network.points(anchors(a,i),:);
            mappedTriangle(i,:)=results(r).patchedMap(a).mappedPoints(anchors(a,i),:);
        end
        data(a,7)=results(r).anchorErrors(a).max;
        [data(a,14),realEdges(a,:)]=triangleArea(realTriangle);
        [data(a,16),mappedEdges(a,:)]=triangleArea(mappedTriangle);
        realHeight(a)=(2*data(a,14))/max(realEdges(a,:));
        mappedHeight(a)=(2*data(a,14))/max(mappedEdges(a,:));
        data(a,9)=deviationOfSlopes(mappedTriangle);
        data(a,6)=2*(det(T)<0); % if det(T)<0, then reflected
        data(a,11)=3*(tr.b<0);
        data(a,12)=results(r).dissimilarity(a);
        data(a,13)=results(r).anchorErrors(a).mean;
    end
    
    figName='AnchorSetErrors';
    dataName='Mean Anchor Nodes Error';
    dataLabels={ 'Mean Anchor Nodes Error' };
    
    plotSingleDataSet(figName,dataName,results,anchors,radii,data(:,13)',...
        folder,threshold,dataLabels);

%     l='Mean of Anchor Node Error';
%     if (threshold < 100)
%         sprintf('%s excluding errors < %.1f,',l,threshold);
%     end
%     
%     x=data(:,13);
%     y=data(:,3);
%     outliers=find(y>threshold);
%     x(outliers)=[];
%     y(outliers)=[];
%     plot(x,y,'ok');
%     poly = polyfit(x, y, 2);
%     Output = polyval(poly,x);
%     correlation = corrcoef(y, Output);
% 
%     title(plotTitle);
%     bottom=sprintf('Mean Anchor Node Error\nCorrelation coeffecient=%.2f',...
%         correlation(1,2));
%     xlabel(bottom);
%     
%     filename=sprintf('AnchorSetErrors-%s-Radius%.1f',...
%         network.shape,results(r).radius);
%     if (threshold < 100)
%         filename=sprintf('%s-Excluding%.1f',filename,threshold);
%     end
%     saveFigure(folder,filename,h);
%     
%     hold off;
    %     close(h);
end

end