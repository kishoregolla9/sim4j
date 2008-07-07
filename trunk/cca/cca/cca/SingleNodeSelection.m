function [npick]=SingleNodeSelection(network,m,x1,x2,y1,y2)
%select 1 node for the C-shaped random network in a 10x10 area, from a
%indicated region defined by x1, x2, y1 ,y2. The selction process start
%from node "m". That is the selected node has its index number bigger than
%m.
N=size(network,1);

for i=m:N
    if ((network(i,1)<x2)&(network(i,1)>x1)&(network(i,2)<y2)&(network(i,2)>y1))
        npick=i;
    end
end

    
    