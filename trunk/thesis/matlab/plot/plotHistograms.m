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
    x=removeOutliers([result.errors.max]);
    [n,xout] = hist(x,sqrt(length(x)));
    bar(xout,n,'b','LineWidth',1);
    x=removeOutliers([result.errors.mean]);
    [n,xout] = hist(x,sqrt(length(x)));
    bar(xout,n,'c','LineWidth',1);
    x=removeOutliers([result.errors.min]);
    [n,xout] = hist(x,sqrt(length(x)));
    bar(xout,n,'r','LineStyle','none');    
    legend({'Max Error','Mean Error','Min Error'});
    hold off;
    
    filename=sprintf('Histogram-%s-Radius%.1f',...
        network.shape,result.radius);
    saveFigure(folder,filename,h);
    
end

end

