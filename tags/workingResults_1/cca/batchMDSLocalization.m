function [patchTime,coordinates_median,coordinates_median_average,allResults]=batchMDSLocalization(t,startNode,anchor)

%This script takes the t(i) from either prepareMDSTestNetwork.m or
%generateMDSNetwork.m to run the MDSSolver2
%Need the following: startNode, anchor, CL_all.
%Need to change x in "anchorx" and in the output variable of
%"mds_distributedDistance_xAnchor..."

% startNode=[56, 27, 15, 73]; %need to change this for different networks
sn=size(startNode,2);
nn=size(t,2);
an=size(anchor,1);
for ii=1:nn %number of connectivity levels to be computed
  for j=1:sn %number of starting nodes. 4 start nodes here
      t(ii).startNode=startNode(j);
      for i=1:an %number of anchor sets. 
          t(ii).anchorNodes=anchor(i,:); %assign anchor nodes. Need to prepare anchor3 for this
          net=MDSSolver2(t(ii));
          T(i)=net.patchtime;
          A(i)=mean((median(abs(net.xy-net.xyEstimate)))')/t(ii).radioRadius %median of the coordinate error
      end

    allResults(ii,:,j)=A;
    patchTime(j,ii)=median(T');
    coordinates_median(j,ii)=median(A')
    coordinates_median_average(j,ii)=mean(A')
    clear A;
    clear T;
  end
end
          
          
          