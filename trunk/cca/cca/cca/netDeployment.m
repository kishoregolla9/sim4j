function [network]=netDeployment(type,size,N)
%Li - Oct. 2006, modified April 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function netDeployment generates a network given the number of nodes, the
%size and the type
%network -output coordinates of the nodes deployed
%type - 0/1/2/3/4/5/6/7/8/9/10 
%  0:random square
%  1:grid square with 10% average placement errors
%  2:C-shape random
%  3:C-shape grid
%  4:rectangle random
%  5:rectangle grid with 10% placement error (length=N, width=size)
%  6:L-shape random
%  7:L-shape grid with 10% placement error)
%  8:loop random
%  9:loop grid with 10% placement error
%  10:irregular
%size - edge size of a square area for deployment. e.g., if size=r, then
%  the deployment area is rxr. in the rectangle random, size is the width to
%  length (length is taken as 10 unit) ratio
%N - number of nodes in most cases. 
%  In square grid, N=sizexsize; 
%  In rectangle grid, Nxsize is the nubmer of nodes where size is the width and N length. 
%  In C shape grid, N is about 79 when size=10; in L-shape grid, N is about 51

if (type==0) %random 
    network=rand(N,2)*size;
end

if (type==1)%In grid case, N=size*size
    network=[];
    for i=1:size
        a_fixed=1:size;
        delta =(rand(1,size)-0.5*ones(1,size))*0.4;
        a=a_fixed+delta;
        b_fixed =zeros(1,size);
        delta =(rand(1,size)-0.5*ones(1,size))*0.4;
        b=b_fixed+delta+i;
        network=[network; a' b'];
    end
end

if (type==2)%C-shape random
    fraction = 0.3;
    for j = 1:N
        new_points = rand(1,2);
        while (new_points(1) > fraction) & (new_points(2) > fraction) & ...
                (new_points(2) < (1- fraction))
            new_points = rand(1,2);
        end
        network(j,:) = new_points*size;
    end
end

if (type==3) %C-shape grid, N is not used. N is determined by size. 
    fraction = 0.3;
        index = 1;
        for i=1:size
            if (i <= size*fraction)
                for j=1:size
                    network(index, 1) = i+(rand-0.5)*0.4;
                    network(index, 2) = j+(rand-0.5)*0.4;
                    index = index + 1;
                end
            else
                for j=1:size*fraction
                    network(index, 1) = i+(rand-0.5)*0.4;
                    network(index, 2) = j+(rand-0.5)*0.4;
                    index = index + 1;
                end
                for j= size*(1-fraction):size
                    network(index, 1) = i+(rand-0.5)*0.4;
                    network(index, 2) = j+(rand-0.5)*0.4;
                    index = index + 1;
                end
            end
        end  
end

if(type==4) %rectangle random. size is the width to length ratio.Length is 25.
    for j = 1:N
        new_points = rand(1,2);
        while (new_points(2) > size) 
            new_points = rand(1,2);
        end
        network(j,:) = new_points*25; %can change 25 to other values wanted
    end
end
    
if (type==5)%rectangle grid with 20% placement error
    network=[];
    deploy_width=size;
    for i=1:deploy_width
        a_fixed=1:N;
        delta =(rand(1,N)-0.5*ones(1,N))*0.4;
        a=a_fixed+delta;
        b_fixed =zeros(1,N);
        delta =(rand(1,N)-0.5*ones(1,N))*0.4;
        b=b_fixed+delta+i;
        network=[network; a' b'];
    end
end

if (type==6)  %L-shape random
    fraction = 0.3;
    for j = 1:N
        new_points = rand(1,2);
        while (new_points(1) > fraction) & (new_points(2) > fraction)
            new_points = rand(1,2);
        end
        network(j,:) = new_points*size;
    end
end

if (type==7)%In L-shape grid case, we get about 51 nodes
    rawNetwork=[];
    for i=1:size
        a_fixed=1:size;
        delta =(rand(1,size)-0.5*ones(1,size))*0.4;
        a=a_fixed+delta;
        b_fixed =zeros(1,size);
        delta =(rand(1,size)-0.5*ones(1,size))*0.4;
        b=b_fixed+delta+i;
        rawNetwork=[rawNetwork; a' b'];
    end %now we have a square grid. Kick out the ones not in the L-shape
    N=size*size;
    fraction=0.32*size;
    jj=1;
    for ii=1:N
        if (rawNetwork(ii,1)>fraction)&(rawNetwork(ii,2)>fraction)
            rawNetwork(ii,:);
        else
            network(jj,:)=rawNetwork(ii,:);
            jj=jj+1;
        end
    end            
end

if (type==8)%loop random
    fraction = 0.2;
    for j = 1:N
        new_points = rand(1,2);
        while (new_points(1) > fraction) & (new_points(2) > fraction) & ...
                (new_points(2) < (1- fraction))&(new_points(1)<(1- fraction))
            new_points = rand(1,2);
        end
        network(j,:) = new_points*size;
    end
end

if (type==9)%In loop grid case, we get about 51-64 nodes. N is not used
    rawNetwork=[];
    for i=1:size
        a_fixed=1:size;
        delta =(rand(1,size)-0.5*ones(1,size))*0.4;
        a=a_fixed+delta;
        b_fixed =zeros(1,size);
        delta =(rand(1,size)-0.5*ones(1,size))*0.4;
        b=b_fixed+delta+i;
        rawNetwork=[rawNetwork; a' b'];
    end %now we have a square grid. Kick out the ones not to form the perimeter
    N=size*size;
    fraction=0.35*size;
    fraction1=size-(fraction-0.13*size);
    jj=1;
    for ii=1:N
        if (rawNetwork(ii,1)>fraction)&(rawNetwork(ii,2)>fraction)&...
                (rawNetwork(ii,2) < fraction1)&(rawNetwork(ii,1)<fraction1)
            rawNetwork(ii,:);
        else
            network(jj,:)=rawNetwork(ii,:);
            jj=jj+1;
        end
    end            
end

if (type==10)
    xdist = sin(pi/3);
    ydist = 1;
    for i=1:size
        if mod(i,2) == 0
            for j=1:size
                points((i-1)*size+j, 1) = i*xdist+randn*0.05;
                points((i-1)*size+j, 2) = j*ydist+randn*0.3;
            end
        else
            for j=1:size
                points((i-1)*size+j, 1) = i*xdist+randn*0.05;
                points((i-1)*size+j, 2) = j*ydist+randn*0.05+0.5;
            end
        end            
    end 
    network=points;
    %network=network+rand(size*size,2)*0.05;
    
end

