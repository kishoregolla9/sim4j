%computes average local map compute time for a network in range free case. 
%Use it after local maps are computed using only the connectivity information.
% Need variables: network, Crxx_node;
clear compute_timeC;
N=size(network); %get nubmer of nodes

clear compute_timeC;

% for i=1:N
% compute_timeC(i)=e50r16_node(i).local_map_compuTime;
% end
% localMapComputTime_errorEffect_r16(6)=mean(compute_timeC');
% localMapComputTime_errorEffect_r16_median(6)=median(compute_timeC');
% 
% clear compute_timeC;
% 
% for i=1:N
% compute_timeC(i)=e50r22_node(i).local_map_compuTime;
% end
% localMapComputTime_errorEffect_r22_level20(6)=mean(compute_timeC');
% localMapComputTime_errorEffect_r22_median_level20(6)=median(compute_timeC');


% clear compute_timeC;

for i=1:N
compute_timeC(i)=e10r18_node(i).local_map_compuTime;
end
localMapComputTime_errorEffect_r18(2)=mean(compute_timeC');
localMapComputTime_errorEffect_r18_median(2)=median(compute_timeC');

clear compute_timeC;
