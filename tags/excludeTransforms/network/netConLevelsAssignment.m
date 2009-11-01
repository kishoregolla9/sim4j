function [connectivityLevels]=netConLevelsAssignment(network,initialRadius,step,numberOflevels)

%This function takes the initial radius value of initialRadius and generates the
%connectivityLevels that shows the radius and their corresponding connectivity level 
%with the defined step. It generates "numberOflevels" radius levels paced by 
%the "step" starting from "initialRadius". 
%When running localization algorithms, the radio radius values can be taken from here.

%network : the input deployed network (Nx2 matrix);
%initialRadius: the starting radius value
%step: the increment of radius, e.g., 0.05
%numberOflevels: the total number of radius values that want to be
%considered for testing.

radius=initialRadius;
size=numberOflevels;
connectivityLevels=zeros(2,size);
for ii=1:size
    [node,cl]=neighborMap(network,radius);
    connectivityLevels(1,ii)=radius;
    connectivityLevels(2,ii)=cl;
    radius=radius+step;
end
