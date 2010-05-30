function [h] = doPlotErrorBars(data,confidence,pointSpec)

% plot the actual data points (under the error bars)
for i=1:size(data,1)
   plot(repmat(i,size(data,2)),data(i,:),pointSpec);
end

[ci]=getConfidenceInterval(confidence,data');
mu=mean(data,2);
h=errorbar(mu,ci,'o');
end