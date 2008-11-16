This directory has files for both MDS and CCA localization. 

testRun allows you to generate a set of networks and select a set of radio ranges for
the networks. Then it computes the localization results using both CCA and MDS methods. It
only does range-based computing. testRun_rf does the range-free cases for you. 

A step by step way to run the experiements can be done like the following. You can then write
scripts to do batch computing on set of networks by using these steps. 
Follow the steps to run cca localization experiments on one network:
(1) use [network]=netDeployment(type,size,N) to generate the network of the required 
size and topology;
e.g., [network]=netDeployment(1,10,100) for a gird network in a 10x10 area.

(2)Can plot(network(:,1),network(:,2),'bo') to see what it looks like. :)

(3)Figure out what set of radio radius and connectivity levels are of interests. May
use NetworkConnectivityPlot(network,r), e.g., NetworkConnectivityPlot(network,1.2), to 
see if the network is connected for a given a certain r. Can use 
[node,connectivity_level]=neighborMap(network,r)to check out the average node 
connectivity level of a given r.

[disconnect]=NetworkConnectivityCheck(network,r) would tell you if the network is disconneted
at a given r. 

These functions kind of do some similar things to check the connectivity levels and to 
plot the connectivity diagram. 

(4) To prepare for testing across multiple radius levels, can use function
[CL_all]=netConLevelsAssignment(network,initial_r,step,numberOflevels), e.g.,
[CL_all]=netConLevelsAssignment(network,1.3,0.05,24)

This function tells you if the smallest radius "initial_r" would leave the network partitioned. 
It also plots for you the network ocnnectivity diagram at the initial_r.

Check to see what CL_all you get. 

(5)Compute local maps using localMapCOmputing.m -
[radiusNet,localMapTimeMean,localMapTimeMedian]=localMapComputing(network,CL_all,option)
where option selects range based (option=1) or range free (option=0) method
e.g.,
[rb_radiusNet,rb_localMapTimeMean,rb_localMapTimeMedian]=localMapComputing(network,CL_all,1)
generates the local maps for "network" at each of the connectivity levels given in the CL_all
using range based method and stores the local maps in rb_radiusNet{}. It also calculates the 
local map computing time.

(6)Select anchor nodes for map patching. have a set of scrips and functions for different
topolofies that may be tried. FOr example, may use [anchor]=anchorNodesSelectionCshape100(network,m,n),
or anchorNodesSelectionSquare100.m or other similar functions (e.g., SingleNodeSelection.m)
to get anchors or anchor sets. Sometimes, you get error when running these scripts/functions.
That often means the area where you want to select an anchor node has no node in it to be selected.
The SingleNodeSelection.m may be used to get anchor nodes in desired area one by one.
Can also randomly pick up the node index to form the "anchor", 
e.g., anchor3 =[2, 20 ,95; 15, 30, 86] has two three anchor node sets. Can have multiple 
anchor sets. So may need to form 
'anchor' which is an matrix of MxN (M sets with each set has N anchor nodes. M>=1, N>=3)

(7)Select starting nodes for map patch. May use [npick]=SingleNodeSelection(network,1,1,3,4,6)to 
pick nodes from different part of the network. Should form a startNode=[a b c ...] array that 
contains the starting node for map patching that want to experiment with. 
For example, startNode=[5 20 99]. Also have a startNodeSelection script which may work or
may not work well depends on the network.  
  
(8)To patch local maps to obtain the node coordinates, use function in mapPatch.m,
[patchTime,coordinates_median,coordinates_median_average,allResults]=mapPatch(network, radiusNet,startNode,anchor,CL_all)
e.g., 

[rb_3anchor_patchTime,rb_3anchor_coordinates_median,rb_3anchor_coordinates_median_average,rb_3anchor_allResults]
=mapPatch(network,rb_radiusNet,startNode,anchor3)

will generate testing results across the connectivity leves using different anchor sets of three anchor
nodes and different starting nodes. 

Follow the steps here to do mds localization experiments using the same network configurations as used 
in the CCA experiments above:
(1)use [t]=prepareMDSTestNetwork(network,CL,option) to get t(i). CL=CL_all(1,:) using if using CL_all 
generated in the above CCA steps. E.g.,[t]=prepareMDSTestNetwork(network,CL_all(1,:),1)
(2)run script batchMDSLocalization. Make sure that the "startNode" and "anchor" are the same as in
the CCA experiments if comparisons are wanted. 