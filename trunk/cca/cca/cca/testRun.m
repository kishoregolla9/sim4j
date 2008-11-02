function [cca_rb, mds_rb, CL, cca_rb_middle, mds_rb_middle]=testRun(number_of_nets,type,netSize,N,r,step,number_of_levels)
%Li - Oct. 2006, modified Dec 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function testRun generates a  given number of networks based on the 
% specified type, size and number of nodes. Then it runs CCA-MAP and 
% MDS-MAP algorithms to generate the average results using randomly selected
% three anchor nodes. It only generates results using range based method.
%
%number_of_nets: the number of networks that want to be computed
%type - 0/1/2/3/4/5/6/7/8/9/10 (
%  0:random square
%  1:grid square with 10% average placement errors
%  2:C-shape random
%  3:C-shape grid
%  4:rectangle random
%  5:rectangle grid with 10% placement error
%  6:L-shape random
%  7:L-shape grid with 10% placement error
%  8:loop random
%  9:loop grid with 10% placement error
%  10:irregular
%size - edge size of a square area for deployment. e.g., if size=r, then
%  the deployment area is rxr. in the rectangle random, size is the width to
%  length (length is taken as 10 unit) ratio
%N - number of nodes in most cases. In square grid, N=sizexsize; in rectangle grid,
%  Nxsize is the nubmer of nodes where size is the width and N length. in C shape grid,
%  N is about 79 when size=10; in L-shape grid, N is about 51
%r: starting connectivity level for testing
%step: steps through the connectivity levels
%numberOflevels:the highest connectivity level for testing
%CL: average connectivity levels of the nets computed, CL(1,:) contains
% the set of valuse of the radius used; CL(2,:) contains the average
% connectivity level; CL(3,:) and after contains the connectivity levels of
% all the individual nets.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
disp("testRun.m") 

CL=zeros(2,number_of_levels);
for ii=1:number_of_nets
	[network]=netDeployment(type,netSize,N);
#	disp("Plotting the network")
#	plot(network(:,1),network(:,2),'bo')
#	input("Press any key...\n")
	
	disp("Checking Network Connectivity ") 
	[disconnect]=NetworkConnectivityCheck(network,r);
	while (disconnect==1)
	    disp("Recalculating the network because disconnect==1\n")    
	    [network]=netDeployment(type,netSize,N);
	    [disconnect]=NetworkConnectivityCheck(network,r);
	end % while
	 
	disp("disconnect" + disconnect)
	
	[CL_all]=netConLevelsAssignment(network,r,step,number_of_levels);% assign the connectivity levels we'd compute
		
	CL(1,:)=CL_all(1,:); %all the radius that we're computing
	CL_everyNet(ii,:)=CL_all(2,:); %the node connectivity levels for the radius set of this net
	CL(2,:)=mean(CL_everyNet,1);
	N=size(network,1);
	
	% %compute the local maps using range-based method    
	[radiusNet,localMapTimeMean,localMapTimeMedian]=localMapComputing(network,CL_all,1);
	        
	% get anchor nodes
	N1=1;
	N2=int16(N/3);
	N3=int16(N*2/3+1);
	anchor(1,:)=[N1 N2 N3];
	anchor(2,:)=[N1+5 N2+5 N3+5];
	anchor(3,:)=[N1+10 N2+10 N3+10]; 
	%these anchor nodes are randomly chosen. Only work for network of size >50
	
	% get starting node to map patch
	N1=int16(rand*N)+1;
	if (N1==0) 
	    N1=1;
	end
	N2=int16(rand*N);
	if (N2==0) 
	    N2=1;
	end
	N3=int16(rand*N);
	if (N3==0) 
	    N3=1;
	end
	startNode=[N1 N2 N3];
	startNode=[N1 N2];
	%patch maps
	[cca_patchTime,cca_coordinates_median,cca_coordinates_median_average,cca_allResults]...
	=mapPatch(network,radiusNet,startNode,anchor);
	
	cca_eachNet_median(ii,:)=median(cca_coordinates_median);
	cca_eachNet_median_average(ii,:)=mean(cca_coordinates_median_average);
	  
	cca_rb=mean(cca_eachNet_median_average,1);
	cca_rb_middle=median(cca_eachNet_median,1);
	
	%compute MDS
	%prepare for MDS computing
	[t]=prepareMDSTestNetwork(network,CL_all,1);
	[mds_patchTime,mds_coordinates_median,mds_coordinates_median_average,mds_allResults]=batchMDSLocalization(t,startNode,anchor);
	
	mds_eachNet_median(ii,:)=median(mds_coordinates_median);
	mds_eachNet_median_average(ii,:)=mean(mds_coordinates_median_average);
	  
	mds_rb=mean(mds_eachNet_median_average,1);
	mds_rb_middle=median(mds_eachNet_median,1);

end % for

CL=[CL;CL_everyNet];
cca_rb=[cca_rb; cca_eachNet_median_average];
mds_rb=[mds_rb; mds_eachNet_median_average];

cca_rb_middle=[cca_rb_middle; cca_eachNet_median];
mds_rb_middle=[mds_rb_middle; mds_eachNet_median];



