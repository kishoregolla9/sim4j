%Li - Dec 2006
%This script pacthes global maps for a set of different radius values of a
%given network, for range based cases, for a give number of anchor nodes, e.g., 
%three anchor nodes. The local maps should be computed using 
%known local distance. 
%Input: network, rxx_node, anchorx, and startNode
%Output: Median error of each patch map using each different start node and each different
%set of anchor nodes.Average median error, average patch time etc.
%Need to change: different number of anchor nodes, different number of sets
%of anchor nodes. anchorx means x anchor nodes. For example, anchor4 means
%each anchor node set has three anchor nodes.  

clear A;
clear T;
node=startNode

for j=1:4 %number of starting nodes

% for i=1:5
% %     [r25_node]=mapGlobalPatch(network,r25_node,node(j),anchor3(i,:),1,2.5);
% [e50r16_node]=mapVitPatch(network,e50r16_node,node(j),anchor3(i,:),1.6);
%     e50r16_node(node(j))
%     A(i)=(e50r16_node(node(j)).patched_net_coordinates_error_median(1)+e50r16_node(node(j)).patched_net_coordinates_error_median(2))/2
%     T(i)=e50r16_node(node(j)).map_patchTime;
% end
% error_effect_r16_3AnchorCompare_l20(6,:,j)=A;
% error_effect_r16_3Anchor_patchTime_l20(j,6)=median(T');
% error_effect_r16_3Anchor_Median_l20(j,6)=median(A');
% error_effect_r16_3Anchor_Median_average_l20(j,6)=mean(A');
% clear A;
% clear T;
% 
% for i=1:5
% %     [r25_node]=mapGlobalPatch(network,r25_node,node(j),anchor3(i,:),1,2.5);
% [e50r22_node]=mapVitPatch(network,e50r22_node,node(j),anchor3(i,:),2.2);
%     e50r22_node(node(j))
%     A(i)=(e50r22_node(node(j)).patched_net_coordinates_error_median(1)+e50r22_node(node(j)).patched_net_coordinates_error_median(2))/2
%     T(i)=e50r22_node(node(j)).map_patchTime;
% end
% error_effect_r22_3AnchorCompare_l20(6,:,j)=A;
% error_effect_r22_3Anchor_patchTime_l20(j,6)=median(T');
% error_effect_r22_3Anchor_Median_l20(j,6)=median(A');
% error_effect_r22_3Anchor_Median_average_l20(j,6)=mean(A');
% clear A;
% clear T;

for i=1:5
%     [r25_node]=mapGlobalPatch(network,r25_node,node(j),anchor3(i,:),1,2.5);
[e10r18_node]=mapVitPatch(network,e10r18_node,node(j),anchor3(i,:),1.8);
    e10r18_node(node(j))
    A(i)=(e10r18_node(node(j)).patched_net_coordinates_error_median(1)+e10r18_node(node(j)).patched_net_coordinates_error_median(2))/2
    T(i)=e10r18_node(node(j)).map_patchTime;
end
error_effect_r18_3AnchorCompare_l20(2,:,j)=A;
error_effect_r18_3Anchor_patchTime_l20(j,2)=median(T');
error_effect_r18_3Anchor_Median_l20(j,2)=median(A');
error_effect_r18_3Anchor_Median_average_l20(j,2)=mean(A');
clear A;
clear T;


end
% 
% 
