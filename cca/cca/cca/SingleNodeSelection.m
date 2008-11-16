function [npick]=SingleNodeSelection(network,m,x1,x2,y1,y2)
%select 1 node for the C-shaped random network in a 10x10 area, from a
%indicated region defined by x1, x2, y1 ,y2. The selction process start
%from node "m". That is the selected node has its index number bigger than
%m.
points=network.points;
N=size(points,1);

for i=m:N
    if (   (points(i,1)<x2) && (points(i,1)>x1) && (points(i,2)<y2) && (points(i,2)>y1) )
        npick=i;
    end
end

    
    