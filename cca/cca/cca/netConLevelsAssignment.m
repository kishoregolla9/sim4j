function [CL_all]=netConLevelsAssignment(network,initial_r,step,numberOflevels)

%This function takes the initial radius value of initial_r and generates the
%CL_all that shows the radius and their corresponding connectivity level 
%with the defined step. It generates "numberOflevels" radius levels paced by 
%the "step" starting from "initial_r". 
%When running localization algorithms, the radio radius values can be taken from here.

%network : the input deployed network (Nx2 matrix);
%initial_r: the starting radius value
%step: the increment of radius, e.g., 0.05
%numberOflevels: the total number of radius values that want to be
%considered for testing.

radius=initial_r;
NetworkConnectivityPlot(network, initial_r) %it will show if using the shortest radio radius value 
%given in CL_all will result in a partitioned network
size=numberOflevels;
for ii=1:size
    [node,cl]=network_neighborMap(network,radius);
    CL_all(1,ii)=radius;
    CL_all(2,ii)=cl;
    radius=radius+step;
end
