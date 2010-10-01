function [ h ] = plotAllAnchorSetErrors( results,anchors,folder)

network=results.network;

for r=1:size(results,2)
    figureName=sprintf('Location Error - Radius %.1f by Anchor Set',results(r).radius);
    h=figure('Name',figureName,'visible','off');
    hold off
   
    grid on
    plotTitle=sprintf('Location Error\n%s Radius %.1f',...
        strrep(network.shape,'-',' '),results(r).radius);
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
        %         data(a,10)=4*(tr.c(1,1)<0 | tr.c(1,2)<0);
        data(a,11)=3*(tr.b<0);
        
        data(a,12)=results(r).dissimilarity(a);
        
        data(a,13)=results(r).anchorErrors(a).mean;
        
        %     heightOverBase=realHeight(:)./max(realEdges,[],2);
        %     mapped=mappedHeight(:)./max(mappedEdges,[],2);
        
        %         data(a,14)=realHeight(a);
        
%         data(a,15)=results(r).ixy.errorsPerAnchorSet(a).max;
%         data(a,16)=results(r).ixy.errorsPerAnchorSet(a).mean;
%         data(a,17)=results(r).ixy.errorsPerAnchorSet(a).min;
    end
    
    data(:,18)=jackknife(@var,data(:,3));
    
%     data=sortrows(data, -3);
    
    ax1 = gca;
%     set(ax1,'XScale','log');
    legends=cell(1,1);
    
    legends{1}=sprintf('Mean of Anchor Node Error');
    p=plot([data(:,13),data(:,3)],'-ok');
    
    
    %     p=plot([data(:,2),data(:,3),data(:,7)],'-o');
%     p=plot([data(:,2),data(:,3),data(:,4)],'-ok');
%     set(p(1),'Marker','^','Color','black');
%     set(p(3),'Marker','s','Color','black');
    plots(1)=p(1);
%     legends{1}=sprintf('Max error');
    
%     plots(2)=p(2);
%     legends{2}=sprintf('Mean error');
    
%     plots(3)=p(3);
%     legends{3}=sprintf('Min error');
    
%     plots(3)=p(3);
%     set(plots(3),'LineStyle','-.','Marker','v');
%     legends{3}=sprintf('Anchor Error');
    
%     X=1:size(data,1);
%     [plots(4),ax]=addaxis(X,data(:,14),':^c'); % Triangle Area
%     %     set(ax,'YLim',[0 0.2]);
%     %     set(ax,'YTick',0:0.05:0.2);
%     legends{4}=sprintf('Triangle area');
%     addaxislabel(2,'Triangle area ');
    
    %     plots(5)=addaxis(X,data(:,12),'-pm');
    %     legends{5}=sprintf('Dissimiliarity');
    %     addaxislabel(3,'Dissimiliarity');
    
    
    %     plots(6)=addaxis(X,data(:,18),'-s');
    %     legends{6}=sprintf('Jackknife');
    %     addaxislabel(4,'Jackknife');
    
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
    
%     n=2;
%     nWorst=sprintf('%i ',data(1:n,1));
%     nBest=sprintf('%i ',data(end:-1:size(data,1)-n-1,1));
%     temp=sprintf('Best: %s',nBest);
%     title({plotTitle,temp});
    title(plotTitle);
%     temp=sprintf('Sorted by Mean Error - %s\nWorst: %s',results(r).reflect,nWorst);
%     temp=sprintf('Anchor Set (randomly chosen) - sorted by mean error');
%     xlabel(temp);
    xlabel('Mean Anchor Node Error');
%     legendHandle=legend(plots,legends,'Location','NorthEast');
%     l=get(legendHandle,'Position');
%     set(legendHandle,'Position',[l(1)+.05,l(2)+0.05,l(3),l(4)]);
    
    filename=sprintf('AnchorSetErrors-%s-Radius%.1f',...
        network.shape,results(r).radius);
    saveFigure(folder,filename,h);
    
    hold off;
    %     close(h);
end

end