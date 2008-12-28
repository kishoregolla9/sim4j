function [network]=netDeployment(network,type,size,N,length)
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
%length - length of the network, for rectangles (default 25)

  switch type
    case 0  % random
        network.points=rand(N,2)*size;
        network.shape=sprintf('Random %ix%i',size,size)

    case 1  %In grid case, N=size*size
        network.shape=sprintf('Grid %ix%i',size,size)
        points=[];
        for i=1:size
            a_fixed=1:size;
            delta =(rand(1,size)-0.5*ones(1,size))*0.4;
            a=a_fixed+delta;
            b_fixed =zeros(1,size);
            delta =(rand(1,size)-0.5*ones(1,size))*0.4;
            b=b_fixed+delta+i;
            points=[points; a' b'];
        end
        network.points=points
        network.numberOfNodes=size*size;        
    case 2 %C-shape random
        network.shape=sprintf('C-Shape Random %ix%i',size,size)
        fraction = 0.3;
        network.points=zeros(N,2);
        for j = 1:N
            new_points = rand(1,2);
            while (new_points(1) > fraction) && (new_points(2) > fraction) && ...
                    (new_points(2) < (1- fraction))
                new_points = rand(1,2);
            end
            network.points(j,:) = new_points*size;
        end
        
    case 3  %C-shape grid, N is not used. N is determined by size.
        network.shape=sprintf('C-Shape Grid %ix%i',size,size)
        fraction = 0.3;
        index = 1;
        network.points=zeros(N,2);
        for i=1:size
            if (i <= size*fraction)
                for j=1:size
                    network.points(index, 1) = i+(rand-0.5)*0.4;
                    network.points(index, 2) = j+(rand-0.5)*0.4;
                    index = index + 1;
                end
            else
                for j=1:size*fraction
                    network.points(index, 1) = i+(rand-0.5)*0.4;
                    network.points(index, 2) = j+(rand-0.5)*0.4;
                    index = index + 1;
                end
                for j= size*(1-fraction):size
                    network.points(index, 1) = i+(rand-0.5)*0.4;
                    network.points(index, 2) = j+(rand-0.5)*0.4;
                    index = index + 1;
                end
            end
        end
        
    case 4 %rectangle random. size is the width to length ratio.
        network.shape=sprintf('Rectangle Random %ix%i',size,length)
        network.points=zeros(N,2);
        for j = 1:N
            new_points = rand(1,2);
            while (new_points(2) > size)
                new_points = rand(1,2);
            end
            network.points(j,:) = new_points*length; 
        end

    case 5 % Rectangle grid with 20% placement error
        network.shape=sprintf('Rectangle Grid(20\%error) %ix%i',size,length)        
        deploy_width=size;
        network.points=zeros(deploy_width,2);
        for i=1:deploy_width
            a_fixed=1:N;
            delta =(rand(1,N)-0.5*ones(1,N))*0.4;
            a=a_fixed+delta;
            b_fixed =zeros(1,N);
            delta =(rand(1,N)-0.5*ones(1,N))*0.4;
            b=b_fixed+delta+i;
            network.points=[network; a' b'];
        end

    case 6  %L-shape random
        fraction = 0.3;
        network.shape=sprintf('L-Shape Random %ix%i',N,length)                
        network.points=zeros(N,2);
        for j = 1:N
            new_points = rand(1,2);
            while (new_points(1) > fraction) && (new_points(2) > fraction)
                new_points = rand(1,2);
            end
            network.points(j,:) = new_points*size;
        end


    case 7 %In L-shape grid case, we get about 51 nodes
        network.shape=sprintf('L-Shape Grid %ix%i',size,length)
        rawNetwork=zeros(N,2);
        network.points=zeros(N,2);
        for i=1:size
            a_fixed=1:size;
            delta =(rand(1,size)-0.5*ones(1,size))*0.4;
            a=a_fixed+delta;
            b_fixed =zeros(1,size);
            delta =(rand(1,size)-0.5*ones(1,size))*0.4;
            b=b_fixed+delta+i;
            rawNetwork=[rawNetwork; a' b'];
        end
        %now we have a square grid. Kick out the ones not in the L-shape
        
        N=size*size;
        fraction=0.32*size;
        jj=1;
        for ii=1:N
            if (rawNetwork(ii,1)>fraction) && (rawNetwork(ii,2)>fraction)
                rawNetwork(ii,:);
            else
                network.points(jj,:)=rawNetwork(ii,:);
                jj=jj+1;
            end
        end

    case 8 %loop random
        network.shape=sprintf('Loop Random %ix%i',size,length)
        network.points=zeros(N,2);
        fraction = 0.2;
        for j = 1:N
            new_points = rand(1,2);
            while (new_points(1) > fraction) && (new_points(2) > fraction) ... 
                    && (new_points(2) < (1- fraction)) ... 
                    && (new_points(1)<(1- fraction))
                new_points = rand(1,2);
            end
            network.points(j,:) = new_points*size;
        end

    case 9 %In loop grid case, we get about 51-64 nodes. N is not used
        network.shape=sprintf('Loop Grid %ix%i',size,length)
        network.points=zeros(N,2);        
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
                network.points(jj,:)=rawNetwork(ii,:);
                jj=jj+1;
            end
        end

    case 10  % irregular shape
        network.shape=sprintf('Irregular %ix%i',size,length)
        xdist = sin(pi/3);
        ydist = 1;
        network.points=zeros(N, 2);
        for i=1:size
            if mod(i,2) == 0
                for j=1:size
                    network.points((i-1)*size+j, 1) = i*xdist+randn*0.05;
                    network.points((i-1)*size+j, 2) = j*ydist+randn*0.3;
                end
            else
                for j=1:size
                    network.points((i-1)*size+j, 1) = i*xdist+randn*0.05;
                    network.points((i-1)*size+j, 2) = j*ydist+randn*0.05+0.5;
                end
            end
        end
        
  end
 
end
