function [h] = plotCdf(results,anchors,radii,folder)

network=results.network;

for r=1:size(results,2)
    result=results(r);
    figureName=sprintf('The CDF of Results for Radius %.1f',...
        result.radius);
    h=figure('Name',figureName,'visible','off');
    hold off
    hold all
   
    x=removeOutliers([result.errors.mean]);
%     x=[result.errors.mean];
    x=sort(x,'descend');
    plot(x,'-o');
    plot(chi2cdf(x,1));
    plot(chi2cdf(x,length(x)));
    legend({'Mean Error','Chi2CDF 1','Chi2CDF'});
    
    title('Cumulative Distribution Function');
    
    filename=sprintf('CDF-%s-Radius%.1f',...
        network.shape,result.radius);
    saveFigure(folder,filename,h);
    
end

end

