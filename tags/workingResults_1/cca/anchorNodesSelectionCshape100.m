function [anchor]=anchorNodesSelectionCshape100(network,m,n)
%Select anchor nodes for Cshaped networks. "m" is the starting node ID to
%search for anchor nodes. "n" is the number of anchor nodes in each
%selsected set. Will generate multiple sets of anchor nodes in different
%ares of the network.
N=size(network,1);
if (n==3)
    anchor=zeros(5,3);
    for i=m:N
        if ((network(i,1)<7)&(network(i,1)>3)&(network(i,2)<2.6)&(network(i,2)>0.7))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,1)==0))
                anchor(1,1)=i;
            end
        end
        if((network(i,1)<2.5)&(network(i,1)>0.5)&(network(i,2)<7)&(network(i,2)>3))
            if((~ismember(i,anchor(1,:)))&(anchor(1,2)==0))
                anchor(1,2)=i;
            end
        end
        if((network(i,1)<7)&(network(i,1)>3)&(network(i,2)<9.6)&(network(i,2)>7.3))
            if((~ismember(i,anchor(1,:)))&(anchor(1,3)==0))
                anchor(1,3)=i;
            end
        end
    end
    anchor(1,:)=sort(anchor(1,:));

    for i=m:N
        if ((network(i,1)<9.5)&(network(i,1)>7)&(network(i,2)<3)&(network(i,2)>0.7))
            if ((~ismember(i,anchor(2,:)))&(anchor(2,1)==0))
                anchor(2,1)=i;
            end
        end
        if((network(i,1)<2.5)&(network(i,1)>0.5)&(network(i,2)<7)&(network(i,2)>3))
            if((~ismember(i,anchor(2,:)))&(anchor(2,2)==0))
                anchor(2,2)=i;
            end
        end
        if((network(i,1)<9.5)&(network(i,1)>7)&(network(i,2)<9.6)&(network(i,2)>7.3))
            if((~ismember(i,anchor(2,:)))&(anchor(2,3)==0))
                anchor(2,3)=i;
            end
        end
    end
    anchor(2,:)=sort(anchor(2,:));

    for i=m:N
        if ((network(i,1)<4)&(network(i,1)>2)&(network(i,2)<3.2)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(3,:)))&(anchor(3,1)==0))
                anchor(3,1)=i;
            end
        end
        if((network(i,1)<2.1)&(network(i,1)>0.3)&(network(i,2)<7)&(network(i,2)>3.5))
            if((~ismember(i,anchor(3,:)))&(anchor(3,2)==0))
                anchor(3,2)=i;
            end
        end
        if((network(i,1)<4)&(network(i,1)>2)&(network(i,2)<9.6)&(network(i,2)>6.7))
            if((~ismember(i,anchor(3,:)))&(anchor(3,3)==0))
                anchor(3,3)=i;
            end
        end
    end
    anchor(3,:)=sort(anchor(3,:));

    for i=m:N
        if ((network(i,1)<2.8)&(network(i,1)>0.3)&(network(i,2)<5.8)&(network(i,2)>4))
            if ((~ismember(i,anchor(4,:)))&(anchor(4,1)==0))
                anchor(4,1)=i;
            end
        end
        if((network(i,1)<6)&(network(i,1)>3)&(network(i,2)<9.8)&(network(i,2)>8.6))
            if((~ismember(i,anchor(4,:)))&(anchor(4,2)==0))
                anchor(4,2)=i;
            end
        end
        if((network(i,1)<9.5)&(network(i,1)>6.5)&(network(i,2)<8.6)&(network(i,2)>7.1))
            if((~ismember(i,anchor(4,:)))&(anchor(4,3)==0))
                anchor(4,3)=i;
            end
        end
    end
    anchor(4,:)=sort(anchor(4,:));

    for i=m:N
        if ((network(i,1)<2)&(network(i,1)>0.3)&(network(i,2)<8.5)&(network(i,2)>6.5))
            if ((~ismember(i,anchor(5,:)))&(anchor(5,1)==0))
                anchor(5,1)=i;
            end
        end
        if((network(i,1)<7)&(network(i,1)>3)&(network(i,2)<9.8)&(network(i,2)>8.5))
            if((~ismember(i,anchor(5,:)))&(anchor(5,2)==0))
                anchor(5,2)=i;
            end
        end
        if((network(i,1)<9.8)&(network(i,1)>7)&(network(i,2)<8.5)&(network(i,2)>6.5))
            if((~ismember(i,anchor(5,:)))&(anchor(5,3)==0))
                anchor(5,3)=i;
            end
        end
    end
    anchor(5,:)=sort(anchor(5,:));
hold off;
subplot(3,2,1)
plot(network(:,1),network(:,2),'bo')
hold on
plot(network(anchor(1,1),1),network(anchor(1,1),2),'ro')
plot(network(anchor(1,2),1),network(anchor(1,2),2),'ro')
plot(network(anchor(1,3),1),network(anchor(1,3),2),'ro')
subplot(3,2,2)
plot(network(:,1),network(:,2),'bo')
hold on
plot(network(anchor(2,1),1),network(anchor(2,1),2),'ro')
plot(network(anchor(2,2),1),network(anchor(2,2),2),'ro')
plot(network(anchor(2,3),1),network(anchor(2,3),2),'ro')
subplot(3,2,3)
plot(network(:,1),network(:,2),'bo')
hold on
plot(network(anchor(3,1),1),network(anchor(3,1),2),'ro')
plot(network(anchor(3,2),1),network(anchor(3,2),2),'ro')
plot(network(anchor(3,3),1),network(anchor(3,3),2),'ro')
subplot(3,2,4)
plot(network(:,1),network(:,2),'bo')
hold on
plot(network(anchor(4,1),1),network(anchor(4,1),2),'ro')
plot(network(anchor(4,2),1),network(anchor(4,2),2),'ro')
plot(network(anchor(4,3),1),network(anchor(4,3),2),'ro')
subplot(3,2,5)
plot(network(:,1),network(:,2),'bo')
hold on
plot(network(anchor(5,1),1),network(anchor(5,1),2),'ro')
plot(network(anchor(5,2),1),network(anchor(5,2),2),'ro')
plot(network(anchor(5,3),1),network(anchor(5,3),2),'ro') 

end

if(n==4)
    anchor=zeros(5,4);
    for i=m:N
        if ((network(i,1)<7)&(network(i,1)>3.5)&(network(i,2)<2.6)&(network(i,2)>0.7))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,1)==0))
                anchor(1,1)=i;
            end
        end
        if((network(i,1)<2.8)&(network(i,1)>1.5)&(network(i,2)<8.3)&(network(i,2)>5))
            if((~ismember(i,anchor(1,:)))&(anchor(1,2)==0))
                anchor(1,2)=i;
            end
        end
        if((network(i,1)<7)&(network(i,1)>3.5)&(network(i,2)<9.6)&(network(i,2)>7.3))
            if((~ismember(i,anchor(1,:)))&(anchor(1,3)==0))
                anchor(1,3)=i;
            end
        end
        if((network(i,1)<2.1)&(network(i,1)>0.3)&(network(i,2)<=5)&(network(i,2)>2.6))
            if((~ismember(i,anchor(1,:)))&(anchor(1,4)==0))
                anchor(1,4)=i;
            end
        end
    end
    anchor(1,:)=sort(anchor(1,:));
    
    for i=m:N
        if ((network(i,1)<9.5)&(network(i,1)>7)&(network(i,2)<3)&(network(i,2)>0.7))
            if ((~ismember(i,anchor(2,:)))&(anchor(2,1)==0))
                anchor(2,1)=i;
            end
        end
        if((network(i,1)<2.5)&(network(i,1)>0.5)&(network(i,2)<8.3)&(network(i,2)>5))
            if((~ismember(i,anchor(2,:)))&(anchor(2,2)==0))
                anchor(2,2)=i;
            end
        end
         if((network(i,1)<2.5)&(network(i,1)>0.5)&(network(i,2)<=5)&(network(i,2)>2.6))
            if((~ismember(i,anchor(2,:)))&(anchor(2,3)==0))
                anchor(2,3)=i;
            end
        end
        if((network(i,1)<9.5)&(network(i,1)>7)&(network(i,2)<9.6)&(network(i,2)>7.3))
            if((~ismember(i,anchor(2,:)))&(anchor(2,4)==0))
                anchor(2,4)=i;
            end
        end
    end
    anchor(2,:)=sort(anchor(2,:));
    
    for i=m:N
        if ((network(i,1)<4)&(network(i,1)>2)&(network(i,2)<1.8)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(3,:)))&(anchor(3,1)==0))
                anchor(3,1)=i;
            end
        end
        if((network(i,1)<1.5)&(network(i,1)>0.3)&(network(i,2)<8.5)&(network(i,2)>5.5))
            if((~ismember(i,anchor(3,:)))&(anchor(3,2)==0))
                anchor(3,2)=i;
            end
        end
        if((network(i,1)<3)&(network(i,1)>1.7)&(network(i,2)<5.6)&(network(i,2)>2.8))
            if((~ismember(i,anchor(3,:)))&(anchor(3,3)==0))
                anchor(3,3)=i;
            end
        end
        if((network(i,1)<4)&(network(i,1)>2)&(network(i,2)<9.6)&(network(i,2)>7.5))
            if((~ismember(i,anchor(3,:)))&(anchor(3,4)==0))
                anchor(3,4)=i;
            end
        end
    end
    anchor(3,:)=sort(anchor(3,:));
    
    for i=m:N
        if ((network(i,1)<2.8)&(network(i,1)>0.3)&(network(i,2)<5.8)&(network(i,2)>4))
            if ((~ismember(i,anchor(4,:)))&(anchor(4,1)==0))
                anchor(4,1)=i;
            end
        end
        if((network(i,1)<6)&(network(i,1)>3)&(network(i,2)<9.8)&(network(i,2)>8.6))
            if((~ismember(i,anchor(4,:)))&(anchor(4,2)==0))
                anchor(4,2)=i;
            end
        end
        if((network(i,1)<9.5)&(network(i,1)>6.5)&(network(i,2)<8.6)&(network(i,2)>7.1))
            if((~ismember(i,anchor(4,:)))&(anchor(4,3)==0))
                anchor(4,3)=i;
            end
        end
        if ((network(i,1)<4)&(network(i,1)>2)&(network(i,2)<2.8)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(4,:)))&(anchor(4,4)==0))
                anchor(4,4)=i;
            end
        end
    end
    anchor(4,:)=sort(anchor(4,:));
    for i=m:N
        if ((network(i,1)<2)&(network(i,1)>0.3)&(network(i,2)<8.5)&(network(i,2)>6.5))
            if ((~ismember(i,anchor(5,:)))&(anchor(5,1)==0))
                anchor(5,1)=i;
            end
        end
        if((network(i,1)<7)&(network(i,1)>3)&(network(i,2)<9.8)&(network(i,2)>8.5))
            if((~ismember(i,anchor(5,:)))&(anchor(5,2)==0))
                anchor(5,2)=i;
            end
        end
        if((network(i,1)<9.8)&(network(i,1)>7)&(network(i,2)<8.5)&(network(i,2)>6.5))
            if((~ismember(i,anchor(5,:)))&(anchor(5,3)==0))
                anchor(5,3)=i;
            end
        end
        if ((network(i,1)<4)&(network(i,1)>2)&(network(i,2)<2.5)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(5,:)))&(anchor(5,4)==0))
                anchor(5,4)=i;
            end
        end
    end
    anchor(5,:)=sort(anchor(5,:));
end
if(n==5)
    anchor=zeros(4,5);
    for i=m:N
        if ((network(i,1)<7)&(network(i,1)>3.5)&(network(i,2)<2.6)&(network(i,2)>0.7))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,1)==0))
                anchor(1,1)=i;
            end
        end
        if((network(i,1)<2.8)&(network(i,1)>1.5)&(network(i,2)<8.3)&(network(i,2)>5))
            if((~ismember(i,anchor(1,:)))&(anchor(1,2)==0))
                anchor(1,2)=i;
            end
        end
        if((network(i,1)<7)&(network(i,1)>3.5)&(network(i,2)<9.6)&(network(i,2)>7.3))
            if((~ismember(i,anchor(1,:)))&(anchor(1,3)==0))
                anchor(1,3)=i;
            end
        end
        if((network(i,1)<2.1)&(network(i,1)>0.3)&(network(i,2)<=5)&(network(i,2)>2.6))
            if((~ismember(i,anchor(1,:)))&(anchor(1,4)==0))
                anchor(1,4)=i;
            end
        end
        if ((network(i,1)<9.5)&(network(i,1)>7)&(network(i,2)<3)&(network(i,2)>0.7))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,5)==0))
                anchor(1,5)=i;
            end
        end
    end
    anchor(1,:)=sort(anchor(1,:));
    
    for i=m:N
        if ((network(i,1)<8.5)&(network(i,1)>5)&(network(i,2)<3)&(network(i,2)>0.7))
            if ((~ismember(i,anchor(2,:)))&(anchor(2,1)==0))
                anchor(2,1)=i;
            end
        end
        if ((network(i,1)<4)&(network(i,1)>2)&(network(i,2)<3.2)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(2,:)))&(anchor(2,2)==0))
                anchor(2,2)=i;
            end
        end
        if((network(i,1)<2.1)&(network(i,1)>0.3)&(network(i,2)<7)&(network(i,2)>3.5))
            if((~ismember(i,anchor(2,:)))&(anchor(2,3)==0))
                anchor(2,3)=i;
            end
        end
        if((network(i,1)<4)&(network(i,1)>2)&(network(i,2)<9.6)&(network(i,2)>6.7))
            if((~ismember(i,anchor(2,:)))&(anchor(2,4)==0))
                anchor(2,4)=i;
            end
        end
        if((network(i,1)<8.5)&(network(i,1)>5)&(network(i,2)<9.6)&(network(i,2)>7.3))
            if((~ismember(i,anchor(2,:)))&(anchor(2,5)==0))
                anchor(2,5)=i;
            end
        end
    end
    anchor(2,:)=sort(anchor(2,:));
    for i=m:N
        if ((network(i,1)<2.8)&(network(i,1)>0.3)&(network(i,2)<5.8)&(network(i,2)>4))
            if ((~ismember(i,anchor(3,:)))&(anchor(3,1)==0))
                anchor(3,1)=i;
            end
        end
        if((network(i,1)<6)&(network(i,1)>3)&(network(i,2)<9.8)&(network(i,2)>8.6))
            if((~ismember(i,anchor(3,:)))&(anchor(3,2)==0))
                anchor(3,2)=i;
            end
        end
        if((network(i,1)<9.5)&(network(i,1)>6.5)&(network(i,2)<8.6)&(network(i,2)>7.1))
            if((~ismember(i,anchor(3,:)))&(anchor(3,3)==0))
                anchor(3,3)=i;
            end
        end
        if ((network(i,1)<4)&(network(i,1)>2)&(network(i,2)<2.8)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(3,:)))&(anchor(3,4)==0))
                anchor(3,4)=i;
            end
        end
        if ((network(i,1)<9)&(network(i,1)>6)&(network(i,2)<2.8)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(3,:)))&(anchor(3,5)==0))
                anchor(3,5)=i;
            end
        end
    end
    anchor(3,:)=sort(anchor(3,:));
    for i=m:N
        if ((network(i,1)<2)&(network(i,1)>0.3)&(network(i,2)<8.5)&(network(i,2)>6.5))
            if ((~ismember(i,anchor(4,:)))&(anchor(4,1)==0))
                anchor(4,1)=i;
            end
        end
        if((network(i,1)<7)&(network(i,1)>3)&(network(i,2)<9.8)&(network(i,2)>8.5))
            if((~ismember(i,anchor(4,:)))&(anchor(4,2)==0))
                anchor(4,2)=i;
            end
        end
        if((network(i,1)<9.8)&(network(i,1)>7)&(network(i,2)<8.5)&(network(i,2)>6.5))
            if((~ismember(i,anchor(4,:)))&(anchor(4,3)==0))
                anchor(4,3)=i;
            end
        end
        if ((network(i,1)<4)&(network(i,1)>2)&(network(i,2)<2.5)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(4,:)))&(anchor(4,4)==0))
                anchor(4,4)=i;
            end
        end
        if ((network(i,1)<9)&(network(i,1)>6)&(network(i,2)<2.5)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(4,:)))&(anchor(4,5)==0))
                anchor(4,5)=i;
            end
        end
    end
    anchor(4,:)=sort(anchor(4,:));
end

if(n==6)
    anchor=zeros(6,6); %four sets of anchors, each set has 6 anchor nodes
    for i=m:N
        if ((network(i,1)<10)&(network(i,1)>8.5)&(network(i,2)<10)&(network(i,2)>8.5))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,1)==0))
                anchor(1,1)=i;
            end
        end
        if((network(i,1)<10)&(network(i,1)>9)&(network(i,2)<2.5)&(network(i,2)>0.2))
            if((~ismember(i,anchor(1,:)))&(anchor(1,2)==0))
                anchor(1,2)=i;
            end
        end
        if((network(i,1)<1.5)&(network(i,1)>0.1)&(network(i,2)<1.2)&(network(i,2)>0.1))
            if((~ismember(i,anchor(1,:)))&(anchor(1,3)==0))
                anchor(1,3)=i;
            end
        end
        if((network(i,1)<1.3)&(network(i,1)>0.1)&(network(i,2)<=10)&(network(i,2)>8.7))
            if((~ismember(i,anchor(1,:)))&(anchor(1,4)==0))
                anchor(1,4)=i;
            end
        end
        if ((network(i,1)<3.2)&(network(i,1)>2)&(network(i,2)<7.5)&(network(i,2)>5.5))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,5)==0))
                anchor(1,5)=i;
            end
        end
        if ((network(i,1)<3.3)&(network(i,1)>2)&(network(i,2)<5)&(network(i,2)>3))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,6)==0))
                anchor(1,6)=i;
            end
        end
    end
    anchor(1,:)=sort(anchor(1,:));
    
    for i=m:N
        if ((network(i,1)<8)&(network(i,1)>5)&(network(i,2)<3)&(network(i,2)>0.7))
            if ((~ismember(i,anchor(2,:)))&(anchor(2,1)==0))
                anchor(2,1)=i;
            end
        end
        if ((network(i,1)<5)&(network(i,1)>3)&(network(i,2)<3.2)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(2,:)))&(anchor(2,2)==0))
                anchor(2,2)=i;
            end
        end
        if((network(i,1)<2.7)&(network(i,1)>0.3)&(network(i,2)<5)&(network(i,2)>3.2))
            if((~ismember(i,anchor(2,:)))&(anchor(2,3)==0))
                anchor(2,3)=i;
            end
        end
        if((network(i,1)<2.7)&(network(i,1)>1.3)&(network(i,2)<7)&(network(i,2)>4.8))
            if((~ismember(i,anchor(2,:)))&(anchor(2,4)==0))
                anchor(2,4)=i;
            end
        end
        if((network(i,1)<5)&(network(i,1)>3)&(network(i,2)<9.6)&(network(i,2)>6.7))
            if((~ismember(i,anchor(2,:)))&(anchor(2,5)==0))
                anchor(2,5)=i;
            end
        end
        if((network(i,1)<8)&(network(i,1)>5)&(network(i,2)<9.6)&(network(i,2)>7.3))
            if((~ismember(i,anchor(2,:)))&(anchor(2,6)==0))
                anchor(2,6)=i;
            end
        end
    end
    anchor(2,:)=sort(anchor(2,:));
    
    for i=m:N
        if ((network(i,1)<9.8)&(network(i,1)>6.5)&(network(i,2)<2.8)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(3,:)))&(anchor(3,1)==0))
                anchor(3,1)=i;
            end
        end
        if((network(i,1)<6.5)&(network(i,1)>3.3)&(network(i,2)<2.8)&(network(i,2)>0.3))
            if((~ismember(i,anchor(3,:)))&(anchor(3,2)==0))
                anchor(3,2)=i;
            end
        end
        if((network(i,1)<3.3)&(network(i,1)>0.3)&(network(i,2)<4)&(network(i,2)>1.5))
            if((~ismember(i,anchor(3,:)))&(anchor(3,3)==0))
                anchor(3,3)=i;
            end
        end
        if ((network(i,1)<9.8)&(network(i,1)>6.5)&(network(i,2)<9.8)&(network(i,2)>7))
            if ((~ismember(i,anchor(3,:)))&(anchor(3,4)==0))
                anchor(3,4)=i;
            end
        end
        if ((network(i,1)<6.5)&(network(i,1)>3.3)&(network(i,2)<9.8)&(network(i,2)>7))
            if ((~ismember(i,anchor(3,:)))&(anchor(3,5)==0))
                anchor(3,5)=i;
            end
        end
        if ((network(i,1)<3.3)&(network(i,1)>0.3)&(network(i,2)<8)&(network(i,2)>6))
            if ((~ismember(i,anchor(3,:)))&(anchor(3,6)==0))
                anchor(3,6)=i;
            end
        end
    end
    anchor(3,:)=sort(anchor(3,:));
    
    for i=m:N
        if ((network(i,1)<4.5)&(network(i,1)>3)&(network(i,2)<2.8)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(4,:)))&(anchor(4,1)==0))
                anchor(4,1)=i;
            end
        end
        if((network(i,1)<3.3)&(network(i,1)>1.3)&(network(i,2)<6)&(network(i,2)>3.5))
            if((~ismember(i,anchor(4,:)))&(anchor(4,2)==0))
                anchor(4,2)=i;
            end
        end
        if((network(i,1)<3.3)&(network(i,1)>0.3)&(network(i,2)<3.5)&(network(i,2)>1.5))
            if((~ismember(i,anchor(4,:)))&(anchor(4,3)==0))
                anchor(4,3)=i;
            end
        end
        if ((network(i,1)<9.8)&(network(i,1)>6.5)&(network(i,2)<9.2)&(network(i,2)>6.8))
            if ((~ismember(i,anchor(4,:)))&(anchor(4,4)==0))
                anchor(4,4)=i;
            end
        end
        if ((network(i,1)<6.5)&(network(i,1)>3.3)&(network(i,2)<9.8)&(network(i,2)>7.3))
            if ((~ismember(i,anchor(4,:)))&(anchor(4,5)==0))
                anchor(4,5)=i;
            end
        end
        if ((network(i,1)<3.3)&(network(i,1)>0.3)&(network(i,2)<8)&(network(i,2)>6))
            if ((~ismember(i,anchor(4,:)))&(anchor(4,6)==0))
                anchor(4,6)=i;
            end
        end
    end
    anchor(4,:)=sort(anchor(4,:));
    
    for i=m:N
        if ((network(i,1)<1.6)&(network(i,1)>0.2)&(network(i,2)<3)&(network(i,2)>2))
            if ((~ismember(i,anchor(5,:)))&(anchor(5,1)==0))
                anchor(5,1)=i;
            end
        end
        if((network(i,1)<3.3)&(network(i,1)>1.6)&(network(i,2)<2.1)&(network(i,2)>0.3))
            if((~ismember(i,anchor(5,:)))&(anchor(5,2)==0))
                anchor(5,2)=i;
            end
        end
        if((network(i,1)<5)&(network(i,1)>3.3)&(network(i,2)<3.5)&(network(i,2)>2))
            if((~ismember(i,anchor(5,:)))&(anchor(5,3)==0))
                anchor(5,3)=i;
            end
        end
        if ((network(i,1)<6.6)&(network(i,1)>5)&(network(i,2)<1.5)&(network(i,2)>0.2))
            if ((~ismember(i,anchor(5,:)))&(anchor(5,4)==0))
                anchor(5,4)=i;
            end
        end
        if ((network(i,1)<8.2)&(network(i,1)>6.6)&(network(i,2)<3)&(network(i,2)>1.2))
            if ((~ismember(i,anchor(5,:)))&(anchor(5,5)==0))
                anchor(5,5)=i;
            end
        end
        if ((network(i,1)<10)&(network(i,1)>8.2)&(network(i,2)<2)&(network(i,2)>0.6))
            if ((~ismember(i,anchor(5,:)))&(anchor(5,6)==0))
                anchor(5,6)=i;
            end
        end
    end
    anchor(5,:)=sort(anchor(5,:));
    
    for i=m:N
        if ((network(i,1)<2)&(network(i,1)>0.1)&(network(i,2)<1.6)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(6,:)))&(anchor(6,1)==0))
                anchor(6,1)=i;
            end
        end
        if((network(i,1)<3.3)&(network(i,1)>2)&(network(i,2)<3.2)&(network(i,2)>1.6))
            if((~ismember(i,anchor(6,:)))&(anchor(6,2)==0))
                anchor(6,2)=i;
            end
        end
        if((network(i,1)<2.4)&(network(i,1)>1)&(network(i,2)<5)&(network(i,2)>3.2))
            if((~ismember(i,anchor(6,:)))&(anchor(6,3)==0))
                anchor(6,3)=i;
            end
        end
        if ((network(i,1)<3.3)&(network(i,1)>2.3)&(network(i,2)<6.6)&(network(i,2)>5))
            if ((~ismember(i,anchor(6,:)))&(anchor(6,4)==0))
                anchor(6,4)=i;
            end
        end
        if ((network(i,1)<2)&(network(i,1)>0.1)&(network(i,2)<8.3)&(network(i,2)>6.6))
            if ((~ismember(i,anchor(6,:)))&(anchor(6,5)==0))
                anchor(6,5)=i;
            end
        end
        if ((network(i,1)<3.3)&(network(i,1)>2.3)&(network(i,2)<10)&(network(i,2)>8.3))
            if ((~ismember(i,anchor(6,:)))&(anchor(6,6)==0))
                anchor(6,6)=i;
            end
        end
    end
    anchor(6,:)=sort(anchor(6,:));
    
    hold off;
    subplot(2,3,1);
    plot(network(:,1),network(:,2),'bo');
    hold on;
    plot(network(anchor(1,1),1),network(anchor(1,1),2),'ro',network(anchor(1,2),1),...
        network(anchor(1,2),2),'ro',network(anchor(1,3),1),network(anchor(1,3),2),'ro',...
        network(anchor(1,4),1),network(anchor(1,4),2),'ro',network(anchor(1,5),1),network(anchor(1,5),2),...
        'ro',network(anchor(1,6),1),network(anchor(1,6),2),'ro');
    subplot(2,3,2);
    plot(network(:,1),network(:,2),'bo');
    hold on;
    plot(network(anchor(2,1),1),network(anchor(2,1),2),'ro',network(anchor(2,2),1),...
        network(anchor(2,2),2),'ro',network(anchor(2,3),1),network(anchor(2,3),2),'ro',...
        network(anchor(2,4),1),network(anchor(2,4),2),'ro',network(anchor(2,5),1),network(anchor(2,5),2),...
        'ro',network(anchor(2,6),1),network(anchor(2,6),2),'ro');
    subplot(2,3,3);
    plot(network(:,1),network(:,2),'bo');
    hold on;
    plot(network(anchor(3,1),1),network(anchor(3,1),2),'ro',network(anchor(3,2),1),...
        network(anchor(3,2),2),'ro',network(anchor(3,3),1),network(anchor(3,3),2),'ro',...
        network(anchor(3,4),1),network(anchor(3,4),2),'ro',network(anchor(3,5),1),network(anchor(3,5),2),...
        'ro',network(anchor(3,6),1),network(anchor(3,6),2),'ro');
    subplot(2,3,4);
    plot(network(:,1),network(:,2),'bo');
    hold on;
    plot(network(anchor(4,1),1),network(anchor(4,1),2),'ro',network(anchor(4,2),1),...
        network(anchor(4,2),2),'ro',network(anchor(4,3),1),network(anchor(4,3),2),'ro',...
        network(anchor(4,4),1),network(anchor(4,4),2),'ro',network(anchor(4,5),1),network(anchor(4,5),2),...
        'ro',network(anchor(4,6),1),network(anchor(4,6),2),'ro');
    subplot(2,3,5);
    plot(network(:,1),network(:,2),'bo');
    hold on;
    plot(network(anchor(5,1),1),network(anchor(5,1),2),'ro',network(anchor(5,2),1),...
        network(anchor(5,2),2),'ro',network(anchor(5,3),1),network(anchor(5,3),2),'ro',...
        network(anchor(5,4),1),network(anchor(5,4),2),'ro',network(anchor(5,5),1),network(anchor(5,5),2),...
        'ro',network(anchor(5,6),1),network(anchor(5,6),2),'ro');
    subplot(2,3,6);
    plot(network(:,1),network(:,2),'bo');
    hold on;
    plot(network(anchor(6,1),1),network(anchor(6,1),2),'ro',network(anchor(6,2),1),...
        network(anchor(6,2),2),'ro',network(anchor(6,3),1),network(anchor(6,3),2),'ro',...
        network(anchor(6,4),1),network(anchor(6,4),2),'ro',network(anchor(6,5),1),network(anchor(6,5),2),...
        'ro',network(anchor(6,6),1),network(anchor(6,6),2),'ro');
    
end

if(n==8)
    anchor=zeros(2,8);
    for i=m:N
        if ((network(i,1)<6.5)&(network(i,1)>3.5)&(network(i,2)<1.8)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,1)==0))
                anchor(1,1)=i;
            end
        end
        if((network(i,1)<9.8)&(network(i,1)>7)&(network(i,2)<2.8)&(network(i,2)>1.1))
            if((~ismember(i,anchor(1,:)))&(anchor(1,2)==0))
                anchor(1,2)=i;
            end
        end
        if((network(i,1)<3.5)&(network(i,1)>0.3)&(network(i,2)<2.6)&(network(i,2)>0.7))
            if((~ismember(i,anchor(1,:)))&(anchor(1,3)==0))
                anchor(1,3)=i;
            end
        end
        if((network(i,1)<2.1)&(network(i,1)>0.3)&(network(i,2)<=5)&(network(i,2)>2.6))
            if((~ismember(i,anchor(1,:)))&(anchor(1,4)==0))
                anchor(1,4)=i;
            end
        end
        if ((network(i,1)<2.7)&(network(i,1)>0.3)&(network(i,2)<7.5)&(network(i,2)>5))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,5)==0))
                anchor(1,5)=i;
            end
        end
        if ((network(i,1)<3.5)&(network(i,1)>1.6)&(network(i,2)<9.8)&(network(i,2)>7))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,6)==0))
                anchor(1,6)=i;
            end
        end
        if ((network(i,1)<6.5)&(network(i,1)>3.5)&(network(i,2)<8.8)&(network(i,2)>7))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,7)==0))
                anchor(1,7)=i;
            end
        end
        if ((network(i,1)<9.8)&(network(i,1)>7)&(network(i,2)<9.8)&(network(i,2)>7.8))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,8)==0))
                anchor(1,8)=i;
            end
        end
    end
    anchor(1,:)=sort(anchor(1,:));
    
    for i=m:N
        if ((network(i,1)<2.5)&(network(i,1)>0.2)&(network(i,2)<9.8)&(network(i,2)>7.5))
            if ((~ismember(i,anchor(2,:)))&(anchor(2,1)==0))
                anchor(2,1)=i;
            end
        end
        if ((network(i,1)<3)&(network(i,1)>2)&(network(i,2)<7.5)&(network(i,2)>5))
            if ((~ismember(i,anchor(2,:)))&(anchor(2,2)==0))
                anchor(2,2)=i;
            end
        end
        if((network(i,1)<2.5)&(network(i,1)>0.2)&(network(i,2)<5)&(network(i,2)>2.5))
            if((~ismember(i,anchor(2,:)))&(anchor(2,3)==0))
                anchor(2,3)=i;
            end
        end
        if((network(i,1)<2.5)&(network(i,1)>0.3)&(network(i,2)<2.5)&(network(i,2)>0.2))
            if((~ismember(i,anchor(2,:)))&(anchor(2,4)==0))
                anchor(2,4)=i;
            end
        end
        if((network(i,1)<4.5)&(network(i,1)>2.5)&(network(i,2)<9.6)&(network(i,2)>7))
            if((~ismember(i,anchor(2,:)))&(anchor(2,5)==0))
                anchor(2,5)=i;
            end
        end
        if((network(i,1)<6.5)&(network(i,1)>4.5)&(network(i,2)<9.6)&(network(i,2)>7))
            if((~ismember(i,anchor(2,:)))&(anchor(2,6)==0))
                anchor(2,6)=i;
            end
        end
        if((network(i,1)<4.5)&(network(i,1)>2.5)&(network(i,2)<2.8)&(network(i,2)>0.9))
            if((~ismember(i,anchor(2,:)))&(anchor(2,7)==0))
                anchor(2,7)=i;
            end
        end
        if((network(i,1)<6.5)&(network(i,1)>4.5)&(network(i,2)<1.5)&(network(i,2)>0.2))
            if((~ismember(i,anchor(2,:)))&(anchor(2,8)==0))
                anchor(2,8)=i;
            end
        end
    end
    anchor(2,:)=sort(anchor(2,:));
    hold off;
    subplot(1,2,1);
    plot(network(:,1),network(:,2),'bo');
    hold on;
    plot(network(anchor(1,1),1),network(anchor(1,1),2),'ro',network(anchor(1,2),1),...
        network(anchor(1,2),2),'ro',network(anchor(1,3),1),network(anchor(1,3),2),'ro',...
        network(anchor(1,4),1),network(anchor(1,4),2),'ro',network(anchor(1,5),1),network(anchor(1,5),2),...
        'ro',network(anchor(1,6),1),network(anchor(1,6),2),'ro',network(anchor(1,7),1),...
        network(anchor(1,7),2),'ro',network(anchor(1,8),1),network(anchor(1,8),2),'ro');
    subplot(1,2,2);
    plot(network(:,1),network(:,2),'bo');
    hold on;
    plot(network(anchor(2,1),1),network(anchor(2,1),2),'ro',network(anchor(2,2),1),...
        network(anchor(2,2),2),'ro',network(anchor(2,3),1),network(anchor(2,3),2),'ro',...
        network(anchor(2,4),1),network(anchor(2,4),2),'ro',network(anchor(2,5),1),network(anchor(2,5),2),...
        'ro',network(anchor(2,6),1),network(anchor(2,6),2),'ro',network(anchor(2,7),1),...
        network(anchor(2,7),2),'ro',network(anchor(2,8),1),network(anchor(2,8),2),'ro');
    
end

if(n==10)
    anchor=zeros(1,10);
    for i=m:N
        if ((network(i,1)<9.8)&(network(i,1)>7.5)&(network(i,2)<2.0)&(network(i,2)>0.3))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,1)==0))
                anchor(1,1)=i;
            end
        end
        if((network(i,1)<7.5)&(network(i,1)>5)&(network(i,2)<2.9)&(network(i,2)>1.6))
            if((~ismember(i,anchor(1,:)))&(anchor(1,2)==0))
                anchor(1,2)=i;
            end
        end
        if((network(i,1)<5)&(network(i,1)>2.5)&(network(i,2)<1.3)&(network(i,2)>0.3))
            if((~ismember(i,anchor(1,:)))&(anchor(1,3)==0))
                anchor(1,3)=i;
            end
        end
        if((network(i,1)<2.5)&(network(i,1)>0.3)&(network(i,2)<2.9)&(network(i,2)>1.7))
            if((~ismember(i,anchor(1,:)))&(anchor(1,4)==0))
                anchor(1,4)=i;
            end
        end
        if((network(i,1)<2.1)&(network(i,1)>0.3)&(network(i,2)<=5)&(network(i,2)>2.6))
            if((~ismember(i,anchor(1,:)))&(anchor(1,5)==0))
                anchor(1,5)=i;
            end
        end
        if ((network(i,1)<2.7)&(network(i,1)>1.5)&(network(i,2)<7.5)&(network(i,2)>5))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,6)==0))
                anchor(1,6)=i;
            end
        end
        if ((network(i,1)<2.5)&(network(i,1)>0.3)&(network(i,2)<9.8)&(network(i,2)>7.3))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,7)==0))
                anchor(1,7)=i;
            end
        end
        if ((network(i,1)<5)&(network(i,1)>2.5)&(network(i,2)<8.8)&(network(i,2)>7))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,8)==0))
                anchor(1,8)=i;
            end
        end
        if ((network(i,1)<7.5)&(network(i,1)>5)&(network(i,2)<9.8)&(network(i,2)>8))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,9)==0))
                anchor(1,9)=i;
            end
        end
        if ((network(i,1)<9.9)&(network(i,1)>7.5)&(network(i,2)<8.8)&(network(i,2)>7))
            if ((~ismember(i,anchor(1,:)))&(anchor(1,10)==0))
                anchor(1,10)=i;
            end
        end
    end
    anchor(1,:)=sort(anchor(1,:));
    hold off
    plot(network(:,1),network(:,2),'bo')
    hold on
    plot(network(anchor(1,1),1),network(anchor(1,1),2),'ro',network(anchor(1,2),1),...
        network(anchor(1,2),2),'ro',network(anchor(1,3),1),network(anchor(1,3),2),'ro',...
        network(anchor(1,4),1),network(anchor(1,4),2),'ro',network(anchor(1,5),1),network(anchor(1,5),2),...
        'ro',network(anchor(1,6),1),network(anchor(1,6),2),'ro',network(anchor(1,7),1),...
        network(anchor(1,7),2),'ro',network(anchor(1,8),1),network(anchor(1,8),2),'ro',...
        network(anchor(1,9),1),network(anchor(1,9),2),'ro',...
        network(anchor(1,10),1),network(anchor(1,10),2),'ro')
end

    

    