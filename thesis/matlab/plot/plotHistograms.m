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
    [x,outliers]=removeOutliers([result.errors.max]);
    [n,xout] = hist(x,sqrt(length(x)));
    bar(xout,n,'b','LineWidth',1);
    
    x=[result.errors.mean];
    x(outliers)=[];
    [n,xout] = hist(x,sqrt(length(x)));
    
    threshold=0.2;
    pLess=sum(n(xout<threshold))/sum(n);
    
    bar(xout,n,'c','LineWidth',1);
    x=[result.errors.min];
    x(outliers)=[];
    [n,xout] = hist(x,sqrt(length(x)));
    bar(xout,n,'r','LineStyle','none');    
    legend({'Max Error','Mean Error','Min Error'});
    t=sprintf('Probability of Mean Error less than %0.2f is %0.3f%c',...
        threshold,pLess*100,'%');
    title(t);
    hold off;
    
    filename=sprintf('Histogram-%s-Radius%.1f',...
        network.shape,result.radius);
    saveFigure(folder,filename,h);
    
end

end

