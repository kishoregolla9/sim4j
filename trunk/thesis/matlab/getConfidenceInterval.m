function [ ci ] = getConfidenceInterval( confidence, data )

n=length(data);
criticalT=1.984;
% data=removeOutliers(sort(data),2);
ci=(criticalT*std(data)/sqrt(n));
end

