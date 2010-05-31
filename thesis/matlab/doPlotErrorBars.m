function [h] = doPlotErrorBars(data,confidence,pointSpec,x)

% plot the actual data points (under the error bars)
for i=1:size(data,1)
    if (exist('x','var'))
        plot(repmat(x,size(data,2)),data(i,:),pointSpec);
    else
        plot(repmat(i,size(data,2)),data(i,:),pointSpec);
    end
end

[ci]=getConfidenceInterval(confidence,data');
mu=mean(data,2);
if (exist('x','var'))
    h=errorbar(x,mu,ci,'o');
else
    h=errorbar(mu,ci,'o');
end
end