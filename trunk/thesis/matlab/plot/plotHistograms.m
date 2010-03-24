function [h] = plotHistograms(results,anchors,radii,folder)

network=results.network;

for r=1:size(results,2)
    result=results(r);
    figureName=sprintf('The Histogram of Results for Radius %.1f',...
        result.radius);
    h=figure('Name',figureName,'visible','off');
    hold off
    
    hold all;
    grid on;
%     [x,outliers]=removeOutliers([result.errors.max]);
%     [n,xout] = hist(x,sqrt(length(x)));
%     bar(xout,n,'b','LineWidth',1);
    
%     x=[result.errors.mean];
%     x(outliers)=[];
    [x,outliers]=removeOutliers([result.errors.mean]);
    [n,xout] = hist(x,sqrt(length(x)));
    
    threshold=[0.25 0.5 1 2];
    pLess=zeros(length(threshold),1);
    for i=1:length(threshold)
        pLess(i)=sum(n(xout<threshold(i)))/sum(n);
    end
    
    bar(xout,n,'c','LineWidth',1);
    x=[result.errors.min];
    x(outliers)=[];
    [n,xout] = hist(x,sqrt(length(x)));
    bar(xout,n,'r','LineStyle','none');    
    legend({'Mean Error','Min Error'});
    t='';
    for i=1:length(threshold)
        t=sprintf('%sProbability of Mean Error less than %0.2f is %0.3f%c\n',...
        t,threshold(i),pLess(i)*100,'%');
    end
    title(t);
    hold off;
    
    filename=sprintf('Histogram-%s-Radius%.1f',...
        network.shape,result.radius);
    saveFigure(folder,filename,h);
    
end

end

