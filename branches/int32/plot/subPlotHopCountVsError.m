function [  ] = subPlotHopCountVsError( results, radius, ...
    diffVector, hopCount, l )
%SUBPLOTHOPCOUNTVSERROR Summary of this function goes here
%   Detailed explanation goes here

labels=cell(1, size(results,2));
for r=1:size(results,2)
    errors=sum(diffVector,2)/radius;
    %         dataToPlot=sortrows([meanHopCount,errors]);
    %         dataToPlot=accumulate(dataToPlot);
    %         x=dataToPlot(:,1);
    %         y=dataToPlot(:,2);
    %         plot(x,y);
    %         labels{1,r}=sprintf('Mean of Distances Radius=%.1f',results(r).radius);
    
    dataToPlot=sortrows([hopCount,errors]);
    dataToPlot=accumulate(dataToPlot);
    x=dataToPlot(:,1);
    y=dataToPlot(:,2);
    hold all
    plot(x,y);
    labels{1,r}=sprintf('%s r=%.1f',l,radius);
end
legend(labels,'Location','Best');
xlabel('Hop Count to Nearest Anchor');
ylabel('Location Error (factor of radius)');

% h1=gca;
% h2 = axes('Position',get(h1,'Position'));
% uniqueCounts=unique(hopCount);
% sortedCounts=sort(hopCount);
% binCounts = histc(sortedCounts,uniqueCounts);
% histBar=bar(uniqueCounts,binCounts);
% set(histBar,'BarWidth',0.1,'FaceColor','none');
% set(h2,'YAxisLocation','right','Color','none','XTickLabel',[]);
% set(h2,'XLim',get(h1,'XLim'),'Layer','top');
% hold off
% set(gcf,'CurrentAxes',h1);

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