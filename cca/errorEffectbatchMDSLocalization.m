%This script takes the t(i) from either prepareMDSTestNetwork.m or
%generateMDSNetwork.m to run the MDSSolver2
%Need the following: startNode, anchor, CL_all.
%Need to change x in "anchorx" and in the output variable of
%"mds_distributedDistance_xAnchor..."

% startNode=[56, 27, 15, 73]; %need to change this for different networks
sn=size(startNode,2);
nn=size(t,2);
clear A;
% for ii=1:nn
  for j=1:sn %number of starting nodes. 
      t(9).startNode=startNode(j);
      for i=1:5 %number of anchor sets. 
          t(9).anchorNodes=anchor3(i,:); %assign anchor nodes. Need to prepare anchor3 for this
          net=MDSSolver2(t(9));
          A(i)=mean((median(abs(net.xy-net.xyEstimate)))')/CL_all(1,9) %median of the coordinate error
      end

    error_effect_mds_r16_3AnchorCompare(1,:,j)=A;
    error_effect_mds_r16_3Anchor_Median(j,1)=median(A')
    error_effect_mds_r16_3Anchor_Median_average(j,1)=mean(A')
    clear A;
  end
  
  for j=1:sn %number of starting nodes. 
      t(13).startNode=startNode(j);
      for i=1:5 %number of anchor sets. 
          t(13).anchorNodes=anchor3(i,:); %assign anchor nodes. Need to prepare anchor3 for this
          net=MDSSolver2(t(13));
          A(i)=mean((median(abs(net.xy-net.xyEstimate)))')/CL_all(1,13) %median of the coordinate error
      end

    error_effect_mds_r18_3AnchorCompare(1,:,j)=A;
    error_effect_mds_r18_3Anchor_Median(j,1)=median(A')
    error_effect_mds_r18_3Anchor_Median_average(j,1)=mean(A')
    clear A;
  end
  
  for j=1:sn %number of starting nodes. 4 start nodes here
      t(17).startNode=startNode(j);
      for i=1:5 %number of anchor sets.
          t(17).anchorNodes=anchor3(i,:); %assign anchor nodes. Need to prepare anchor3 for this
          net=MDSSolver2(t(17));
          A(i)=mean((median(abs(net.xy-net.xyEstimate)))')/CL_all(1,17) %median of the coordinate error
      end

    error_effect_mds_r22_3AnchorCompare(1,:,j)=A;
    error_effect_mds_r22_3Anchor_Median(j,1)=median(A')
    error_effect_mds_r22_3Anchor_Median_average(j,1)=mean(A')
    clear A;
  end
% end
          
          
          