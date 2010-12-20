function [h]=plotIndicators(errors,stat,radius,label,increment,showOutliers,xscale,names,connectivityLevels)
% errors cell array of arrays of errors
% stat cell array (same size as errors)
%

h=figure('Name','Outlier Indicator','visible','off');
m={'g.','co','rs','b^'};
numsubs=max(1,length(errors)/2);
for e=1:length(errors)
    if(numsubs>1)
        subplot(numsubs,2,e);
    end
    dataToPlot=[stat{e}/radius; errors{e}]';
    dataToPlot=sortrows(dataToPlot,1);
    x=dataToPlot(:,1);
    y=dataToPlot(:,2);
    plot(x,y,m{1},'HandleVisibility','off');
    hold all
% end    
outlierSep=2.5;
confidence=0.05;
% for e=1:length(errors)
    % plot(x,y,'.');
    hold all

%     dataToPlot=[stat{e}/radius; errors{e}]';
%     dataToPlot=sortrows(dataToPlot,1);
%     x=dataToPlot(:,1);
%     y=dataToPlot(:,2);

    grid on
    set(gca,'XScale',xscale);
    xlabel(label);
    ylabel({'Location Error';'(factor of radio radius)'});
    
    bins=0:increment:max(x);
    bins=[ bins bins(length(bins))+increment ]; %#ok grow
    % n=zeros(size(bins,2),1);
    mu=zeros(size(bins,2),1);
    crossed=false;
    
    for i=2:length(bins)
        bottom=bins(1,i-1);
        top=bins(1,i);
        v=y(x>bottom & x<=top);
        criticalT=tinv(1-confidence,size(v,1));
        ci=(criticalT*std(v)/sqrt(length(v)));
        mu(i)=mean(v);
        %     plot(repmat(bins(i),length(v),1),v,'g.');
        d=bins(i)-(increment/2);
        errorbar(d,mu(i),ci,'.k','HandleVisibility','off');
        d=d-(increment/2);
        if (bottom == 0 && strcmp(xscale,'log'))
            bottom=0.0001;
        end
        line([bottom top], [ mu(i) mu(i) ],'LineStyle','-','LineWidth',1,'Color','k','HandleVisibility','off');
        if (showOutliers && ~crossed && ~isempty(v) &&  max(v) < outlierSep)
            crossed=true;
            line([d d],[0 7],'LineStyle','--','LineWidth',2,'HandleVisibility','off');
            lastoutlier=sprintf('\\leftarrowLast Outlier %.1fr',d);
            text(d,6.5,lastoutlier,'Color','k','FontSize',14,'HandleVisibility','off');
        end
        
    end
    
    if (showOutliers)
        line([0.0001 d],[outlierSep + 0.2 outlierSep + 0.2],'LineStyle','--','LineWidth',2,'Color','k','HandleVisibility','off');
        text(d/4,2.5,'Outlier separator','HandleVisibility','off');
    end
    
    l=ylim;
    ylim([0 l(2)])
    
    % plot a line through the mean points
    s={'-k',':k','-.k','--k'};
    dn=sprintf('%s, CL=%.2f',names{e},connectivityLevels(e));
    plot(bins(2:length(bins))-(increment/2),mu(2:length(bins)),s{1},'DisplayName',names{e});
    if ~showOutliers
        ylim([0 3]);
    end
    xlim([0.0001 10]);
    title(dn);
%     legend('show')
end

end