function [ ci ] = getConfidenceInterval( confidence, data )

n=length(data);
criticalT=tinv(confidence,size(data,2));
% data=removeOutliers(sort(data),2);
ci=(criticalT*std(data)/sqrt(n));
end

