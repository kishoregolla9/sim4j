function [anchor3]=anchorNodesSelectionSquare100(network)
N=size(network,1);
anchor3=zeros(5,3);
for i=1:N
    if ((network(i,1)<7)&(network(i,1)>3)&(network(i,2)<2)&(network(i,2)>0))
        if ((~ismember(i,anchor3(1,:)))&(anchor3(1,1)==0))
            anchor3(1,1)=i;
        end
    end
    if((network(i,1)<2)&(network(i,1)>0)&(network(i,2)<10)&(network(i,2)>7))
        if((~ismember(i,anchor3(1,:)))&(anchor3(1,2)==0))
            anchor3(1,2)=i;
        end
    end
    if((network(i,1)<10)&(network(i,1)>8)&(network(i,2)<10)&(network(i,2)>7))
        if((~ismember(i,anchor3(1,:)))&(anchor3(1,3)==0))
            anchor3(1,3)=i;
        end
    end
end
anchor3(1,:)=sort(anchor3(1,:));

for i=10:N
    if ((network(i,1)<5)&(network(i,1)>3)&(network(i,2)<4)&(network(i,2)>2))
        if ((~ismember(i,anchor3(2,:)))&(anchor3(2,1)==0))
            anchor3(2,1)=i;
        end
    end
    if((network(i,1)<6)&(network(i,1)>3)&(network(i,2)<7)&(network(i,2)>5))
        if((~ismember(i,anchor3(2,:)))&(anchor3(2,2)==0))
            anchor3(2,2)=i;
        end
    end
    if((network(i,1)<7)&(network(i,1)>5)&(network(i,2)<5)&(network(i,2)>3))
        if((~ismember(i,anchor3(2,:)))&(anchor3(2,3)==0))
            anchor3(2,3)=i;
        end
    end
end
anchor3(2,:)=sort(anchor3(2,:));

for i=20:N
    if ((network(i,1)<7)&(network(i,1)>3)&(network(i,2)<7)&(network(i,2)>4))
        if ((~ismember(i,anchor3(3,:)))&(anchor3(3,1)==0))
            anchor3(3,1)=i;
        end
    end
    if((network(i,1)<2)&(network(i,1)>0)&(network(i,2)<10)&(network(i,2)>7))
        if((~ismember(i,anchor3(3,:)))&(anchor3(3,2)==0))
            anchor3(3,2)=i;
        end
    end
    if((network(i,1)<10)&(network(i,1)>8)&(network(i,2)<10)&(network(i,2)>7))
        if((~ismember(i,anchor3(3,:)))&(anchor3(3,3)==0))
            anchor3(3,3)=i;
        end
    end
end
anchor3(3,:)=sort(anchor3(3,:));

for i=30:N
    if ((network(i,1)<2)&(network(i,1)>0)&(network(i,2)<10)&(network(i,2)>7))
        if ((~ismember(i,anchor3(4,:)))&(anchor3(4,1)==0))
            anchor3(4,1)=i;
        end
    end
    if((network(i,1)<2)&(network(i,1)>0)&(network(i,2)<6)&(network(i,2)>3))
        if((~ismember(i,anchor3(4,:)))&(anchor3(4,2)==0))
            anchor3(4,2)=i;
        end
    end
    if((network(i,1)<6)&(network(i,1)>4)&(network(i,2)<7)&(network(i,2)>4))
        if((~ismember(i,anchor3(4,:)))&(anchor3(4,3)==0))
            anchor3(4,3)=i;
        end
    end
end
anchor3(4,:)=sort(anchor3(4,:));

for i=10:N
    if ((network(i,1)<7)&(network(i,1)>3)&(network(i,2)<3)&(network(i,2)>0.8))
        if ((~ismember(i,anchor3(5,:)))&(anchor3(5,1)==0))
            anchor3(5,1)=i;
        end
    end
    if((network(i,1)<3)&(network(i,1)>0.8)&(network(i,2)<9)&(network(i,2)>6.5))
        if((~ismember(i,anchor3(5,:)))&(anchor3(5,2)==0))
            anchor3(5,2)=i;
        end
    end
    if((network(i,1)<9)&(network(i,1)>7)&(network(i,2)<9)&(network(i,2)>6.5))
        if((~ismember(i,anchor3(5,:)))&(anchor3(5,3)==0))
            anchor3(5,3)=i;
        end
    end
end
anchor3(5,:)=sort(anchor3(5,:));
    
    
        