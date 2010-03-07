function [ h ] = plotAllAnchorSetErrors( results,anchors,folder)

network=results.network;

for r=1:size(results,2)
    figureName=sprintf('The Results for Radius %.1f by Anchor Set',results(r).radius);
    h=figure('Name',figureName,'visible','off');
    hold off
    
    grid on
    plotTitle=sprintf('%s - Network %s',figureName,network.shape);
    addaxislabel(1,'Location Error (factor of radius)');
    hold all
    
    numStartNodes=size(results(r).errors,2);
    startNodeData=zeros(numStartNodes,3);
    for s=1:numStartNodes
        startNodeData(s,1)=mean([results(r).errors(:,s).max],2);
        startNodeData(s,2)=mean([results(r).errors(:,s).mean],2);
        startNodeData(s,3)=mean([results(r).errors(:,s).min],2);
    end
    
    numAnchorSets=size(results(r).errors,1);
    data=zeros(numAnchorSets,16);
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
        
        % Anchor Error
        anchorError=zeros(size(anchors,2),1);
        realTriangle=zeros(3,2);
        mappedTriangle=zeros(3,2);
        for i=1:size(anchors,2)
            anchorError(i)=...
                max(results(r).patchedMap(a).differenceVector(anchors(a,i),:));
            realTriangle(i,:)=results(r).network.points(anchors(a,i),:);
            mappedTriangle(i,:)=results(r).patchedMap(a).mappedPoints(anchors(a,i),:);
        end
        data(a,7)=min(anchorError);
        [data(a,14),realEdges(a,:)]=triangleArea(realTriangle);
        [data(a,16),mappedEdges(a,:)]=triangleArea(mappedTriangle);
        realHeight(a)=(2*data(a,14))/max(realEdges(a,:));
        mappedHeight(a)=(2*data(a,14))/max(mappedEdges(a,:));
        
        data(a,9)=deviationOfSlopes(mappedTriangle);
        
        data(a,6)=2*(det(T)<0); % if det(T)<0, then reflected
        data(a,10)=4*(tr.c(1,1)<0 | tr.c(1,2)<0);
        data(a,11)=3*(tr.b<0);
        
        data(a,12)=results(r).dissimilarity(a);
        
        data(a,13)=results(r).anchorErrors(a).mean;
        
        %     heightOverBase=realHeight(:)./max(realEdges,[],2);
        %     mapped=mappedHeight(:)./max(mappedEdges,[],2);
        
%         data(a,14)=realHeight(a);
    end
    
    data=sortrows(data, -3);
    
    ax1 = gca;
    set(ax1,'XScale','log');
    legends=cell(6,1);
    p=plot([data(:,2)/2,data(:,3)/2,data(:,4)/2,data(:,7)],'-o');
    
    plots(1)=p(1);
    legends{1}=sprintf('Max');
    
    plots(2)=p(2);
    legends{2}=sprintf('Mean');
    
    plots(3)=p(3);
    legends{3}=sprintf('Min');
    set(plots(3),'visible','off');
    
    plots(4)=p(4);    
    set(plots(4),'LineStyle','-.','Marker','v');
    legends{4}=sprintf('Anchor Error');
    set(plots(4),'visible','off');
    
    X=1:size(data,1);
    plots(5)=addaxis(X,data(:,12),'-pm');
    legends{5}=sprintf('Dissimiliarity');
    addaxislabel(2,'Dissimiliarity');
    
    [plots(6),ax]=addaxis(X,data(:,14),':^c'); % Triangle Area
%     set(ax,'YLim',[0 0.2]);
%     set(ax,'YTick',0:0.05:0.2);
    legends{6}=sprintf('Triangle area');
    addaxislabel(3,'Triangle area ');
    
%     plots(7)=addaxis(X,data(:,7),'-.vr'); % anchor node errors
%     legends{7}=sprintf('Anchor Node Error');
%     addaxislabel(4,'Anchor Node Error');
    
%     plots(7)=addaxis(X,data(:,9),':sr'); % Slopes
%     legends{7}=sprintf('Std of Slopes');
%     addaxislabel(4,'Std of Slopes');
    
%     [plots(7),ax]=addaxis(X,data(:,6),[1,5],'*r','MarkerSize',10);
%     legends{7}=sprintf('Transformation Properties');
%     addaxislabel(4,'Transformation Properties');
%     set(ax,'YTick',1:1:5)
%     set(ax,'YTickLabel',{'','det(T)<1','tr.c<1','tr.b<1'})

%     [plots(7),ax]=addaxis(X,data(:,14),'--^r','MarkerSize',8);
%     legends{7}=sprintf('Std of edges');
%     addaxislabel(4,'Std of edges');
%     set(ax,'XGrid','on')
    
%      plots(7)=addaxis(X,mappedHeight,'^-g','MarkerSize',8);
%      legends{7}=sprintf('height');
%      addaxislabel(4,'height');
   
%     plots(9)=addaxis(X,max(data(:,15))./max(data(:,16)),':vb'); % Triangle Edges
%     legends{9}=sprintf('Real:Mapped triangle max edge');
%     addaxislabel(6,'Triangle Edge Ratio');
%     plotVsError(results,r,'Min Triangle Edge - mapped',min(realEdges,2),folder);
    
%     plots(9)=plot(X,data(:,10),'sc','MarkerSize',10); % is tr.c negative?
%     legends{9}=sprintf('Is translation negative');
    
%     plots(10)=plot(X,data(:,11),'sg','MarkerSize',10); % is tr.b negative?
%     legends{10}=sprintf('Is scalar negative');

%     plots(11)=addaxis(X,data(:,12),':sr'); 
%     legends{11}=sprintf('Procrustes Dissimilarity Measure');
%     addaxislabel(6,'Procrustes Dissimilarity Measure');
   
    n=10;
    nWorst=sprintf('%i ',data(1:n,1));
    nBest=sprintf('%i ',data(end:-1:size(data,1)-n-1,1));
    temp=sprintf('Best: %s',nBest);
    nWorst %#ok<NOPRT>
    title({plotTitle,temp});
    temp=sprintf('Sorted by Mean Error - %s\nWorst: %s',results(r).reflect,nWorst);
    xlabel(temp);
    legendHandle=legend(plots,legends,'Location','NorthWestOutside','FontSize',6);
    l=get(legendHandle,'Position');
    set(legendHandle,'Position',[l(1)+.05,l(2)+0.05,l(3),l(4)]);
    
    filename=sprintf('AnchorSetErrors-%s-Radius%.1f',...
        network.shape,results(r).radius);
    saveFigure(folder,filename,h);
    
    hold off;
%     close(h);
end

end