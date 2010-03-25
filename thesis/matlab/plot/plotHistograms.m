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
    %     nbins=sqrt(length(x));
    %     [n,xout] = hist(x,nbins);
    %     bar(xout,n,'b','LineWidth',1);
    
    %     x=[result.errors.mean];
    %     x(outliers)=[];
    x=removeOutliers([result.errors.mean]);
    %         nbins=sqrt(length(x))
    %     nbins=2*nthroot(3,1/3)*nthroot(pi,1/6)*std(x),nthroot(length(x),-1/3)
    nbins=optBINS(x,10,length(x));
    
    [n,xout] = hist(x,nbins);
    bar(xout,n,'c','LineWidth',1);
    xlabel(sprintf('%i bins',nbins));
    
    threshold=[0.25 0.5 1 2];
    pLess=zeros(length(threshold),1);
    for i=1:length(threshold)
        pLess(i)=sum(n(xout<threshold(i)))/sum(n);
    end


%     x=[result.errors.min];
%     x(outliers)=[];
%     %     nbins=sqrt(length(x));
%     nbins=optBINS(x,1,length(x))
%     [n,xout] = hist(x,nbins);
%     bar(xout,n,'r','LineStyle','none');
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

% optBINS computes the optimal number of bins for a given one-dimensional
% data set. This optimization is based on the posterior probability for
% the number of bins
%
% Usage:
% optM = optBINS(data,minM,maxM);
%
% Where:
% data is a (1,N) vector of data points
% minM is the minimum number of bins to consider
% maxM is the maximum number of bins to consider
%
% This algorithm uses a brute-force search trying every possible bin number
% in the given range. This can of course be improved.
% Generalization to multidimensional data sets is straightforward.
%
% Created by Kevin H. Knuth on 17 April 2003
% Modified by Kevin H. Knuth on 21 February 2006
% http://arxiv.org/PS_cache/physics/pdf/0605/0605197v1.pdf
function optM = optBINS(data,minM,maxM)
if (size(data,1)~=1) && (size(data,2)<2)
    error('data dimensions must be (1,N)');
end
N = size(data,2);
% Simply loop through the different numbers of bins
% and compute the posterior probability for each.
logp = zeros(1,maxM);
for M = minM:maxM
    n = hist(data,M); % Bin the data (equal width bins here)
    part1 = N*log(M) + gammaln(M/2) - gammaln(N+M/2);
    part2 = - M*gammaln(1/2) + sum(gammaln(n+0.5));
    logp(M) = part1 + part2;
end
[~, optM] = max(logp);
end




