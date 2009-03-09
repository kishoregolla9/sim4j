function plotHopCountVsError( results,radii,folder )
% Plot hop count distance of each node to its nearest anchor vs error

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
points=network.points;
numAnchorSets=size(network.anchors,1);

figure('Name','Hop Count to Anchor vs Error');

for i=1:numAnchorSets
    hold off
    subplot(numAnchorSets,1,i);
    hold all
    t=sprintf('Anchor Set %i',i);
    title(t);
    meanHopCount=zeros(size(points,1),1);
    minHopCount=zeros(size(points,1),1);

    for p=1:size(points,1)
        numAnchors=size(network.anchors,2);
        hopsToAnchor=zeros(numAnchors,1);
        for a=1:numAnchors
            hopsToAnchor(a)=network.shortestHopMatrix(network.anchors(a),p);
        end
        meanHopCount(p)=mean(hopsToAnchor);
        minHopCount(p)=min(hopsToAnchor);
    end
    
    labels=cell(1, size(results,2));
    for r=1:size(results,2)
        errors=sum(results(r).localMaps(i).differenceVector,2)/results(r).radius;
%         dataToPlot=sortrows([meanHopCount,errors]);
%         dataToPlot=accumulate(dataToPlot);
%         x=dataToPlot(:,1);
%         y=dataToPlot(:,2);
%         plot(x,y);
%         labels{1,r}=sprintf('Mean of Distances Radius=%.1f',results(r).radius);
        
        dataToPlot=sortrows([minHopCount,errors]);
        dataToPlot=accumulate(dataToPlot);
        x=dataToPlot(:,1);
        y=dataToPlot(:,2);
        plot(x,y);
        labels{1,r}=sprintf('r=%.1f',results(r).radius);
        
    end
    legend(labels,'Location','NorthWest');
    xlabel('Hop Count to Nearest Anchor');
    ylabel('Location Error (factor of radius)');
    hold on
    h1=gca;
    h2 = axes('Position',get(h1,'Position'));
    %     hist(minHopCount);
    uniqueCounts=unique(minHopCount);
    sortedCounts=sort(minHopCount);
    binCounts = histc(sortedCounts,uniqueCounts);
    histBar=bar(uniqueCounts,binCounts);
    set(histBar,'BarWidth',0.1,'FaceColor','none');
    set(h2,'YAxisLocation','right','Color','none','XTickLabel',[]);
    set(h2,'XLim',get(h1,'XLim'),'Layer','top');
    hold off
    set(gcf,'CurrentAxes',h1);
    maximize(gcf);
    
    filename=sprintf('%s\\HopCountVsError-%s-Radius%.1f-to-%.1f.eps',...
        folder,network.shape,minRadius,maxRadius);
    print('-depsc',filename);
    filename=sprintf('%s\\HopCountVsError-%s-Radius%.1f-to-%.1f.png',...
        folder,network.shape,minRadius,maxRadius);
    print('-dpng',filename);
end

hold off

end

function [result]=accumulate(dataToPlot)
  num=size(unique(dataToPlot(:,1),'rows'),1);
  result=zeros(num,2);
  
  d=dataToPlot(1,1);
  errorSum=0;
  sumCount=0;
  j=1;
  for i=1:size(dataToPlot,1)
      a = dataToPlot(i,1);
      errorSum = errorSum + dataToPlot(i,2);
      sumCount = sumCount+1;
      if a ~= d
          result(j,1)=d;
          result(j,2)=errorSum/sumCount;
          errorSum=0;
          sumCount=0;
          j=j+1;
      end
      d=a;
  end
  result(j,1)=d;
  result(j,2)=errorSum/sumCount;
end